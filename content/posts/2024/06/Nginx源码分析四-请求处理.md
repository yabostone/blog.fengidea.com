---
title: "Nginx源码分析四 请求处理"
date: 2024-06-19T15:46:39+08:00
draft: false
tags:
  - 源码
categories:
  - 技术
---



Nginx 是一个事件驱动的架构，它使用异步非阻塞的方式处理网络事件，这使得 Nginx 能够高效地处理大量并发连接。在 Nginx 中，事件处理是通过 `ngx_process_events_and_timers()` 函数和 `events` 模块来实现的。下面详细介绍这些组件。

### 1. `ngx_process_events_and_timers()`
这个函数是 Nginx 事件处理的核心。它负责处理所有的网络事件以及定时器事件。这个函数在 Nginx 的 worker 进程中被周期性地调用，以处理读写事件和定时任务。

```c
void ngx_process_events_and_timers(ngx_cycle_t *cycle) {
    ngx_uint_t  flags;
    ngx_msec_t  timer, delta;

    timer = ngx_event_find_timer();
    flags = NGX_UPDATE_TIME;

    if (timer == NGX_TIMER_INFINITE) {
        timer = 10;
    }

    delta = ngx_current_msec;

    ngx_process_events(cycle, timer, flags);

    delta = ngx_current_msec - delta;

    if (delta) {
        ngx_event_expire_timers();
    }
}
```

在这个函数中：
- `ngx_event_find_timer()` 查找最近的定时器。
- `ngx_process_events()` 是一个平台相关的函数，用于处理所有准备好的网络事件。这个函数的实现依赖于操作系统的事件机制，如 epoll（Linux）、kqueue（BSD 系统）等。
- `ngx_event_expire_timers()` 处理所有到期的定时器事件。

### 2. `events` 模块
Nginx 的 `events` 模块提供了对不同操作系统底层事件机制的抽象。这个模块定义了一组平台无关的接口，通过不同的实现模块来支持 epoll、kqueue 等机制。这样做的好处是 Nginx 的主体代码可以不用关心具体的事件机制，而是通过统一的接口来处理事件。

#### 文件结构
`events` 模块通常包含以下几个关键的文件：
- `ngx_event.h`：定义了事件模块的接口和数据结构。
- `ngx_event_timer.h`：定义了定时器相关的操作和数据结构。
- `ngx_epoll_module.c`：Linux 下的 epoll 事件处理实现。
- `ngx_kqueue_module.c`：BSD 系统下的 kqueue 事件处理实现。

#### 核心函数
- `ngx_epoll_init()`、`ngx_kqueue_init()`：初始化事件处理机制。
- `ngx_epoll_add_event()`、`ngx_kqueue_add_event()`：向事件机制中添加事件。
- `ngx_epoll_process_events()`、`ngx_kqueue_process_events()`：处理已经准备好的事件。

Nginx 使用不同的事件模块来处理操作系统级别的 I/O 事件，其中 `ngx_epoll_module` 和 `ngx_kqueue_module` 是两个非常重要的模块，分别用于 Linux 和 BSD 系统。这些模块允许 Nginx 高效地处理数以千计的并发连接。下面详细介绍这些模块和相关的关键函数。

### 1. `ngx_epoll_module`
这个模块是 Nginx 在 Linux 系统上使用的默认事件模型。它基于 Linux 的 epoll 接口，提供了高效的事件处理能力。

#### 核心函数
- **`ngx_epoll_init()`**：初始化 epoll，创建 epoll 文件描述符。
```c
static ngx_int_t ngx_epoll_init(ngx_cycle_t *cycle, ngx_msec_t timer) {
    if (ep == -1) {
        ep = epoll_create(1024);
    }

    ngx_epoll_module_ctx = cycle->log;
    ngx_io = ngx_os_io;

    ngx_event_actions = ngx_epoll_module_ctx;

    return NGX_OK;
}
```

- **`ngx_epoll_add_event()`**：向 epoll 实例添加事件监听。
```c
static ngx_int_t ngx_epoll_add_event(ngx_event_t *ev, ngx_int_t event, ngx_uint_t flags) {
    struct epoll_event ee;
    ngx_int_t op;
    ngx_event_t *e;
    ngx_connection_t *c;

    c = ev->data;
    e = (event == NGX_READ_EVENT) ? c->write : c->read;

    ee.events = EPOLLERR | EPOLLHUP;
    ee.data.ptr = (void *)((uintptr_t)c | ev->instance);

    if (ev->active) {
        op = EPOLL_CTL_MOD;
        ee.events |= e->active ? (EPOLLIN|EPOLLOUT) : ee.events;
    } else {
        op = EPOLL_CTL_ADD;
        ee.events |= event;
    }

    if (epoll_ctl(ep, op, c->fd, &ee) == -1) {
        ngx_log_error(NGX_LOG_ALERT, ev->log, ngx_errno, "epoll_ctl(%d, %d) failed", op, c->fd);
        return NGX_ERROR;
    }

    ev->active = 1;

    return NGX_OK;
}
```

- **`ngx_epoll_process_events()`**：处理已经准备好的事件。
```c
static ngx_int_t ngx_epoll_process_events(ngx_cycle_t *cycle, ngx_msec_t timer, ngx_uint_t flags) {
    int events, revents, i;
    ngx_int_t instance, ready;
    ngx_event_t *rev, *wev;
    ngx_queue_t *queue;
    struct epoll_event ee[NGX_MAX_EVENTS];

    events = epoll_wait(ep, ee, NGX_MAX_EVENTS, timer);

    if (events == -1) {
        ngx_log_error(NGX_LOG_ALERT, cycle->log, ngx_errno, "epoll_wait() failed");
        return NGX_ERROR;
    }

    for (i = 0; i < events; i++) {
        revents = ee[i].events;
        ngx_connection_t *c = (ngx_connection_t *) ee[i].data.ptr;

        instance = (uintptr_t) c & 1;
        c = (ngx_connection_t *) ((uintptr_t) c & (uintptr_t) ~1);

        rev = c->read;
        wev = c->write;

        if (c->fd == -1 || rev->instance != instance) {
            continue;
        }

        if (revents & (EPOLLERR | EPOLLHUP | EPOLLRDHUP)) {
            rev->ready = 1;
            wev->ready = 1;
        }

        if ((revents & EPOLLIN) && rev->active) {
            rev->handler(rev);
        }

        if ((revents & EPOLLOUT) && wev->active) {
            wev->handler(wev);
        }
    }

    return NGX_OK;
}
```

### 2. `ngx_kqueue_module`
这个模块是 Nginx 在 BSD 系统（包括 macOS）上使用的事件模型。它基于 BSD 的 kqueue 接口。

#### 核心函数
- **`ngx_kqueue_init()`**：初始化 kqueue，创建 kqueue 文件描述符。
- **`ngx_kqueue_add_event()`**：向 kqueue 实例添加事件监听。
- **`ngx_kqueue_process_events()`**：处理已经准备好的事件。

这些函数的实现类似于 `ngx_epoll_module`，但是使用的是 kqueue 相关的系统调用。  这些函数的具体分析的时候，有机会的时候上到专门的代码进行debug方式的调用。



