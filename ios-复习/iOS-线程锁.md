## iOS-线程锁

多线程情况下访问共享资源需要进行线程同步，线程同步一般都用锁实现。从操作系统层面，锁的实现有临界区、事件、互斥量、信号量等。iOS 中有如下几种方式：

* 1、automic（原子操作）: 属性加上 automic 关键字，编译器会自动给该属性生成代码用于多线程访问同步，它并不能保证使用属性的过程是线程安全的。一般我们在定义属性时使用 nonatomic，避免性能损失。
* 2、@synchronized(object): @synchronized 指令是一个对象锁，用起来非常简单。使用 object 为该锁的唯一标识，只用当表示标识相同时，才为满足互斥，如果线程1和线程2 @synchronize 后面的 object 不相同，则不会互斥。@synchronized其实是对 pthread——mutex 递归锁的封装。使用简单，但是开销较大（隐式的添加一个异常处理程序）。
* 3、NSLock：最简单的锁，调用 lock 进行上锁，unlock 解锁。如果其它线程已经调用lock获取了锁，当前线程调用lock方法会阻塞当前线程，直到其它线程调用unlock释放锁为止。
* 4、NSRecursiveLock: 递归锁主要是用来解决同一个线程频繁获取同一个锁而造成的死锁问题。lock 和 unlock 必须配对使用。
* 5、NSConditonLock: 条件锁，可设置自定义条件锁。如生产者消费者模型可以用条件锁。
* 6、NSCondition: 条件信号量。
* 7、dispatch_semaphore_t: 信号量实现。可以用于控制 GCD 队列任务的同步。
* 8、pthread_mutex: 互斥锁
* 9、OSSpinLock：自旋锁，等待锁的线程处于忙等待。一直占用 CPU。好比 while 循环。OSSpinLock 不是安全锁，会造成优先级反转，可能导致死锁。
* 10、os_unfair_lock: 用于取代不安全的 OSSpinLock, 等待 os_unfair_lock 锁的线程会处于休眠状态，并非忙等。
    ```
    os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
    // 加锁
    os_unfair_lock_lock(&lock);
    // 解锁
    os_unfair_lock_unlock(&lock);
    ```

新能排序：os_unfair_lock > OSSpinLock > dispatch_semaphore_t > pthread_mutex > NSLock > NSCondition > NSRecursiveLock > NSConditionLock > @synchronized