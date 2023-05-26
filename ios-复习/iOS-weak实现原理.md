## weak 基本用法

weak 是弱引用，用 weak 修饰的对象的内存引用计数器不会增加，而且该对象在被释放的时候会自动设置为 nil，这样就避免了野指针的出现，从而避免了野指针造成的崩溃。weak 也可以解决循环引用问题。

### 为什么使用 weak 而不是用 assig 修饰对象？

* assgin 可用来修饰基本数据类型，也可修饰 OC 对象，但如果用 assign 修饰对象类型是一个强引用，当这个对象被释放后，assign 修饰对象的指针仍指向这块内存，必须手动设置为 nil，否则会产生野指针，如果通过此指针操作那块内存，会导致 EXC_BAD_ACCESS 错误，导致崩溃。
* weak 只用来修饰 OC 对象，而且相比 assign 比较安全，如果指向对象被释放，那么它就会自动设置为 nil，不会产生野指针。

## weak 实现原理

runtime 维护了一个 weak 表，用于存放指向某个对戏的所有 weak 指针。weak 表其实是一个 hash 表，Key 是所指对象的地址，Value 是 weak 指针的地址（这个地址的值是指向对象的地址）数组。

实现原理：
* 1、初始化时，runtime 会调用 objc_initWeak 函数，初始化一个新的 weak 指针指向对象的地址。
* 2、添加引用时，objc_initWeak 函数会调用 objc_storeWeak() 函数新增弱引用指针到弱引用表。
* 3、释放时，调用 clearDeallocation 函数。clearDeallocating 函数会根据对象地址获取 weak 指针列表，然后遍历 weak 指针列表把释放的对象所有 weak 指针设置为nil，最后把这个 entry 从 weak 表中删除，最后清理对象的记录。