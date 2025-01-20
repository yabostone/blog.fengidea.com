---
title: "Nginx源码分析五 退出处理"
date: 2024-06-19T15:57:38+08:00
draft: false
tags:
  - 源码
categories:
  - 技术
---

### 退出函数流程概述

在 Nginx 的代码中，退出函数主要负责关闭资源、记录日志、发送信号等操作，以确保进程可以安全、干净地退出。以下是一些主要的退出函数及其流程：

#### 1. [ngx_worker_process_exit](file:///f%3A/Archive/nginx-master/nginx-master/src/os/win32/ngx_process_cycle.c#824%2C1-824%2C1) (UNIX)
此函数用于处理 worker 进程的退出。它会遍历所有模块，调用它们的 [exit_process](file:///f%3A/Archive/nginx-master/nginx-master/src/os/win32/ngx_process_cycle.c#832%2C32-832%2C32) 钩子，关闭所有打开的连接，并销毁内存池。

```940:996:src/os/unix/ngx_process_cycle.c
ngx_worker_process_exit(ngx_cycle_t *cycle)
{
    ngx_uint_t         i;
    ngx_connection_t  *c;

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->exit_process) {
            cycle->modules[i]->exit_process(cycle);
        }
    }
```


#### 2. `ngx_master_process_exit` (UNIX)
此函数用于处理 master 进程的退出。它会删除 PID 文件，关闭监听套接字，调用所有模块的 `exit_master` 钩子，并销毁内存池。

```656:694:src/os/unix/ngx_process_cycle.c
ngx_master_process_exit(ngx_cycle_t *cycle)
{
    ngx_uint_t  i;

    ngx_delete_pidfile(cycle);

    ngx_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exit");

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->exit_master) {
            cycle->modules[i]->exit_master(cycle);
        }
    }

    ngx_close_listening_sockets(cycle);

    /*
     * Copy ngx_cycle->log related data to the special static exit cycle,
     * log, and log file structures enough to allow a signal handler to log.
     * The handler may be called when standard ngx_cycle->log allocated from
     * ngx_cycle->pool is already destroyed.
     */


    ngx_exit_log = *ngx_log_get_file_log(ngx_cycle->log);

    ngx_exit_log_file.fd = ngx_exit_log.file->fd;
    ngx_exit_log.file = &ngx_exit_log_file;
    ngx_exit_log.next = NULL;
    ngx_exit_log.writer = NULL;

    ngx_exit_cycle.log = &ngx_exit_log;
    ngx_exit_cycle.files = ngx_cycle->files;
    ngx_exit_cycle.files_n = ngx_cycle->files_n;
    ngx_cycle = &ngx_exit_cycle;

    ngx_destroy_pool(cycle->pool);

    exit(0);
```


#### 3. `ngx_worker_process_exit` (Windows)
与 UNIX 版本类似，此函数处理 Windows 下的 worker 进程退出，关闭所有连接，并销毁内存池。

```824:855:src/os/win32/ngx_process_cycle.c
ngx_worker_process_exit(ngx_cycle_t *cycle)
{
    ngx_uint_t         i;
    ngx_connection_t  *c;

    ngx_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exit");

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->exit_process) {
            cycle->modules[i]->exit_process(cycle);
        }
    }

    if (ngx_exiting && !ngx_terminate) {
        c = cycle->connections;
        for (i = 0; i < cycle->connection_n; i++) {
            if (c[i].fd != (ngx_socket_t) -1
                && c[i].read
                && !c[i].read->accept
                && !c[i].read->channel
                && !c[i].read->resolver)
            {
                ngx_log_error(NGX_LOG_ALERT, cycle->log, 0,
                              "*%uA open socket #%d left in connection %ui",
                              c[i].number, c[i].fd, i);
            }
        }
    }

    ngx_destroy_pool(cycle->pool);

    exit(0);
```


#### 4. `ngx_master_process_exit` (Windows)
处理 Windows 下的 master 进程退出，关闭事件句柄，并销毁内存池。

```542:565:src/os/win32/ngx_process_cycle.c
ngx_master_process_exit(ngx_cycle_t *cycle)
{
    ngx_uint_t  i;

    ngx_delete_pidfile(cycle);

    ngx_close_handle(ngx_cache_manager_mutex);
    ngx_close_handle(ngx_stop_event);
    ngx_close_handle(ngx_quit_event);
    ngx_close_handle(ngx_reopen_event);
    ngx_close_handle(ngx_reload_event);
    ngx_close_handle(ngx_master_process_event);

    ngx_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exit");

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->exit_master) {
            cycle->modules[i]->exit_master(cycle);
        }
    }

    ngx_destroy_pool(cycle->pool);

    exit(0);
```


### 退出时需要注意的字段

在处理退出流程时，需要注意以下几个关键字段：

- **ngx_exiting**：标识进程是否正在退出。
- **ngx_terminate**：标识是否接收到终止信号。
- **ngx_quit**：标识是否接收到优雅退出的信号。
- **ngx_reopen**：标识是否需要重新打开文件。

这些字段通常在接收到相应的信号后设置，并在退出函数中检查，以确定执行哪些清理和关闭操作。

### 退出过程中的日志记录

在退出过程中，Nginx 会记录各种日志，以帮助跟踪和调试退出过程。例如，它会记录退出的原因、关闭的连接和文件、以及任何错误信息。

```662:662:src/os/unix/ngx_process_cycle.c


static void
ngx_master_process_exit(ngx_cycle_t *cycle)
{
    ngx_uint_t  i;

    ngx_delete_pidfile(cycle);

    ngx_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exit");

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->exit_master) {
            cycle->modules[i]->exit_master(cycle);
        }
    }

    ngx_close_listening_sockets(cycle);

    /*
     * Copy ngx_cycle->log related data to the special static exit cycle,
     * log, and log file structures enough to allow a signal handler to log.
     * The handler may be called when standard ngx_cycle->log allocated from
     * ngx_cycle->pool is already destroyed.
     */


    ngx_exit_log = *ngx_log_get_file_log(ngx_cycle->log);

    ngx_exit_log_file.fd = ngx_exit_log.file->fd;
    ngx_exit_log.file = &ngx_exit_log_file;
    ngx_exit_log.next = NULL;
    ngx_exit_log.writer = NULL;

    ngx_exit_cycle.log = &ngx_exit_log;
    ngx_exit_cycle.files = ngx_cycle->files;
    ngx_exit_cycle.files_n = ngx_cycle->files_n;
    ngx_cycle = &ngx_exit_cycle;

    ngx_destroy_pool(cycle->pool);

    exit(0);
}
```


### 总结

Nginx 的退出流程涉及多个函数和多个平台，每个函数都负责清理特定的资源和调用相关的钩子。理解这些函数及其关联的字段对于维护和调试 Nginx 是非常重要的。