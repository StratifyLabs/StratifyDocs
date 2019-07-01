---
date: "2019-06-27"
layout: post
title: sl Manual
katex: true
categories: reference
slug: sl-manual
toc: true
menu:
  sidebar:
    name: sl Manual
---

# Introduction

Welcome to the *sl* command line/cloud tool. *sl* is used to develop, debug, deploy, and share applications, OS packages and data for Stratify OS.

## Workspaces and Login

The *sl* command line tool operates in a workspace, or simply the current working directory. It automatically creates workspace files when they don't exist.

Because *sl* is a cloud tool, it requires you to login. The first time you run *sl* in a new workspace, it will launch the browser and ask you to login. Once you create an account using the [Stratify web application](https://app.stratifylabs.co), you can copy an *sl* login command and execute it in the terminal. This will create an `sl_credentials.json` file in the workspace. The command `sl cloud.logout` will remove the credentials from the workspace.

# Switches

Switches can be passed with any command. All switches are processed before any commands regardless of the order.

- **help** shows help information. Usage: `sl --help[=<group>][.<command>]`
- **update** checks for updates to `sl` and downloads the latest version without making it effective. To make the latest version effective, you need to execute `slu` to replace the downloaded version with the new version. Usage: `sl --update`
- **interactive** experimental (not recommended)
- **debug** shows low level debugging. Example: `sl os.ping --debug=10`
- **shortcuts** shows the shortcuts available in the workspace. Example: `sl --shortcuts`
- **version** shows version information for *sl*. Example: `sl --version`
- **save** saves the commands as a shortcut. Example: 

```
sl term.run --save=runTerminal # run using 'sl --runTerminal'
```


- **readme** prints the entire readme document. Example: `sl --readme`
- **verbose** sets the verbose level. When setting to a level more verbose than info, the output is no longer YAML compatible. Usage: `sl --verbose=<fatal|error|warning|info|message|debug>`
- **vanilla** disables color and other formatting options in the output. Example: `sl debug.trace --vanilla`
- **archivehistory** archives the workspace history. The history is automatically archived from time to time. Example: `sl --archivehistory`

# Commands

## Grammar

Each *sl* command consists of a group and command written `<group>.<command>[:<arguments>]`. Each *group* has a long name and a short name. The long and short names are expressed in this manual as **long name|short name** (e.g, **connection|conn**). The following commands are equivalent.

```
sl connection.ping
sl conn.ping
```

Arguments are command specific and listed as `<argument>=<value>`. Multiple arguments are separated by commas. Use single quotes around a `<value>` that includes commas or spaces.

```
sl application.install:path=HelloWorld,run=true,terminal=true
sl filesystem.list:path=device@/home,recursive=true
```

For arguments with type `bool`, the value can be omitted and will be set to `true` if the argument is present. If a `bool` argument is omitted, it is assigned a default value which is specific to the argument and command (details for each argument are below). To specify a `bool` argument as false, it must be explicit: `recursive=false`.

Multiple commands sent on a single invocation of *sl* are separated by spaces and executed from left to right.
```
sl terminal.run:while=HelloWorld application.run:path=HelloWorld,args='--version' os.reset
```

## Output

The output is in YAML format. The top level is an array with each command passed being an element in the array. Most commands output properly formatted YAML, but some options may interfere. For example, if the terminal is enabled to print to the standard output, the YAML formatting will break down. Also, `--verbose` levels of `message` and `debug` may also break the formatting.
```
sl connection.ping
   options: 
      path: <default>
      blacklist: false
   output: 
      /dev/tty.usbmodem1412403: 
      /dev/tty.usbmodem1412301: 
      name: Nucleo-H743ZI
      serialNumber: 0000000068004892E01ED1207F80F5B0
      hardwareId: 00000021
      projectId: <invalid>
      bspVersion: 0.1
      sosVersion: 3.8.0b
      cpuArchitecture: v7em_f5dh
      cpuFrequency: 400000000
      applicationSignature: 387
      bspGitHash: 88721bc
      sosGitHash: c988b0a
      mcuGitHash: b50a9cc
   result: success

```

## Exit Code

If all commands complete successfully, the exit code is `0`. If a command fails, the exit code is `1`. This allows the use of the bash operators `&&` and `||` to conditionally execute another command.
```
sl cloud.install:name=HelloWorld || sl os.reset # reset if HelloWorld fails to install
sl os.install:path=Toolbox && sl filesystem.copy:source=host@README.md,dest=device@/app/flash/README.md # If the OS installs successfully, copy the README file
```

## Help

All of the information in this manual is also available from the command line using the `--help` switch. For example:, `sl --help=application.install` will provide the relevant information for the [application.install](#applicationappinstall) command.

```
sl --help # general help information
sl --help=application # list of commands available to the application group
sl --help=app # list of commands available to the application group
sl --help=application.install # details for the application install command
sl --help=app.install # same as above using short name
```

## Reference
- [application](#applicationapp)
    - [install](#applicationappinstall)
    - [run](#applicationapprun)
    - [publish](#applicationapppublish)
    - [build](#applicationappbuild)
    - [set](#applicationappset)
    - [list](#applicationapplist)
    - [create](#applicationappcreate)
    - [clean](#applicationappclean)
    - [ping](#applicationappping)
    - [export](#applicationappexport)
- [benchmark](#benchmarkbench)
    - [test](#benchmarkbenchtest)
- [cloud](#cloud)
    - [cloud.login](#cloudlogin)
    - [cloud.logout](#cloudlogout)
    - [cloud.refresh](#cloudrefresh)
    - [cloud.list](#cloudlist)
    - [cloud.install](#cloudinstall)
    - [cloud.bootstrap](#cloudbootstrap)
    - [cloud.update](#cloudupdate)
    - [cloud.ping](#cloudping)
    - [cloud.sync](#cloudsync)
- [connection](#connectionconn)
    - [list](#connectionconnlist)
    - [ping](#connectionconnping)
    - [connect](#connectionconnconnect)
- [debug](#debugdbug)
    - [trace](#debugdbugtrace)
- [filesystem](#filesystemfs)
    - [list](#filesystemfslist)
    - [mkdir](#filesystemfsmkdir)
    - [remove](#filesystemfsremove)
    - [copy](#filesystemfscopy)
    - [format](#filesystemfsformat)
    - [write](#filesystemfswrite)
    - [read](#filesystemfsread)
- [os](#ossystem)
    - [install](#ossysteminstall)
    - [invokebootloader](#ossysteminvokebootloader)
    - [reset](#ossystemreset)
    - [publish](#ossystempublish)
    - [build](#ossystembuild)
    - [set](#ossystemset)
    - [list](#ossystemlist)
    - [configure](#ossystemconfigure)
    - [ping](#ossystemping)
    - [export](#ossystemexport)
- [sdk](#sdk)
    - [sdk.install](#sdkinstall)
    - [sdk.update](#sdkupdate)
    - [sdk.publish](#sdkpublish)
- [settings](#settingssett)
    - [list](#settingssettlist)
    - [set](#settingssettset)
    - [remove](#settingssettremove)
- [task](#task)
    - [task.list](#tasklist)
    - [task.signal](#tasksignal)
    - [task.analyze](#taskanalyze)
- [terminal](#terminalterm)
    - [run](#terminaltermrun)
    - [listen](#terminaltermlisten)
    - [connect](#terminaltermconnect)
- [test](#test)
    - [test.run](#testrun)
    - [test.update](#testupdate)
    - [test.remove](#testremove)
    - [test.wait](#testwait)
    - [test.export](#testexport)
-------------------------------------

## application|app

###  application|app.install

The *application.install* command installs an application that was built on the host computer to a connected device.

**Usage**
```
install:path=<string>[,data=<int>][,ram=<bool>][,external=<bool>][,tightlycoupled=<bool>][,startup=<bool>][,build=<string>][,destination=<string>][,run=<bool>][,clean=<bool>][,suffix=<string>][,arguments=<string>][,terminal=<bool>][,kill=<bool>][,force=<bool>]
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the relative path to the application project folder on the host computer.
- **data** or **d** `int` is an optional argument that specifies the amount of RAM in bytes to use for data memory (default is to use value specified by the developer).
- **ram** `bool` is an optional argument that specifies to install the code in RAM rather than flash (can't be used with 'startup'). If *ram* is not specified, the value is *false*.
- **external** or **ext** `bool` is an optional argument that specifies to install the code and data in external RAM (ignored if *ram* is *false*). If *external* is not specified, the value is *false*.
- **tightlycoupled** or **tc** `bool` is an optional argument that specifies to install the code and data in tightly coupled RAM (ignored if *ram* is *false*). If *tightlycoupled* is not specified, the value is *false*.
- **startup** or **s** `bool` is an optional argument that specifies to install the program so that it runs when the OS starts up (can't be used with 'ram'). If *startup* is not specified, the value is *false*.
- **build** or **b** `string` is an optional argument that Usually 'release' or 'debug' If *build* is not specified, the value is *release*.
- **destination** or **dest** `string` is an optional argument that Installation destination If *destination* is not specified, the value is */app*.
- **run** or **r** `bool` is an optional argument that specifies the application is run after it has been installed. If *run* is not specified, the value is *false*.
- **clean** or **c** `bool` is an optional argument that , if true, other copies of the app are deleted before installation. If *clean* is not specified, the value is *true*.
- **suffix** `string` is an optional argument that is appended to the name of the target destination (for creating multiple copies of the same application). If *suffix* is not specified, the value is *<none>*.
- **arguments** or **args** `string` is an optional argument that specifies arguments to pass to the application (use with 'run').
- **terminal** or **term** `bool` is an optional argument that indicates the terminal should be run while the application is running (used with 'run'). If *terminal* is not specified, the value is *false*.
- **kill** or **k** `bool` is an optional argument that if true sends a signal to kill the application before installing, otherwise installation is aborted if the application is running. If *kill* is not specified, the value is *true*.
- **force** or **f** `bool` is an optional argument that if true and kill is false, will install over a currently running application without killing first. If *force* is not specified, the value is *false*.

**Examples**
```
application.install:path=HelloWorld
app.install:path=HelloWorld
app.install:path=HelloWorld,data=8192
app.install:path=HelloWorld,ram
app.install:path=HelloWorld,ram,external
app.install:path=HelloWorld,ram,tc=true
app.install:path=HelloWorld,startup
app.install:path=HelloWorld,build=debug
app.install:HelloWorld,dest=device@/home
app.install:path=HelloWorld,run
app.install:path=HelloWorld,run,clean=false
app.install:path=HelloWorld,run,clean=false,suffix=1
app.install:path=HelloWorld,run,args="--version"
app.install:HelloWorld,run=true,terminal=true
app.install:path=HelloWorld,kill=false
app.install:path=Blinky,kill=false,force=true
```

###  application|app.run

The *application.run* command runs an application on a connected device.

**Usage**
```
run:path=<string>[,arguments=<string>][,terminal=<bool>]
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the path to the application to execute (if just a name is provided, /app is searched for a match).
- **arguments** or **args** `string` is an optional argument that specifies arguments to pass to the application.
- **terminal** or **term** `bool` is an optional argument that indicates the terminal will run while the application runs. If *terminal* is not specified, the value is *false*.

**Examples**
```
application.run:path=HelloWorld
app.run:path=device@/app/flash/HelloWorld
app.run:path=HelloWorld,args='--version'
app.run:path=HelloWorld,terminal=true
```

###  application|app.publish

The *application.publish* command publishes a version of the application to the Stratify Cloud. The first time app.publish is used on a project, the cloud provisions an ID which needs to be built into the application before app.publish is called again with the changes specified.

**Usage**
```
publish:[path=<string>][,changes=<string>][,roll=<bool>][,fork=<bool>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that specifies the path to the application that will be published. If not provided, all application projects in the workspace are published. If *path* is not specified, the value is *<all>*.
- **changes** or **c** `string` is an optional argument that specifies the change description for the new build (not required on very first publish)
- **roll** or **r** `bool` is an optional argument that , if true, rolls the version number. If *roll* is not specified, the value is *false*.
- **fork** or **f** `bool` is an optional argument that forks off of an existing application. This should be true if another user already published this application. If *fork* is not specified, the value is *false*.

**Examples**
```
app.publish:path=HelloWorld
app.publish:path=HelloWorld
app.publish:path=HelloWorld,changes='updated the program with an amazing new feature'
app.publish:path=HelloWorld,changes='updated the program with an amazing new feature',roll
application.publish:path=HelloWorld,fork=true
```

###  application|app.build

The *application.build* command will create the appropriate build directory if it doesn't exist. It will then invoke cmake and make to build the application.

**Usage**
```
build:[path=<string>][,options=<string>][,cmakeoptions=<string>][,all=<bool>][,clean=<bool>][,build=<string>][,generator=<string>][,architecture=<string>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that specifies the path on the host computer of the application to build.
- **options** or **o** `string` is an optional argument that specifies options to pass to 'make'. If *options* is not specified, the value is *j10*.
- **cmakeoptions** or **co** `string` is an optional argument that specifies options to pass to 'cmake'.
- **all** or **a** `bool` is an optional argument that if true will build all projects in the workspace (defaults to true if *path* is not provided). If *all* is not specified, the value is *false*.
- **clean** or **c** `bool` is an optional argument that if true cleans project before building. If *clean* is not specified, the value is *false*.
- **build** or **target** `string` is an optional argument that specifies the CMake build target If *build* is not specified, the value is *all*.
- **generator** or **g** `string` is an optional argument that specifies the CMake Generator to use.
- **architecture** or **arch** `string` is an optional argument that specifies the target architecture (either 'arm' or 'link'). If *architecture* is not specified, the value is *arm*.

**Examples**
```
app.build:path=HelloWorld,
app.build:path=HelloWorld
app.build:path=HelloWorld,options='-j 8'
app.build:path=HelloWorld,cmakeoptions='-DSWITCH=ON'
app.build:all,clean
app.build:path=HelloWorld,clean
app.build:path=HelloWorld,build='size_v7em_f4sh'
app.build:path=HelloWorld,g='Unix Makefiles'
app.build:path=HelloWorld,architecture=link
```

###  application|app.set

The *application.set* command sets the key to the specified value.

**Usage**
```
set:key=<string>,value=<string>,path=<string>[,add=<bool>]
```

**Arguments**

- **key** or **k** `string` is a required argument that specifies the key for the *value* to be set.
- **value** or **v** `string` is a required argument that specifies the value to assign to *key*.
- **path** or **p** `string` is a required argument that specifies the path to the application or OS package.
- **add** `bool` is an optional argument that , if true, the key will be added if it doesn't exist. If *add* is not specified, the value is *false*.

**Examples**
```
application.set:key=<key>,value=<value>
application.set:key=<key>,value=<value>
application.set:key=<key>,value=<value>
application.set:path=HelloWorld,key=<key>,value=<value>
application.set:key=<key>,value=<value>,add=true
```

###  application|app.list

The *application.list* command lists the settings stored on the host computer for the application.

**Usage**
```
list:path=<string>
```

**Arguments**

- **path** or **p** `string` is a required argument that Path to the application project

**Examples**
```
application.list:path=HelloWorld
app.list:path=HelloWorld
```

###  application|app.create

The appliation.create command will clone a template project from Github, strip the git repo and then rename the project as specified.

**Usage**
```
create:name=<string>[,from=<string>]
```

**Arguments**

- **name** or **n** `string` is a required argument that Name of the new project
- **from** or **f** `string` is an optional argument that Git URL to base the new project on (default is HelloWorld)

**Examples**
```
app.create:name=MyProject
app.create:name=HelloWorld
app.create:name=HelloWorld,from=<git url>
```

###  application|app.clean

The *application.clean* command deletes all applications from the specified location.

**Usage**
```
clean:[path=<string>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that Path to clean (default is /app/flash and /app/ram)

**Examples**
```
app.clean
app.clean:path=device@/home
```

###  application|app.ping

The *application.ping* command gets information about an application from the device.

**Usage**
```
ping:path=<string>
```

**Arguments**

- **path** `string` is a required argument that Path to the application to ping or a folder containing applications

**Examples**
```
application.ping:path=device@/app/flash
app.ping:path=device@/app/flash/HelloWorld
```

###  application|app.export

The *application.export* command exports a copy of the current build as a JSON file.

**Usage**
```
export:path=<string>[,build=<string>][,output=<string>]
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the path to the application to export.
- **build** or **b** `string` is an optional argument that specifies the build to export. If not specified, all builds are exported. If *build* is not specified, the value is *all*.
- **output** or **o** `string` is an optional argument that specifies the name of the output file. The default is the project name, e.g. `HelloWorld.json`.

**Examples**
```
application.export:path=HelloWorld
app.export:path=HelloWorld
app.export:path=HelloWorld,build=build_release_v7m
app.export:path=HelloWorld,output=HelloWorld.json
```

## benchmark|bench

###  benchmark|bench.test

The *bench.test* command executes a benchmark test and reports the results to the cloud for the connected device.

**Usage**
```
test:identifier=<string>[,ram=<bool>][,external=<bool>][,tightlycoupled=<bool>]
```

**Arguments**

- **identifier** or **id** `string` is a required argument that specifies the project ID for the benchmark test to execute.
- **ram** `bool` is an optional argument that , if true, executes the benchmark test in RAM. If *ram* is not specified, the value is *false*.
- **external** or **ext** `bool` is an optional argument that specifies to install the code and data in external RAM (ignored if *ram* is *false*). If *external* is not specified, the value is *false*.
- **tightlycoupled** or **tc** `bool` is an optional argument that specifies to install the code and data in tightly coupled RAM (ignored if *ram* is *false*). If *tightlycoupled* is not specified, the value is *false*.

**Examples**
```
bench.test:id=<project id>
bench.test:id=<project id>
bench.test:id=<project id>,ram
bench.test:id=<id>,ram,external
bench.test:id=<id>,ram,tc=true
```

## cloud

### cloud.login

The *cloud.login* command is used to login to the Stratify cloud using an email/password or uid/token combination.

**Usage**
```
login:[email=<string>][,password=<string>][,uid=<string>][,local=<bool>][,token=<string>]
```

**Arguments**

- **email** or **e** `string` is an optional argument that specifies the email address to use when logging in.
- **password** or **p** `string` is an optional argument that specifies the password for the associated email address.
- **uid** or **u** `string` is an optional argument that specifies the user ID when using a cloud token to login.
- **local** or **l** `bool` is an optional argument that ,if true, saves the credentials in the local workspace rather than globally. If *local* is not specified, the value is *false*.
- **token** or **t** `string` is an optional argument that specifies the cloud token for authentication.

**Examples**
```
cloud.login:email=myemail.com,password=mypassword
cloud.login:email=<email>,password=<password>
cloud.login:email=<email>,password=<password>
cloud.login:uid=<uid>,token=<token>
cloud.login:local=true,uid=<uid>,token=<token>
cloud.login:uid=<uid>,token=<token>
```

### cloud.logout

The *cloud.logout* command removes the login credentials from the workspace.

**Usage**
```
logout
```


**Examples**
```
cloud.logout
```

### cloud.refresh

The *cloud.refresh* command refreshes the workspace login. This will happen automatically if the current login has expired.

**Usage**
```
refresh
```


**Examples**
```
cloud.refresh
```

### cloud.list

The *cloud.list* command lists cloud projects that are available.

**Usage**
```
list:[type=<string>][,identifier=<string>][,uid=<string>][,tag=<string>][,synchronize=<bool>][,details=<bool>]
```

**Arguments**

- **type** or **t** `string` is an optional argument that specifies the project type (app or os) to list. If *type* is not specified, the value is *app*.
- **identifier** or **id** `string` is an optional argument that lists details associated with the id.
- **uid** or **u** `string` is an optional argument that lists projects by the user ID.
- **tag** `string` is an optional argument that lists projects that have the specified tag.
- **synchronize** or **sync** `bool` is an optional argument that syncs the local list of projects with the cloud before listing. If *synchronize* is not specified, the value is *false*.
- **details** or **d** `bool` is an optional argument that shows details for the list of projects. If *details* is not specified, the value is *false*.

**Examples**
```
ex
cloud.list:path=.
cloud.list:uid=xyz
cloud.list:uid=xyz
cloud.list:tag=utility
cloud.list:tag=utility,synchronize=true
cloud.list:details
```

### cloud.install

The *cloud.install* command installs an application or OS package from the cloud on to a connected device.

**Usage**
```
install:[identifier=<string>][,url=<string>][,name=<string>][,bootloader=<bool>][,destination=<string>][,debug=<bool>][,version=<string>][,build=<string>][,clean=<bool>][,suffix=<string>][,startup=<bool>][,ram=<bool>][,external=<bool>][,tightlycoupled=<bool>][,retry=<int>][,delay=<int>]
```

**Arguments**

- **identifier** or **id** `string` is an optional argument that specifies a cloud ID to download and install.
- **url** or **u** `string` is an optional argument that specifies a URL to an exported application or OS package.
- **name** or **n** `string` is an optional argument that specifies the name of the project to install (use *id* to be more specific)
- **bootloader** or **boot** `bool` is an optional argument that , if true, installs the bootloader using the mbed drive mount. If *bootloader* is not specified, the value is *false*.
- **destination** or **dest** `string` is an optional argument that specifies the install location for applications. If *destination* is not specified, the value is */app/flash*.
- **debug** or **d** `bool` is an optional argument that , if true, installs the debug version (for OS packages only). If *debug* is not specified, the value is *false*.
- **version** or **v** `string` is an optional argument that specifies a version to install (default is latest). If *version* is not specified, the value is *<latest>*.
- **build** or **b** `string` is an optional argument that specifies a build ID to install (default is release).
- **clean** or **c** `bool` is an optional argument that , if true, other copies of the application are deleted before installation. If *clean* is not specified, the value is *true*.
- **suffix** `string` is an optional argument that is appended to the name of the target destination (for creating multiple copies of the same application). If *suffix* is not specified, the value is *<none>*.
- **startup** or **s** `bool` is an optional argument that , if true, an installed application will run at startup if supported on the target filesystem. If *startup* is not specified, the value is *false*.
- **ram** `bool` is an optional argument that , if true, installs the application in ram (no effect if the id is an OS package). If *ram* is not specified, the value is *false*.
- **external** or **ext** `bool` is an optional argument that specifies to install the code and data in external RAM (ignored if *ram* is *false*). If *external* is not specified, the value is *false*.
- **tightlycoupled** or **tc** `bool` is an optional argument that specifies to install the code and data in tightly coupled RAM (ignored if *ram* is *false*). If *tightlycoupled* is not specified, the value is *false*.
- **retry** `int` is an optional argument that number of times to try to connect or reconnect when installing an OS package. If *retry* is not specified, the value is *5*.
- **delay** `int` is an optional argument that number of milliseconds to delay between reconnect tries. If *delay* is not specified, the value is *1000*.

**Examples**
```
cloud.install:name=HelloWorld
cloud.install:id=<projectId>
cloud.install:url=https://github.com/StratifyLabs/HelloWorld/releases/download/v1.10/HelloWorld.json
cloud.install:name=HelloWorld
cloud.install:bootloader=true
cloud.install:dest=/home,name=HelloWorld
cloud.install:debug=true
cloud.install:version=1.0
cloud.install:build=<buildId>
cloud.install:id=<project id>,run,clean=false
cloud.install:id=<project id>,run,clean=false,suffix=1
cloud.install:id=<id>,startup
cloud.install:id=<id>,ram
cloud.install:id=<id>,ram,external
cloud.install:id=<id>,ram,tc=true
cloud.install:id=<id>,retry=10
cloud.install:id=<id>,retry=10,delay=2000
```

### cloud.bootstrap

The *cloud.bootstrap* command can install both the bootloader and an OS package to a device that has never been flashed before. The bootloader is installed using the mbed mounted drive.

**Usage**
```
bootstrap:[save=<string>][,bootloader=<bool>][,os=<bool>][,version=<string>][,identifier=<string>][,debug=<bool>][,retry=<int>][,delay=<int>]
```

**Arguments**

- **save** or **s** `string` is an optional argument that saves the bootloader as a file in the workspace.
- **bootloader** or **b** `bool` is an optional argument that installs the bootloader from the cloud. If *bootloader* is not specified, the value is *true*.
- **os** `bool` is an optional argument that installs the OS from the cloud to a connected bootloader. If *os* is not specified, the value is *false*.
- **version** or **v** `string` is an optional argument that specifies which version to install (default is latest).
- **identifier** or **id** `string` is an optional argument that specifies the OS Package Identifier (if omitted find one automatically).
- **debug** or **d** `bool` is an optional argument that , if true, installs debug version. If *debug* is not specified, the value is *false*.
- **retry** `int` is an optional argument that number of times to try to connect or reconnect when installing an OS package. If *retry* is not specified, the value is *5*.
- **delay** `int` is an optional argument that number of milliseconds to delay between reconnect tries. If *delay* is not specified, the value is *1000*.

**Examples**
```
cloud.bootstrap:bootloader
cloud.bootstrap:save=true
cloud.bootstrap:bootloader
cloud.bootstrap:os
cloud.bootstrap:version=1.0
cloud.bootstrap:id=<id>
cloud.bootstrap:debug=true
cloud.install:id=<id>,retry=10
cloud.install:id=<id>,retry=10,delay=2000
```

### cloud.update

The *cloud.update* command checks for updates to applications and OS packages on the connected device.

**Usage**
```
update:[application=<bool>][,os=<bool>][,install=<bool>][,reinstall=<bool>][,path=<string>][,refresh=<bool>][,retry=<int>][,delay=<int>]
```

**Arguments**

- **application** or **app** `bool` is an optional argument that checks the installed applications for available updates. If *application* is not specified, the value is *false*.
- **os** or **bsp** `bool` is an optional argument that checks to see if any connected devices have an updated OS package available. If *os* is not specified, the value is *true*.
- **install** `bool` is an optional argument that installs an update if one is available. If *install* is not specified, the value is *true*.
- **reinstall** `bool` is an optional argument that installs the latest version even if it is already installed. If *reinstall* is not specified, the value is *false*.
- **path** or **p** `string` is an optional argument that specifies the path to search for applications. If *path* is not specified, the value is *device@/app*.
- **refresh** `bool` is an optional argument that , if true, will force the cloud settings to be refreshed. If *refresh* is not specified, the value is *false*.
- **retry** `int` is an optional argument that number of times to try to connect or reconnect when installing an OS package. If *retry* is not specified, the value is *5*.
- **delay** `int` is an optional argument that number of milliseconds to delay between reconnect tries. If *delay* is not specified, the value is *1000*.

**Examples**
```
cloud.update:app
cloud.update:app=true
cloud.update:os=true
cloud.update:app=true,install=false
cloud.update:app=true,reinstall=true
cloud.update:app,path=device@/home
cloud.update:app,refresh
cloud.install:id=<id>,retry=10
cloud.install:id=<id>,retry=10,delay=2000
```

### cloud.ping

The *cloud.ping* command gets the most recent information for the project ID from the cloud.

**Usage**
```
ping:[identifier=<string>][,url=<string>]
```

**Arguments**

- **identifier** or **id** `string` is an optional argument that specifies the ID of the project to ping.
- **url** or **u** `string` is an optional argument that specifies the url of the project to ping.

**Examples**
```
cloud.ping:id=<id>
cloud.ping:id=<id>
cloud.ping:url=<id>
```

### cloud.sync

The *cloud.sync* command synchronizes datum items stored on the device to the cloud.

**Usage**
```
sync:[path=<string>][,clean=<bool>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that specifies the path to a JSON file that includes datum objects to sync with the cloud.
- **clean** or **c** `bool` is an optional argument that specifies whether or not to delete the log file. If *clean* is not specified, the value is *false*.

**Examples**
```
cloud.sync:path=device@/home/log.json
cloud.sync:path=device@/home/log.json
cloud.sync:path=device@/home/log.json,clean=true
```

## connection|conn

###  connection|conn.list

The *connection.list* command lists the serial devices that are available as potential Stratify OS devices.

**Usage**
```
list
```


**Examples**
```
conn.list
```

###  connection|conn.ping

The *connection.ping* command queries each serial port to see if a Stratify OS device is available. It can be used with 'blacklist' to prevent the workspace from trying to connect to unresponsive ports.

**Usage**
```
ping:[path=<string>][,blacklist=<bool>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that pings the device on the specified path.
- **blacklist** or **bl** `bool` is an optional argument that adds any non-responsive devices to the blacklist which are ignored until ping is called with blacklist set to false. If *blacklist* is not specified, the value is *false*.

**Examples**
```
connection.ping
conn.ping:path=/dev/tty.usbmodem12457
conn.ping:blacklist
```

###  connection|conn.connect

The *connection.connect* command will connect to a specific device. The connection will be made automatically if this command is not used but if there is more than one device attached, the automatic connection will make an arbitrary choice on which device to connect to.

**Usage**
```
connect:[path=<string>][,serialnumber=<string>][,baudrate=<int>][,stopbits=<int>][,parity=<string>][,save=<bool>][,retry=<int>][,delay=<int>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that connects to the specified device using the host device file path.
- **serialnumber** or **sn** `string` is an optional argument that connects to the specified serial number.
- **baudrate** or **br** `int` is an optional argument that specifies the baudrate to use for serial connections (only applicable if UART is used). If *baudrate* is not specified, the value is *460800*.
- **stopbits** or **sb** `int` is an optional argument that specifies the stop bits to use for serial connections as 1 or 2 (only applicable if UART is used). If *stopbits* is not specified, the value is *1*.
- **parity** `string` is an optional argument that specifies the parity to use for serial connections as 'odd' or 'even' or 'none' (only applicable if UART is used). If *parity* is not specified, the value is *none*.
- **save** `bool` is an optional argument that saves the serial settings as the defaults for the workspace (save with no serial options to restore defaults). If *save* is not specified, the value is *false*.
- **retry** or **r** `int` is an optional argument that specifies the number of times to retry connecting. If *retry* is not specified, the value is *0*.
- **delay** or **d** `int` is an optional argument that specifies the number of milliseconds to wait between reconnect attempts. If *delay* is not specified, the value is *500*.

**Examples**
```
connection.connect
conn.connect:path=/dev/tty.usbmodem123837
connection.connect:sn=09182737432823942347
connection.connect:baudrate=115200
connection.connect:stopbits=2
conn.connect:parity=odd
conn.connect:baudrate=115200,save=true
conn.connect:retry=5
conn.connect:retry=5,delay=1000
```

## debug|dbug

###  debug|dbug.trace

The *debug.trace* command will cause *sl* to monitor the trace output of the system and display any messages in the terminal.

**Usage**
```
trace:[duration=<int>][,period=<int>][,enabled=<bool>]
```

**Arguments**

- **duration** `int` is an optional argument that specifies the duration of time in seconds to run the debug trace. If *duration* is not specified, the value is *<indefinite>*.
- **period** `int` is an optional argument that specifies the sample period in milliseconds of the debug tracing buffer. If *period* is not specified, the value is *100*.
- **enabled** or **on** `bool` is an optional argument that , if true, monitors the system debug trace output. If *enabled* is not specified, the value is *true*.

**Examples**
```
debug.trace
debug.trace:enabled,duration=5
debug.trace:period=50
debug.trace:enabled=false
```

## filesystem|fs

###  filesystem|fs.list

The *filesystem.list* command will list the contents of a directory on the connected device.

**Usage**
```
list:path=<string>[,recursive=<bool>][,details=<bool>][,hide=<bool>]
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the path on the device.
- **recursive** or **r** `bool` is an optional argument that , if true, recursively lists files in directories. If *recursive* is not specified, the value is *false*.
- **details** or **d** `bool` is an optional argument that , if true, shows details of each directory entry. If *details* is not specified, the value is *true*.
- **hide** or **h** `bool` is an optional argument that ,if false, shows hidden files. If *hide* is not specified, the value is *true*.

**Examples**
```
filesystem.list:path=device@/
fs.list:path=/home
fs.list:path=device@/home,recursive
fs.list:path=device@/home,details=false
fs.list:path=device@/app/flash,hide=false
```

###  filesystem|fs.mkdir

The *filesystem.mkdir* command creates a directory on the connected device. This command will only work if the filesystem supports directory creation.

**Usage**
```
mkdir:path=<string>[,mode=<string>]
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the path to create.
- **mode** `string` is an optional argument that specifies the permissions in octal representation of the mode (default is 0777).

**Examples**
```
filessytem.mkdir:path=/home/my_directory
fs.mkdir:path=/home/my_directory
fs.mkdir:path=/home/my_directory,mode=0755
```

###  filesystem|fs.remove

The *filesystem.remove* command removes a file or directory from the connected device.

**Usage**
```
remove:path=<string>[,recursive=<bool>]
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the path to the file to remove.
- **recursive** or **r** `bool` is an optional argument that , if true, removes the directory recursively. If *recursive* is not specified, the value is *false*.

**Examples**
```
filesystem.remove:path=/app/flash/HelloWorld
fs.remove:path=device@/home/data.txt
fs.remove:path=/home/tmp
```

###  filesystem|fs.copy

The *filesystem.copy* command is used to copy files to/from the connected device to/from the host computer. Paths prefixed with *host@* are on the host computer while paths prefixed with *device@* are on the connected device.

**Usage**
```
copy:source=<string>,destination=<string>[,remove=<bool>][,hidden=<bool>][,overwrite=<bool>][,dest=<>][,overwrite=<>]
```

**Arguments**

- **source** or **src** `string` is a required argument that specifies the path to the source file to copy. If the source is a directory, all files in the directory are copied.
- **destination** or **dest** `string` is a required argument that specifies the destination path. If the source is a directory, the destination should be a directory as well.
- **remove** `bool` is an optional argument that , if true, and if the source is on the device, the source will be deleted after it is copied. If *remove* is not specified, the value is *false*.
- **hidden** `bool` is an optional argument that specifies whether or not to copy hidden files (files that start with '.'). If *hidden* is not specified, the value is *false*.
- **overwrite** or **o** `bool` is an optional argument that , if true, the destination will be overwritten withouth warning. If *overwrite* is not specified, the value is *true*.
- **dest** `` is an optional argument
- **overwrite** `` is an optional argument

**Examples**
```
filesystem.copy:source=host@README.md;dest=device@/app/flash/README.md
fs.copy:source=host@./data.txt,dest=device@/home/data.txt
fs.copy:source=host@./data.txt,dest=device@/home/data.txt
fs.copy:source=host@./data.txt,dest=device@/home/data.txt,remove=true
fs.copy:source=device@/home/directory,dest=soure@./,hidden=true
fs.copy:source=host@./data.txt
```

###  filesystem|fs.format

The *filesystem.format* commands formats the filesystem on the device. 

**Usage**
```
format:path=<string>
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the path to the filesystem to format.

**Examples**
```
filesystem.format:path=device@/home
fs.copy:source=host@./data.txt,dest=device@/home/data.txt
```

###  filesystem|fs.write

The *filesystem.write* writes to a file (or device) on the device. The file will be opened, written, then closed.

**Usage**
```
write:source=<string>,destination=<string>[,readwrite=<bool>][,append=<bool>][,chunksize=<int>]
```

**Arguments**

- **source** or **src** `string` is a required argument that specifies the path to the host file which will be written o the device's file (or device).
- **destination** or **dest** `string` is a required argument that specifies the destination path of the device file (or device) which will be written.
- **readwrite** or **rw** `bool` is an optional argument that , if true, the destination file is opened for in read/write mode (default is write only). If *readwrite* is not specified, the value is *false*.
- **append** or **a** `bool` is an optional argument that , if true, the destination file is opened for appending. If *append* is not specified, the value is *false*.
- **chunksize** `int` is an optional argument that specifies the chunk size for reading the source and writing the destination. If *chunksize* is not specified, the value is *128*.

**Examples**
```
filesystem.write:source=host@./data.txt,dest=device@/dev/uart0
fs.write:source=host@./data.txt,dest=device@/dev/uart0
fs.write:source=host@./data.txt,dest=device@/dev/uart1
fs.copy:source=host@./data.txt,device@/dev/uart1,rw
fs.copy:source=host@./data.txt,dest=device@/home/data.txt,append
fs.copy:source=host@./data.txt,dest=device@/home/data.txt,chunksize=64
```

###  filesystem|fs.read

## os|system

###  os|system.install

The *os.install* command installs an OS package on a connected device that has been built on the host computer. If no *path* is specified, the workspace is searched for an OS package that matches the connected device.

**Usage**
```
install:[path=<string>][,verify=<bool>][,reconnect=<bool>][,retry=<int>][,delay=<int>][,build=<string>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that specifies the path to the OS project folder.
- **verify** or **v** `bool` is an optional argument that , if true, verifies the BSP image after it is installed. If *verify* is not specified, the value is *false*.
- **reconnect** or **rc** `bool` is an optional argument that , if true, reconnects to the device after the OS package is installed. If *reconnect* is not specified, the value is *true*.
- **retry** or **r** `int` is an optional argument that specifies the number of times to retry reconnecting after install (used with reconnect, and delay). If *retry* is not specified, the value is *10*.
- **delay** or **d** `int` is an optional argument that specifies the number of milliseconds to wait between reconnect retries (used with reconnect and retry). If *delay* is not specified, the value is *500*.
- **build** or **b** `string` is an optional argument that specifies the build name which is usually 'release' or 'debug'. If *build* is not specified, the value is *release*.

**Examples**
```
os.install
os.install:path=/Path/to/project
os.install:path=/Path/to/project,verify=true
os.install:path=/Path/to/project,reconnect=true
os.install:path=/Path/to/project,reconnect,retry=3
os.install:path=/Path/to/project,reconnect,retry=3,delay=1000
os.install:path=/Path/to/project,build=debug
```

###  os|system.invokebootloader

The *os.invokebootloder* command sends a software bootloader invocation request to the connected device.

**Usage**
```
invokebootloader:[reconnect=<bool>][,retry=<int>][,delay=<int>]
```

**Arguments**

- **reconnect** or **rc** `bool` is an optional argument that if true will cause *sl* to reconnect to the device after invoking the bootloader. If *reconnect* is not specified, the value is *false*.
- **retry** or **r** `int` is an optional argument that specifies the number of times to retry connecting after the request. If *retry* is not specified, the value is *5*.
- **delay** or **d** `int` is an optional argument that specifies the number of milliseconds to wait between reconnect attempts. If *delay* is not specified, the value is *500*.

**Examples**
```
os.invokebootloader
os.invokebootloader:reconnect=true
os.invokebootloader:reconnect,retry=5
os.invokebootloader:reconnect,retry=5,delay=1000
```

###  os|system.reset

The *os.reset* command resets the connected device.

**Usage**
```
reset:[reconnect=<bool>][,retry=<int>][,delay=<int>]
```

**Arguments**

- **reconnect** or **rc** `bool` is an optional argument that ,if true, reconnects to the device after the reset. If *reconnect* is not specified, the value is *false*.
- **retry** or **r** `int` is an optional argument that specifies the number of times to retry connecting. If *retry* is not specified, the value is *5*.
- **delay** or **d** `int` is an optional argument that specifies the number of milliseconds to wait between reconnect attempts.os.reset:reconnect=true,delay=2000 If *delay* is not specified, the value is *500*.

**Examples**
```
os.reset
os.reset:reconnect=true
os.reset:reconnect=true,retry=5
```

###  os|system.publish

The *os.publish* command publishes an OS package to the Stratify cloud. The initial call to *os.publish* will acquire an ID that needs to be built into the binary. Subsequent calls to *os.publish* will publish the build.

**Usage**
```
publish:[path=<string>][,changes=<string>][,roll=<bool>][,fork=<bool>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that specifies the path to the OS package to publish. All OS packages in the workspace are published if path isn't provided. If *path* is not specified, the value is *<all>*.
- **changes** or **c** `string` is an optional argument that A description of the changes for the new build
- **roll** or **r** `bool` is an optional argument that , if true, rolls the version number. If *roll* is not specified, the value is *false*.
- **fork** or **f** `bool` is an optional argument that If this is a modified project from another user use this option If *fork* is not specified, the value is *false*.

**Examples**
```
os.build:path=MyOsProject
os.publish:path=Toolbox,changes='fixed critical bugs'
os.publish:path=Toolbox,changes='updated the program with an amazing new feature'
os.publish:path=Toolbox,changes='updated the program with an amazing new feature',roll
os.publish:path=Toolbox,changes='updated the program with an amazing new feature',fork
```

###  os|system.build

The *os.build* command builds an OS package project on the host computer. This command will create a directory (cmake_arm) and invoke cmake and make as needed. All the steps can be completed from the command line as well.

**Usage**
```
build:[path=<string>][,options=<string>][,cmakeoptions=<string>][,all=<bool>][,clean=<bool>][,generator=<string>][,build=<string>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that specifies the relative path to the OS package project to build.
- **options** or **o** `string` is an optional argument that specifies the options to pass to 'make'. If *options* is not specified, the value is *j10*.
- **cmakeoptions** or **o** `string` is an optional argument that specifies the options to pass to 'cmake'.
- **all** or **a** `bool` is an optional argument that , if true, builds all os projects in workspace. If *all* is not specified, the value is *false*.
- **clean** or **c** `bool` is an optional argument that , if true, cleans project before building. If *clean* is not specified, the value is *false*.
- **generator** or **g** `string` is an optional argument that specifies the CMake generator to use.
- **build** or **target** `string` is an optional argument that specifies the CMake build target. If *build* is not specified, the value is *all*.

**Examples**
```
os.build:path=MyOsProject
os.build:path=Toolbox'
os.build:path=Toolbox,options='-j 8'
os.build:path=Toolbox,cmakeoptions='-DSWITCH=ON'
os.build:all,clean
os.build:path=Toolbox,clean
os.build:path=HelloWorld,g='Unix Makefiles'
os.build:path=MyOsProject,build='debug'
```

###  os|system.set

The *application.set* command sets the key to the specified value.

**Usage**
```
set:key=<string>,value=<string>,path=<string>[,add=<bool>]
```

**Arguments**

- **key** or **k** `string` is a required argument that specifies the key for the *value* to be set.
- **value** or **v** `string` is a required argument that specifies the value to assign to *key*.
- **path** or **p** `string` is a required argument that specifies the path to the application or OS package.
- **add** `bool` is an optional argument that , if true, the key will be added if it doesn't exist. If *add* is not specified, the value is *false*.

**Examples**
```
application.set:key=<key>,value=<value>
application.set:key=<key>,value=<value>
application.set:key=<key>,value=<value>
application.set:path=HelloWorld,key=<key>,value=<value>
application.set:key=<key>,value=<value>,add=true
```

###  os|system.list

The *os.list* command lists the project settings stored on the host computer.

**Usage**
```
create:path=<string>
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the relative path to the OS package project.

**Examples**
```
os.list:path=MyOsProject
os.list:path=MyOsProject
```

###  os|system.configure

The *os.configure* command can be used to configure the clock on a connected device

**Usage**
```
configure:[time=<bool>]
```

**Arguments**

- **time** or **t** `bool` is an optional argument that Synchronize the time of the device to the time of the host If *time* is not specified, the value is *false*.

**Examples**
```
os.configure
system.configure:time=true
```

###  os|system.ping

The *os.ping* command collects and displays information from the connected device.

**Usage**
```
ping
```


**Examples**
```
os.ping
```

###  os|system.export

The *os.export* command exports a copy of the current build as a JSON file.

**Usage**
```
export:path=<string>[,build=<string>][,output=<string>]
```

**Arguments**

- **path** or **p** `string` is a required argument that specifies the path to the application to export.
- **build** or **b** `string` is an optional argument that specifies the build to export. If not specified, all builds are exported. If *build* is not specified, the value is *all*.
- **output** or **o** `string` is an optional argument that specifies the name of the output file. The default is the project name, e.g. `Toolbox.json`.

**Examples**
```
os.export:path=Toolbox
os.export:path=HelloWorld
os.export:path=HelloWorld,build=build_release_v7m
os.export:path=Toolbox,output=Toolbox.json
```

## sdk

### sdk.install

The *sdk.install* command will download and install the software development kit which includes a GCC compiler as well as pre-built libraries for Stratify OS.

**Usage**
```
install:[path=<string>][,sdk=<bool>][,cmake=<bool>]
```

**Arguments**

- **path** or **p** `string` is an optional argument that specifies the destination for install (default is either C:/StratifyLabs-SDK or /Applications/StratifyLabs-SDK depending on the platform).
- **sdk** `bool` is an optional argument that , if true, installs the SDK compiler and libraries (default is false if *cmake* is true) If *sdk* is not specified, the value is *true*.
- **cmake** `bool` is an optional argument that , if true, installs a copy of cmake. If *cmake* is not specified, the value is *false*.

**Examples**
```
sdk.install
sdk.install:path=<path>
sdk.install:sdk=true
sdk.install:cmake=true
```

### sdk.update

The *sdk.update* command will use git to pull libraries from remote git repositories then build and install the libraries on the local machine. If no library (or libraries) are specified, the default Stratify libraries will be pulled or if libraries exist in the workspace, they will be pulled/build/installed.

**Usage**
```
update:[generator=<string>][,pull=<bool>][,compile=<bool>][,build=<string>][,remove=<bool>][,tag=<string>][,branch=<string>][,clean=<bool>][,dryrun=<bool>][,install=<bool>][,architecture=<string>][,library=<string>][,position=<strings>][,url=<string>][,makeoptions=<string>][,cmakeoptions=<string>]
```

**Arguments**

- **generator** or **g** `string` is an optional argument that specifies the CMake Generator type (if not specified, it is chosen based on the environment).
- **pull** `bool` is an optional argument that , if true, pulls the latest code from Github (can be false on subsequent calls to *sdk.update*) If *pull* is not specified, the value is *true*.
- **compile** `bool` is an optional argument that , if true, compiles the code. If *compile* is not specified, the value is *true*.
- **build** or **target** `string` is an optional argument that specifies the cmake build target. If *build* is not specified, the value is *install*.
- **remove** `bool` is an optional argument that delete all SDK project folders in the current workspace (useful if a 'tag' is changed so it can be re-cloned and checked out). If *remove* is not specified, the value is *false*.
- **tag** `string` is an optional argument that specifies the git tag to checkout after pulling. If *tag* is not specified, the value is *HEAD*.
- **branch** `string` is an optional argument that specifies the git branch checkout after pulling. If *branch* is not specified, the value is *master*.
- **clean** `bool` is an optional argument that , if true, cleans before building code. If *clean* is not specified, the value is *false*.
- **dryrun** `bool` is an optional argument that , if true, just lists actions without performing them (set to true if library is provided). If *dryrun* is not specified, the value is *false*.
- **install** or **i** `bool` is an optional argument that , if true, installs the SDK on the local machine at the default path (C:/StratifyLabs-SDK or /Applications/StratifyLabs-SDK). If *install* is not specified, the value is *true*.
- **architecture** or **arch** `string` is an optional argument that specifies architectures to build for (arm and/or link). If *architecture* is not specified, the value is *arm*.
- **library** or **lib** `string` is an optional argument that adds or updates the library to the SDK build configuration.
- **position** or **pos** `strings` is an optional argument that specifies where to insert the library in the build order (0 is first).
- **url** `string` is an optional argument that specifies the http address of the library. If *url* is not specified, the value is *github.com/StratifyLabs*.
- **makeoptions** or **mo** `string` is an optional argument that specifies the URL of the git repository for the library. If *makeoptions* is not specified, the value is *-j8*.
- **cmakeoptions** or **cmo** `string` is an optional argument that specifies the URL of the git repository for the library.

**Examples**
```
sdk.update
sdk.update:g='Unix Makefiles'
sdk.update:pull=false
sdk.update:build=false
sdk.update:build=release
sdk.update:remove=true
sdk.update:clean=true,tag=v1.0.0
sdk.update:clean=true,branch=development
sdk.update:clean=true
sdk.update:dryrun
sdk.update:local=false
sdk.update:arch=arm?link
sdk.update:lib=StratifyOS,cmo='-DBUILD_ARM_ALL=OFF -DBUILD_ARM_V7M=ON'
sdk.update:lib=StratifyOS,position=0
sdk.update:lib=StratifyOS,url=github.com/StratifyLabs
sdk.update:lib=StratifyOS,options=j8
sdk.update:lib=StratifyOS,cmo=-DSWITCH=ON
```

### sdk.publish

The *sdk.publish* command copies the SDK from one directory to another and applies any filters. It then archives and publishes the SDK to the cloud.

**Usage**
```
gather:source=<string>,destination=<string>[,filter=<string>][,publish=<bool>][,archive=<bool>][,gather=<bool>][,7z=<string>]
```

**Arguments**

- **source** or **src** `string` is a required argument that specifies ths source location of the SDK.
- **destination** or **dest** `string` is a required argument that specifies the destination folder for output.
- **filter** or **filt** `string` is an optional argument that specifies the filter to exclude matching entries (separate filters with ?).
- **publish** `bool` is an optional argument that ,if true, uploads the SDK to the Stratify cloud. If *publish* is not specified, the value is *true*.
- **archive** `bool` is an optional argument that ,if true, creates an archive of the SDK. If *archive* is not specified, the value is *true*.
- **gather** `bool` is an optional argument that ,if true, gather to the SDK using the filters. If *gather* is not specified, the value is *true*.
- **7z** `string` is an optional argument that specifies the path to the 7z executable (windows only). If *7z* is not specified, the value is *C:/Program Files/7-Zip*.

**Examples**
```
sdk.publish:source=<source>,dest=<dest>
sdk.publish:source=<source>,dest=<dest>
sdk.update:source=<source>,dest=<dest>
sdk.publish:source=<source>,dest=<dest>,filt=<item0>?<item1>
sdk.publish:source=<source>,dest=<dest>,publish
sdk.publish:source=<source>,dest=<dest>,archive=false
sdk.publish:source=<source>,dest=<dest>,publish,gathered
sdk.publish:source=<source>,dest=<dest>,publish,gathered
```

## settings|sett

###  settings|sett.list

The *settings.list* command lists workspace settings.

**Usage**
```
list:[key=<string>][,global=<bool>]
```

**Arguments**

- **key** or **k** `string` is an optional argument that , if specified, lists only the values under the *key*.
- **global** or **g** `bool` is an optional argument that , if specified, lists values from global settings. If *global* is not specified, the value is *false*.

**Examples**
```
settings.list
list:key=sdk
list:key=cloudSettings,global
```

###  settings|sett.set

The *settings.set* command sets the key to the specified value.

**Usage**
```
set:key=<string>,value=<string>[,global=<bool>][,add=<bool>]
```

**Arguments**

- **key** or **k** `string` is a required argument that specifies the key for the *value* to be set.
- **value** or **v** `string` is a required argument that specifies the value to assign to *key*.
- **global** or **g** `bool` is an optional argument that , if true, set the key in global settings. If *global* is not specified, the value is *false*.
- **add** `bool` is an optional argument that , if true, the key will be added if it doesn't exist. If *add* is not specified, the value is *false*.

**Examples**
```
settings.set:key=<key>,value=<value>
settings.set:key=<key>,value=<value>
settings.set:key=<key>,value=<value>
settings.set:global,key=<key>,value=<value>
settings.set:key=<key>,value=<value>,add=true
```

###  settings|sett.remove

The *settings.remove* command removes a setting from the workspace.

**Usage**
```
remove:key=<string>[,global=<bool>]
```

**Arguments**

- **key** or **k** `string` is a required argument that specifies the setting key to remove.
- **global** or **g** `bool` is an optional argument that , if true, remove a global setting. If *global* is not specified, the value is *false*.

**Examples**
```
settings.remove:key=reportStatus
settings.remove:key=blacklist
settings.remove:key=cloudSettings,global
```

## task

### task.list

The *task.list* command lists the currently active tasks (threads and processes).

**Usage**
```
list:[pid=<int>][,name=<string>][,id=<int>]
```

**Arguments**

- **pid** `int` is an optional argument that specifies the process id used to filter tasks (or use *name*).
- **name** `string` is an optional argument that specifies the application name to filter tasks (or use *pid*).
- **id** or **tid** `int` is an optional argument that specifies the task ID to filter (will show a max of one entry).

**Examples**
```
task.list
task.list:pid=0
task.list:name=HelloWorld
task.list:id=5
```

### task.signal

The *task.signal* command will send a POSIX style signal to the process running on the connected device.

**Usage**
```
signal:[pid=<int>][,name=<string>][,id=<int>],signal=<int>[,value=<int>]
```

**Arguments**

- **pid** `int` is an optional argument that specifies the process ID target for the signal (or use 'name'). If specified kill() is used rather than pthread_kill().
- **name** or **n** `string` is an optional argument that specifies the application name to receive the signal (or use 'pid').
- **id** or **tid** `int` is an optional argument that specifies the thread ID to receive the signal. If specified, pthread_kill() is used instead of kill().
- **signal** or **s** `int` is a required argument that specifies the signal to send which can be *KILL*, *INT*, *STOP*, *ALARM*, *TERM*, *BUS*, *QUIT*, and *CONTINUE*
- **value** or **v** `int` is an optional argument that An optional signal value that can be sent with the associated signal number

**Examples**
```
task.signal:name=Blinky,signal=STOP
task.signal:pid=0
task.signal:name=HelloWorld
task.signal:id=2
task.signal:signal=INT
task.signal:value=0
```

### task.analyze

The *task.analyze* command will sample the state of the threads/processes running in the system and print a report when the applciation exits.

**Usage**
```
analyze:[name=<string>][,duration=<string>][,save=<bool>][,details=<bool>][,period=<int>]
```

**Arguments**

- **name** or **n** `string` is an optional argument that specifies a specific application name to monitor (default is to monitor all threads/processes).
- **duration** or **d** `string` is an optional argument that specifies the number of seconds to monitor (default is while the terminal is running).
- **save** or **s** `bool` is an optional argument that specifies whether the analysis should be save in the cloud. If *save* is not specified, the value is *false*.
- **details** `bool` is an optional argument that specifies whether to show the details of the analysis. If *details* is not specified, the value is *false*.
- **period** or **p** `int` is an optional argument that specifies the period in milliseconds to sample task activity. If *period* is not specified, the value is *100*.

**Examples**
```
task.analyze
task.analyze:name=HelloWorld
task.analyze:duration=3
task.analyze:save
task.analyze:details
task.analyze:save,period=500
```

## terminal|term

###  terminal|term.run

The *terminal.run* command will read/write the stdio of the connected device and display it on the host computer terminal. The terminal will run until ^C is pushed.

**Usage**
```
run:[display=<bool>][,log=<string>][,append=<bool>][,while=<string>][,period=<int>][,duration=<int>]
```

**Arguments**

- **display** or **d** `bool` is an optional argument that , if true, displays the terminal data on the host terminal output (set to 'false' and use 'log' to just log to a file). If *display* is not specified, the value is *true*.
- **log** or **l** `string` is an optional argument that specifies the path to a file where the terminal data will be written.
- **append** or **a** `bool` is an optional argument that , if true, appends data to the log file. If *append* is not specified, the value is *false*.
- **while** or **w** `string` is an optional argument that specifies an application name to watch. The terminal will stop when the application terminates.
- **period** `int` is an optional argument that specifies how often to poll the terminal in milliseconds. Polling the terminal requires CPU processing on the connected device. Use a larger value here to limit, the device processing time spent on servicing this command. If *period* is not specified, the value is *10*.
- **duration** `int` is an optional argument that specifies how long to wait in seconds before stopping the terminal. If *duration* is not specified, the value is *<indefinite>*.

**Examples**
```
terminal.run
term.run:display=false
term.run:log=filename.txt
term.run:log=filename.txt,append=true
term.run:while=HelloWorld
term.run:while=HelloWorld,period=200
term.run:duration=2
```

###  terminal|term.listen

###  terminal|term.connect

## test

### test.run

The *test.run* command runs a test as defined in the local workspace.

**Usage**
```
run:name=<string>[,path=<string>][,case=<string>]
```

**Arguments**

- **name** or **n** `string` is a required argument that specifies the name of the test to run.
- **path** or **p** `string` is an optional argument that specifies the path to a JSON file that contains the test. If *path* is not specified, the value is *<none>*.
- **case** `string` is an optional argument that specifies the name of the test to run. If *case* is not specified, the value is *<all>*.

**Examples**
```
test.run:name=myTest
test.run:name=quickTest
test.run:name=quickTest
test.run:name=quickTest
```

### test.update

The *test.update* command updates or inserts a case into a test. If the test doesn't exist, it is created.

**Usage**
```
update:name=<string>,case=<string>,command=<string>[,clean=<string>][,arguments=<string>][,result=<bool>][,terminal=<bool>][,analyze=<bool>][,debug=<bool>][,while=<string>][,duration=<string>][,architecture=<string>][,json=<bool>][,order=<int>]
```

**Arguments**

- **name** or **n** `string` is a required argument that specifies the name of the test where the case will be inserted.
- **case** `string` is a required argument that specifies the name of the test case to insert.
- **command** `string` is a required argument that specifies the *sl* command to execute for this case.
- **clean** `string` is an optional argument that specifies a command used to clean up the test (the command is run after the test completes). If *clean* is not specified, the value is *<none>*.
- **arguments** or **args** `string` is an optional argument that specifies arguments passed to the program executed on the connected device (command must be *app.install* or *app.build*).
- **result** `bool` is an optional argument that specifies the expected result (true for success and false for fail) of the command. If *result* is not specified, the value is *true*.
- **terminal** `bool` is an optional argument that specifies the test should gather the terminal output. If *terminal* is not specified, the value is *false*.
- **analyze** `bool` is an optional argument that specifies the test should analyze the tasks running on the target device. If *analyze* is not specified, the value is *false*.
- **debug** or **trace** `bool` is an optional argument that specifies the test should gather the debug trace output from the target device. If *debug* is not specified, the value is *false*.
- **while** `string` is an optional argument that specifies the *while* argument when running the terminal.
- **duration** `string` is an optional argument that specifies the maximum duration of the test in seconds (default is no maximum).
- **architecture** or **arch** `string` is an optional argument that specifies where to take the *result*; if *arm*, result is taken from the connected device parsed from the *terminal* output; if *link*, it is taken from the native *sl* output. If *architecture* is not specified, the value is *link*.
- **json** `bool` is an optional argument that , if true, parses the target device terminal output as JSON (otherwise parsed as YAML). If *json* is not specified, the value is *true*.
- **order** `int` is an optional argument that specifies the order where the case will be inserted (default is appended to the end, zero is first). If *order* is not specified, the value is *<last>*.

**Examples**
```
test.update:name=myTest,case=build,command='app.build:path=HelloWorld,clean',result=true
test.update:name=buildTest
test.update:name=quickTest,case=HelloWorld
test.update:name=build,case=HelloWorld,command='app.build:path=HelloWorld'
test.update:name=execute,case=HelloWorld,command=\'app.install:path=HelloWorld\',clean=\'app.clean:path=device@/app/flash/HelloWorld\'
test.update:name=build,case=HelloWorld,command='app.run:path=HelloWorld',args='--version'
test.update:name=build,case=HelloWorld,command='app.build:path=HelloWorld',result=true
test.update:name=build,case=HelloWorld,command='app.build:path=HelloWorld',terminal=true,result=true
test.update:name=run,case=BlinkyAnalyze,command='app.install:path=Blinky,run',analyze=true
test.update:name=run,case=BlinkyDebug,command='app.install:path=Blinky,run',debug=true
test.update:name=run,case=HelloWorld,command='app.install:path=HelloWorld,run',terminal=true,while=HelloWorld,result=true
test.update:name=run,case=HelloWorld,command='app.install:path=HelloWorld,run',terminal=true,while=HelloWorld,duration=10
test.update:name=run,case=api-var-test,command='app.install:path=api-var-test,run',terminal=true,while=api-var-test,result=true,arch=arm
test.update:name=run,case=api-var-test,command='app.install:path=api-var-test,run',terminal=true,while=api-var-test,result=true,arch=arm,json=true
test.update:name=run,case=api-var-test,command='app.install:path=api-var-test,run',terminal=true,while=api-var-test,result=true,arch=arm,json=true,order=0
```

### test.remove

The *test.insert* command inserts a case into a test. If the test doesn't exist, it is created.

**Usage**
```
insert:name=<string>[,case=<string>]
```

**Arguments**

- **name** or **n** `string` is a required argument that specifies the name of the test to remove.
- **case** `string` is an optional argument that specifies the name of the test case to remove (if not specified the the entire test is removed). If *case* is not specified, the value is *<all>*.

**Examples**
```
test.remove:name=buildTest
test.remove:name=build
test.remove:name=build,case=HelloWorld
```

### test.wait

The *test.wait* command delays the specified amount.

**Usage**
```
wait:milliseconds=<string>
```

**Arguments**

- **milliseconds** or **ms** `string` is a required argument that specifies the amount of time to wait in milliseconds.

**Examples**
```
test.wait:milliseconds=1000
test.wait:ms=500
```

### test.export

The *test.export* command exports the tests in the local workspace to a file.

**Usage**
```
export:name=<string>
```

**Arguments**

- **name** or **n** `string` is a required argument that specifies the name of the output file.

**Examples**
```
test.export:name=build.json
test.export:name=buildAll.json
```


