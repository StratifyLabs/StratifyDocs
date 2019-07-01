---
date: "2019-06-27"
layout: post
title: Writing Device Drivers
slug: Guide-Writing-Device-Drivers
katex: true
---

Creating device drivers for Stratify OS is a matter of implementing 5 function calls that correspond to open(), close(), read(), write(), and ioctl(). The device filesystem uses these calls when a user accesses a device. 

## The Device Filesystem

The device filesystem is a filesystem that is typically mounted at "/dev" and provides access to MCU peripheral hardware as well as other hardware specific drivers. The call chain looks like this when an application accesses the hardware.

- Application calls open()
- open() resolves the path to a filesystem. If the path is "/dev/...", it calls devfs_open()
- devfs_open() resolves the path further to a specific device. If the path is "/dev/uart0", it calls the driver associated with uart0 (usually mcu_uart_open()). devfs_open() will create a handle that gets associated with a file description (int) that can be used with read(), write(), close(), or ioctl()
- When the application calls read(), the file descriptor contains the associated filesystem and handle and calls devfs_read(). devfs_read() uses the handle to call mcu_uart_read() (or whatever is associatd with the file descriptor).

> **Note**
> One important thing to note is that the devfs_*() calls change the execution mode from unprivileged to privileged. In unprivileged mode, the application memory is protected from other processes but no access to hardware registers is allowed. In privileged mode, the code has complete control over the chip without any memory protection.

The board support package (BSP) determines which devices are included in the device filesystem (determined at build time) and where the device filesystem is mounted.

### Device List

First the list of devices is declared:

```c
const devfs_device_t devfs_list[] = {
    //System devices
    DEVFS_DEVICE("trace", ffifo, 0, &board_trace_config, &board_trace_state, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_DEVICE("fifo", cfifo, 0, &board_fifo_config, &board_fifo_state, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_DEVICE("stdio-out", fifo, 0, &stdio_out_config, &stdio_out_state, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_DEVICE("stdio-in", fifo, 0, &stdio_in_config, &stdio_in_state, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_DEVICE("link-phy-usb", usbfifo, SOS_BOARD_USB_PORT, &sos_link_transport_usb_fifo_cfg, &sos_link_transport_usb_fifo_state, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_DEVICE("switchboard", switchboard, 0, &switchboard_config, switchboard_state, 0666, SOS_USER_ROOT, S_IFBLK),
    DEVFS_DEVICE("sys", sys, 0, 0, 0, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_DEVICE("null", null, 0, 0, 0, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_DEVICE("zero", zero, 0, 0, 0, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_DEVICE("random", random, 0, 0, 0, 0666, SOS_USER_ROOT, S_IFCHR),
    DEVFS_TERMINATOR
};

```

The DEVFS_DEVICE() macro takes the following arguments:

- Name: entry in /dev folder
- Device driver prefix: e.g. sys for sys_open(), sys_close(), sys_read(), sys_write(), and sys_ioctl()
- Port number: this is usually used with MCU peripherals like UART0, UART1, etc
- Configuration pointer: this can be a pointer to const data that the driver may use. For example, to tell the driver where buffers are and how large they are.
- State pointer: this is a pointer to read/write data that the driver can modify. For example, a FIFO uses the state to keep track of the head and the tail in the FIFO.
- Permissions: determines access by root or user
- Owner: determines ownership (root or user)
- Type: devices can be block or character devices

## Null Driver

The null driver is the easiest to implement. It looks like this:

```c
int null_open(const devfs_handle_t * handle){
    //return zero to indicate success
	return 0;
}

int null_ioctl(const devfs_handle_t * handle, int request, void * ctl){
    //The SYSFS_SET_RETURN macro encode the source file line number and the error number
    //The line number*-1 is returned and the error number is assigned to errno
    return SYSFS_SET_RETURN(ENOTSUP);
}

int null_read(const devfs_handle_t * handle, devfs_async_t * async){
    return -1; //EOF
}

int null_write(const devfs_handle_t * handle, devfs_async_t * async){
    //accept the data -- returns the number of bytes written
    return async->nbyte;
}

int null_close(const devfs_handle_t * handle){
	return 0;
}
```

The null device accepts any data written to it. It returns EOF if read and doesn't do anything when opening and closing nor does it respond to any ioctl() requests.

There are a few important things to note from the null driver:

