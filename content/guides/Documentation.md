---
date: "2019-06-27"
layout: post
title: Stratify OS Documentation
slug: Documentation
katex: true
menu:
   sidebar:
      name: Guides
---

## Getting Started

The first step to creating IoT devices using Stratify OS is to install the command line tool (called `sl`). You can do so in just a few seconds by copying and pasting the commands below to a bash terminal.

**Install sl on Mac**
```
mkdir -p /Applications/StratifyLabs-SDK/Tools/gcc/bin
curl -L -o /Applications/StratifyLabs-SDK/Tools/gcc/bin/sl 'https://stratifylabs.page.link/slmac'
chmod 755 /Applications/StratifyLabs-SDK/Tools/gcc/bin/sl
echo 'export PATH=/Applications/StratifyLabs-SDK/Tools/gcc/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
```

**Install sl on Windows**

First, install [GitBash](https://github.com/git-for-windows/git/releases/tag/v2.20.1.windows.1) (or another MinGW terminal) with access to curl.

```
mkdir -p /C/StratifyLabs-SDK/Tools/gcc/bin
curl -L -o /C/StratifyLabs-SDK/Tools/gcc/bin/sl.exe 'https://stratifylabs.page.link/slwin'
chmod 755 /C/StratifyLabs-SDK/Tools/gcc/bin/sl.exe
echo 'export PATH=/C/StratifyLabs-SDK/Tools/gcc/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
```

**Verify Installation**

Verify the command line tool installed by typing `sl --version`. The first time you type the command, the browser will be launched so that you can login. You copy the login command to the terminal and execute it. Then type `sl --version` again. The output should look something like this.

```
- about: 
   publisher: Stratify Labs, Inc
   version: 0.33
   gitHash: 02aa4ca
   apiVersion: 3.8.0b
   apiGitHash: 792faa9
```

From there, you can check out the tutorials within the [Stratify Dashboard](https://app.stratifylabs.co). Here are a few quick examples:

**Install Stratify OS on a supported board**

```
sl cloud.bootstrap:bootloader
sl cloud.bootstrap:os
```

**Install and Run HelloWorld from the Stratify Cloud**

```
sl cloud.install:id=Kvp7xXzdO94kyCWAAcmW application.run:path=HelloWorld,terminal
```

**Install the SDK then Build and Run HelloWorld**

```
sl sdk.install
sl app.create:name=HelloWorld
sl app.build:path=HelloWorld app.install:path=HelloWorld,run,terminal
```

## Guides

If you are brand new to Stratify OS, these guides are a good place to start. Stratify OS is not like any other microcontroller operating system in existence.

- [Stratify OS Overview]({{< relref "Guide-Stratify-OS.md" >}})
- [Understanding Stratify OS on the ARM Cortex M Architecure]({{< relref "Guide-ARM-Cortex-M.md" >}})
- [Understanding Device Drivers]({{< relref "Guide-Device-Drivers.md" >}})
- [Understanding Filesystems]({{< relref "Guide-Filesystems.md" >}})
- [Understanding Sockets]({{< relref "Guide-Sockets.md" >}})
- [Understanding Threads]({{< relref "Guide-Threads.md" >}})

## sl Manual

The `sl` command line tool is used to manage Stratify OS applications, data, and OS packages. To read about its capabilites, see [the manual](sl-manual/).

# API Reference

Stratify OS applications can be built using the StratifyAPI library which is an embedded friendly C++ library for many POSIX and standard C library functions. Or they can be built using direct calls to POSIX and standard C library functions.

- [Stratify API Reference]({{< relref "reference/StratifyAPI/api.md" >}})
- [POSIX pthread Reference]({{< relref "reference/StratifyOS/pthread.md" >}})
- [POSIX unistd Reference]({{< relref "reference/StratifyOS/unistd.md" >}})
- [POSIX dirent Reference]({{< relref "reference/StratifyOS/directory.md" >}})
- [POSIX time Reference]({{< relref "reference/StratifyOS/time.md" >}})
- [POSIX signals Reference]({{< relref "reference/StratifyOS/signal.md" >}})
- [POSIX semaphore Reference]({{< relref "reference/StratifyOS/semaphore.md" >}})
- [POSIX mqueue Reference]({{< relref "reference/StratifyOS/mqueue.md" >}})
- [Standard C Library Reference]({{< relref "reference/StratifyOS/stdc.md" >}})
- [Error Numbers Reference]({{< relref "reference/StratifyOS/errno.md" >}})

