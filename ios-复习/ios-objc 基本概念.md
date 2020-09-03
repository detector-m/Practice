## ios-objc 基本概念

#### Property属性

1. 原子性：nonatomic, atomic

	* atomic: 原子性, 每次只有一个线程访问，是线程安全。定义属性时默认是atomic。由于是原子性，使用时会有同步锁产生，有性能损耗。
	* nonatomic: 非原子性，多个线程可同时访问，非线程安全。效率高，但可能导致生产者消费者问题。
	
2. 读写：readwrite, readonly

	* readwrite: 定义属性时默认时可读写。
	* readonly: 只读属性，外界不可对其进行设值。
			
			// 只读
			@property(nonatomic, readonly, copy) NSString *strA;
			// 可读性
			@property(nonatomic, readwrite, copy) NSString *strB;
			
			// 如果某个实例只允许被外部读取，而不能写入操作，同时在类实现文件当中可以写入的话，可以在头文件中声明属性为只读的，在实现文件中设置其为可读写的属性。
			// 头文件中(.h)
			@property(nonatomic, readonly, copy) NSString *strA;
			// 实现文件中(.m)
			@property(nonatomic, readwrite, copy) NSString *strA;
	
3. 方法名：getter=<gettername>, setter=<settername>

			// getter=<name>的样式
			@property(nonatomic, getter=isEnable) BOOL enable;
	
4. 内存：strong, retain, copy, weak, assign, unsafe_unretained

	* assign: 用于修饰值类型（如int， float）, 即不会更改所赋新值的引用计数，也不改变旧值的引用计数。虽然也可以修饰引用类型，但是修饰的对象释放后，指针不会自动被置空，此时向对象发消息会崩溃（产生野指针）。
	* weak: 用于修饰引用类型, 即不会更改所赋新值的引用计数，也不改变旧值的引用计数。因为weak修饰的对象释放后（引用计数器值为0），指针会自动被置nil，之后再向该对象发消息也不会崩溃。 weak是安全的（不会产生野指针）。
	* unsafe_unretained: 只修饰引用类型, 即不会更改所赋新值的引用计数，也不改变旧值的引用计数。

	
	--------
	* strong: 用于修饰引用类型，强引用， 用于ARC中。
	* retain: 用于修饰引用类型，强引用， 用于MRC中。
	* copy: 用于修饰引用类型，copy分为浅层复制和深复制两种，NSString、NSArray、NSDictionary等不可变类型都为浅层复制，即其引用计数会+1，而不会创建新的内存。


#### 沙盒的目录结构

1. Documents: 保存app运行生成持久化数据，该目录会被iTunes同步备份。
2. Libary/Caches: 保存app运行时生成需要持久化的数据，iTunes同步时不会备份。一般存储体积大、不需要备份的非重要数据，如何缓存等。
3. Libary/Preference: 保存app所有的偏好设置，ios的Settings应用会在此查找app的设置信息。iTunes会备份该目录。
4. tmp: 保存app运行时需要的临时数据，一定时间后系统会对此进行清理。不会被iTunes备份。


#### 内存中区域的划分

1. 栈区（statck）: 由系统自动分配/释放，存放局部变量，容量小，先进后出。
2. 堆区: 由程序员自行支配，申请/释放。容量大，无序。
3. 静态存储区: 全局变量（外部变量）和静态变量存放的区域。程序结束由系统回收。
4. 常量区: 存放常量的内存区，程序结束系统回收。
5. 代码区，存放可执行的二进制代码。


#### ios远程推送

1. app安装启动提示用户是否接收推送，用户确认消息推送。
2. app接收APNS Server下发的令牌（DeviceToken）。
3. app将APNS Server下发的令牌（DeviceToken）发送到自己服务端。
4. 当需要给用户推送时，自己服务器向苹果的推送通知服务器(Apple Push Notification Service,以下简称 APNS)发送推送请求。
5. APNS再根据设备的令牌（DeviceToken）推送消息。


#### block的使用


