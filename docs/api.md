# API Reference

Stratify OS applications can be built using the StratifyAPI library which is an embedded friendly C++ library for many POSIX and standard C library functions. Or they can be built using direct calls to POSIX and standard C library functions.

- [Stratify API Reference](../StratifyAPI/)
- [POSIX pthread Reference](../StratifyOS/pthread/)
- [POSIX unistd Reference](../StratifyOS/unistd/)
- [POSIX dirent Reference](../StratifyOS/directory/)
- [POSIX time Reference](../StratifyOS/time/)
- [POSIX signals Reference](../StratifyOS/signal/)
- [POSIX semaphore Reference](../StratifyOS/semaphore/)
- [POSIX mqueue Reference](../StratifyOS/mqueue/)
- [Standard C Library Reference](../StratifyOS/stdc/)
- [Error Numbers Reference](../StratifyOS/errno/)


# Thread Example

The following is an example of using the StratifyAPI to create a thread versus using POSIX directly.

```c++
//Using the StratifyAPI
#include <sapi/sys.hpp>

void * thread_function(void * args){
    u32 * argument = (u32*)args;
    //execute thread stuff
    //*argument is equal to 10
    return NULL;
}

int main(int argc, char * argv[]){
    Thread thread;
    u32 argument = 10;
    thread.create(thread_function, &argument);
    thread.wait();
}
```

```c
//Using POSIX
#include <pthread.h>

void * thread_function(void * args){
    
    u32 * argument = (u32*)args;
    //execute thread stuff

    //*argument is equal to 10

    return NULL;
}

int main(int argc, char * argv[]){
    pthread_t t;
    pthread_attr_t attr;

    if ( pthread_attr_init(&attr) < 0 ){
        perror("failed to initialize attr");
        return -1;
    }

    if ( pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED) < 0 ){
        perror("failed to set detach state");
        return -1;
    }

    if ( pthread_attr_setstacksize(&attr, 4096) < 0 ){
        perror("failed to set stack size");
        return -1;
    }

    if ( pthread_create(&t, &attr, thread_function, NULL) ){
        perror("failed to create thread");
        return -1;
    }

    //this just checks to see if the thread is still valid (doesn't send a signal)
    while( pthread_kill(t, 0) == 0 ){
        usleep(100*1000);
    }
    return 0;
}
```