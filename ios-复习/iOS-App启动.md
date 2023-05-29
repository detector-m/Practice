## App 启动

App 的冷启动可概括为3个阶段： dyld，runtime，main

### 1、dyld

dyld（dynamic link editor），Apple 的动态连接器，可用于装载 Mach-O 文件（可执行文件、动态库等）。

启动 App 时，dyld 所做的事情有：
    * 1、装载 App 的可执行文件，同时会递归加载所有依赖的动态库。
    * 2、当 dyld 把可执行文件、动态库装载完毕后，会通知 Runtime 进行下一步处理。

### 2、runtime

启动 App 时，runtime 所做事情有：

    * 1、调用 map_images 进行可执行文件内容的解析和处理。
    * 2、调用 load_images， 并在 load_images 中调用 call_load_methods，调用所有 Class 和 Category 的 +load 方法。
    * 3、进行各种 objc 结构的初始化（注册 Objc 类、初始化类对象等等）。
    * 4、调用 C++ 静态初始化器和 attribute((constructor)) 修饰的函数。

### 3、main

UIApplicationMain 函数，AppDelegate 的 application:didfinishLauchingWithOptions: 方法。


## App 启动优化

![App 启动优化](App%E5%90%AF%E5%8A%A8-%E5%90%AF%E5%8A%A8%E4%BC%98%E5%8C%96.webp)