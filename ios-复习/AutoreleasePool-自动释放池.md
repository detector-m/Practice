## AutoreleasePool-自动释放池

### AutoreleasePool（自动释放池）

AutoreleasePool（自动释放池）：是 OC 中的一种内存自动回收机制，在释放池中调用了 autorelease 方法的对象都会被压入该池的顶部（以栈的形式管理对象）。当自动释放池被销毁的时候，在该池中的对象会自动调用 release 方法来释放资源，销毁对象。以此来达到自动管理内存的目的。

AutoreleasePool-自动释放池结构图：

![AutoreleasePool-自动释放池结构图](AutoreleasePool-%E8%87%AA%E5%8A%A8%E9%87%8A%E6%94%BE%E6%B1%A0%E7%BB%93%E6%9E%84%E5%9B%BE.webp)


#### __AtAutoreleasePool
__AtAutoreleasePool 实际是一个结构体，在内部首先执行 objc_autoreleasePoolPush()，让后再调用 objc_autoreleasePoolPop(atautoreleasepoolobj).

    ```
    Struct __AtAutoreleasePool {
        __AtAutoreleasePool() {
            // 构造函数，在创建时调用
            atautoreleasepoolobj = objc_autoreleasePoolPush();
        }

        ~__AtAutoreleasePool() {
            // 析构函数，在结构体销毁时调用
            objc_autoreleasePoolPop(atautoreleasepoolobj);
        }

        void *atautoreleasepoolobj;
    };
    ```

#### AutoreleasePoolPage 的结构

* 每个 AutoreleasePoolPage 对象占用 4096 字节内存，除了用来存放它内部成员变量，剩下空间用于存放 autorelease 对象的地址。
* 所有 AutoreleasePoolPage 对象通过双链表连接在一起。

AutoreleasePool-自动释放池-AutoreleasePoolPage结构图：

![AutoreleasePool-自动释放池-AutoreleasePoolPage结构图](AutoreleasePool-%E8%87%AA%E5%8A%A8%E9%87%8A%E6%94%BE%E6%B1%A0-AutoreleasePoolPage%E7%BB%93%E6%9E%84%E5%9B%BE.webp)

* 调用 push 方法会将一个 POOL_BOUNDARY 入栈，并返回其存放的内存地址。
* 调用 pop 方法时传入一个 POOL_BOUNDARY 的内存地址，会从最后一个入栈的对象开始发送 release 消息，知道遇到这个 POOL_BOUNDARY.
* id *next 指向下一个能释放 autorelease 对象的区域。


### Autorelease 何时释放？

* 1、手动调用 AutoreleasePool 的释放方法（drain 方法）。
* Autorelease 对象是在当前 RunLoop 迭代结束时释放的，而它能够释放的原因是系统在每个 RunLoop 迭代中都加入自动释放池 Push 和 Pop。

### RunLoop 和 Autorelease 的关系

* App 启动后，系统在线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()。
* 第一个 Observer 监听事件 Entry (即将进入 Loop)，其回调会调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是 -2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
* 第二个 Observer 监听两个事件：BeforWating（准备进入休眠）时调用 _objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；Exit（即将退出 Loop）时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证释放池子的操作发生在其他所有回调之后。

AutoreleasePool-自动释放池-Runloop和Autorelease关系图：

![AutoreleasePool-自动释放池-Runloop和Autorelease关系图](AutoreleasePool-%E8%87%AA%E5%8A%A8%E9%87%8A%E6%94%BE%E6%B1%A0-Runloop%E5%92%8CAutorelease%E5%85%B3%E7%B3%BB%E5%9B%BE.webp)