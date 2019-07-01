---
date: "2019-06-27"
layout: post
title: Understanding Sockets on Stratify OS
katex: true
slug: Guide-Sockets
menu:
  sidebar:
    name: Sockets
    parent: Guides
---

Stratify OS sockets are based on BSD sockets and implement the POSIX API. The StratifyAPI library provide easy-to-use classes for programming sockets:

- [inet::Socket]() allows for direct access to connect(), listen(), bind(), read(), write(), socket(), and close()
- [inet::SecureSocket]() is the same as inet::Socket but runs over TLS
- [inet::HttpClient] implements portions of the HTTP protocol to easily download files and interact with REST APIs

Stratify OS also includes [var::Json]() data handling to easily transact data with web applications.

## Under the Hood

Applications don't actually include the TCP/IP/TLS software stack. That code is part of the OS package. These stacks can be implemented directly in the OS (using LWIP and mbedtls for example) or portions may be implemented off chip through some kind of serialization protocol to, for example, an cellular module with built in TCP/IP. Either way, programming socket applications is exactly the same. In fact, the application binary is even compatible with boards that implement the TCP/IP on chip vs through a serialization protocol.

As an application developer, the only thing to worry about is whether the hardware and OS package support sockets or not. This can be done with the following code snippet using the StratifyAPI.

```
#include <sapi.sys.hpp>

if( Sys::is_socket_api_available() == true ){
    printf("this board has sockets!\n");
}

if( Sys::is_secure_socket_api_available() == true ){
    printf("this board supports secure sockets\n");
}
```

# The SNTP Application

Syncing your device's time with internet time is a great example of using sockets. Of course, Stratify OS has a pre-built application that you can simply install and run in order to accomplish this. But since we want to understand socket programming we will do it the hard way.  The following code snippet is actually taken from the sntp application source code.

On the client side, the basic sequence of POSIX socket calls is:

- socket() allocate a socket file descriptor
- connect() connect to a server
- write() send a request to the server
- read() listen for the server response
- close() close the connection and free the file descriptor

```c++
#include <sapi/inet.hpp>

#define NTP_TIMESTAMP_DELTA 2208988800ULL //defines how the NTP epoch differs from POSIX epoch


Data packet(sizeof(u32));  //declare a 4 byte data object
int result;
u32 i;
packet.fill(0); //set our initial packet value to zero

var::Vector<SocketAddressInfo> address_list;
SocketAddressInfo address_info(SocketAddressInfo::FAMILY_INET,
                                            SocketAddressInfo::TYPE_STREAM,
                                            SocketAddressInfo::PROTOCOL_TCP);

//this is going to use the POSIX call getaddrinfo() to get a list of IP address for a domain
address_list = address_info.fetch_node("time.nist.gov");

//try each address until we can connect to one
for(i=0; i < address_list.count(); i++){

    //use the first address and set the port to 37
    SocketAddress socket_address(address_list.at(i), 37);
    Socket socket; //declare our socket

    //This is equivalent to the POSIX socket() call -- allocates a file descriptor for a new socket
    if( socket.create(socket_address) < 0 ){
        p.error("Failed to create socket");
        continue;
    }

    //POSIX connect() call on our socket to open new connection to the server
    if( (result = socket.connect(socket_address)) < 0 ){
        p.error("Failed to connect to socket address -> %s:%d (%d, %d)",
                    socket_address.address_to_string().cstring(),
                    socket_address.port(),
                    socket.error_number(),
                    result);
        continue;
    }

    //the time protocol specifies we write 4 bytes and the time will be sent back
    packet.to_u32()[0] = 0;
    if( (result = socket.write(packet)) != (int)packet.size() ){
        p.error("failed to send the whole packet (%d, %d)", result, socket.error_number());
        continue;
    }

    //now the server will respond with 4 bytes
    int size = packet.size();
    if( (result = socket.read(packet)) != size ){
        p.error("response wasn't right (%d, %d)", result, socket.error_number());
        continue;
    }
    break;
}

if( i == address_list.count() ){
    return 0;
}

//we convert the packet from network to host byte order
packet.to_u32()[0] = ntohl(packet.at_u32(0));

//now we have a time_t value by subtracting the NTP epoch to POSIX epoch fudge factor
time_t t = packet.at_u32(0) - NTP_TIMESTAMP_DELTA;
```