- SYSFS_SET_RETURN(<error number>) is used to return the error number. The device filesystem will decode the error number and assign it to errno. The return value will be the line number of the call to SYSFS_SET_RETURN(). This makes it easy to debug if the driver returns the same errno in multiple locations.
- null_read() returns less than zero. When <device>_read() or <device>_write() return less than zero, this tells the device filesystem that there was an error and no data will be read or written.
- null_write() returns greater than zero. When <device>_read() or <device>_write() returns greater than zero, this tells the device filesystem that the operation occurred synchronously and the data transfer is complete.
- When <device>_read() or <device>_write() return zero, this tells the device filesystem that the operation is still in progress (asynchronous) and that the callback will be executed when the operation is complete. The callback is defined in the devfs_async_t data structure.

When an operation is asynchronous, the device filesystem will handle blocking the calling thread. The POSIX functions aio_read() and aio_write() allow the user to execute asynchronous reads and writes using the device filesystem.

## UART Driver

The null driver shows the basics but we need something more complicated to demonstrate the true power of Stratify OS drivers.

The UART is powered up on open() and powered down on close(). The UART responds to ioctl() requests in order to set the line attributes and read information about the driver.  Every driver has a driver interface header file located in sos/dev.

### UART Driver Interface

```c
#include <sos/dev/uart.h>
```

The driver interface header defines the data structures and requests that the UART will respond to. All MCU peripheral drivers (and most other drivers) respond to a similar set of requests(e.g. SPI version request is `I_SPI_GETVERSION`).

```c
#define I_UART_GETVERSION _IOCTL(UART_IOC_IDENT_CHAR, I_MCU_GETVERSION)
#define I_UART_GETINFO _IOCTLR(UART_IOC_IDENT_CHAR, I_MCU_GETINFO, uart_info_t)
#define I_UART_SETATTR _IOCTLW(UART_IOC_IDENT_CHAR, I_MCU_SETATTR, uart_attr_t)
#define I_UART_SETACTION _IOCTLW(UART_IOC_IDENT_CHAR, I_MCU_SETACTION, mcu_action_t)
```

These requests are implemented on almost every driver.

- Get version: gets the version of the driver in BCD format. The most significant digit MUST match the installed SDK.
- Get information: gets the uart_info_t which tells which flags and events are support along with other driver information.
- Set attributes: uses the uart_attr_t data structure to configure the UART.
- Set action: this is only available to kernel code and is used to adjust the interrupt priority and install special callbacks

The UART defines some additional requests which deal specifically with using the UART.

```c
#define I_UART_GET _IOCTLR(UART_IOC_IDENT_CHAR, I_MCU_TOTAL + 0, char)
#define I_UART_PUT _IOCTL(UART_IOC_IDENT_CHAR, I_MCU_TOTAL + 1)
#define I_UART_FLUSH _IOCTL(UART_IOC_IDENT_CHAR, I_MCU_TOTAL + 2)
```

### UART Driver Implementation

The driver needs to bridge the gap between the driver interface header and the MCU registers and interrupt service routines.

The driver does need to check if the call is blocking or non-blocking which looks like this for a generic UART driver:

```
int uart_open(const devfs_handle_t * handle){
    //power on the device and increment the reference
	return 0;
}

int uart_ioctl(const devfs_handle_t * handle, int request, void * ctl){
    const uart_attr_t * attr = ctl
    switch(request){
        case I_UART_GETVERSION: return UART_VERSION;
        case I_UART_SETATTR:
            //decode attr and configure the UART to be match the attributes as closely as possible


            if( attr->o_flags & )

            return 0; //if successful
            break;
    }
    return SYSFS_SET_RETURN(ENOTSUP);
}

int uart_read(const devfs_handle_t * handle, devfs_async_t * async){
    return -1; //EOF
}

int uart_write(const devfs_handle_t * handle, devfs_async_t * async){
    //accept the data -- returns the number of bytes written
    return async->nbyte;
}

int uart_close(const devfs_handle_t * handle){
	return 0;
}
```

#### Opening and Closing the UART

The following code is pulled from the STM32 UART driver. When the UART is opened, it will enable the clocks and interrupts on the UART and start counting how many times the UART has been opened. When the UART has been closed as many times as it has been opened, the clocks and interrupts are disabled.

```c

//mcu_uart_open() and mcu_uart_close()

```

#### IOCTL Calls

The UART driver utilizes the following macro to define the `mcu_uart_ioctl()` function.

```c


```



