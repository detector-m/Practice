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

1. block什么要使用copy
	
	* block在创建的时候默认分配在栈上，其本身的作用域就是创建时候的作用域，一旦在创建之外的作用域调用就会导致程序crash，所以使用copy拷贝到堆上。
	* block创建在栈上，而block的代码中可能会用到了本地的变量，只用拷贝到堆上才能改变这些变量的值。
	
2. block为什么不用retain
	
	retain只是引用加一，block还是在栈上，当离开作用域，随时都会被系统回收。
	
3. 为什么进入block中的对象引用计数需要自动加1
	
	block执行的是回调，因此block并不知道其中引用的对象obj会在什么时候会被释放，为了使引用的obj在使用之前不被提前释放，block就对引用的对象obj进行了引用计数加1（retain）
	
4. block和函数的关系

	block使用很像函数指针，不过最大的不同是block可以访问block以外、词法作用域以内的外部变量的值。
	
	block不仅实现了函数的功能，还能携带函数的执行环境。
	
5. block的理解

	block实际上是指向结构体的指针，编译器会将block内部代码生成对应的函数和结构体。
	
6. block捕获值

	* 对于非全局、静态变量的基本数据类型，进入block中会做值传递（常量处理）。
		
			int n1 = 6;
			void (^testBlock1)() = ^{
				NSLog(@"value = %d", n1);
			};
			n1 = 20;
			testBlock1(); // 输出 6
			
			// 如果需要对捕获的值进行修改 如果需要在block中对num进行修改，需要加上关键字__block
			__block int n2 = 6;
			void (^testBlock2)() = ^{
				NSLog(@"value = %d", n1);
			};
			n2 = 10;
			testBlock2(); // 输出 10
			
	* 对于全局、静态变量的基本数据类型，读写都可。
	* 对于引用类型，可能会对导致循环引用

7. block的循环引用
	
	block默认创建在栈上，当在使用block时，有可能会将block拷贝（copy）到堆上，此时block中会对其外部的强引用类型进行强引用即引用计数会加1（retain），由此可能导致循环引用。如：self的循环引用。
	
	解决方法：
	* 在MRC下，使用__block修饰引用的对象。
	* 在ARC下，使用__unsafe_unretained/weak修饰引用对象。
	
	
#### 循环引用出现的情景

1. NSTimer: timer对象作为某个对象（obj）的属性，本意是在obj的dealloc中释放timer，但是timer没有停止就不会出发obj的dealloc，就导致了相互等待，造成循环引用。解决办法，显示的调用timer的停止方法（invaluate）。

	NSTimer 会对target（无视修饰符weak等）进行retain操作，持有了target。
	
2. block: 会对引用类型进行retain操作，可配合weak使用。
3. delegate: 使用assign（MRC）或者weak（ARC）修饰代理属性。

		// 循环引用示例
		NSMutableArray *one = [NSMutableArray array];
		NSMutableArray *two = [NSMutableArray array];
		[one addObject: two];
		[two addObject: one];
		

#### ios中的多线程

1. 概念

	多线程: 多线程是对于单核cpu来设计的，目的是为了让cpu在多个线程之间进行调度。提高cpu的利用率。
	
	##### 多线程的优缺点
	
	* 优点：提高程序的执行效率。
	* 缺点：开启线程需要一定的时间和内存空间。会产生消费者生产者问题（资源竞争）。

	##### 同步和异步
	
	决定了是否具备开启新的线程能力。
	
	* 同步：在当前线程中执行任务，不具备开启新线程的能力。
	* 异步：在新的线程中执行任务，具备开启新线程的能力。

	##### 并行和串行
	
	决定了任务的执行方式。
	
	* 并行：多个任务并发（同时）执行。
	* 串行：任务一个一个执行。

	##### 队列
	
	1. 串行队列
		
		* 同步执行：当前线程，一个一个执行
		* 异步执行：其他线程（新线程），一个一个执行
		
	2. 并行队列

		* 同步执行：当前线程，一个一个执行
		* 异步执行：其他线程（新线程），同时执行

	ios app中都是一个主线程，称为UI线程。那么主线程更新UI，显示或者刷新界面等。
	
	注意：不能将耗时的任务放在主线程上， 否则会存在卡顿现象。


2. ios多线程编程技术

	* posix thread：unix 多线程编程技术
	* NSThread：直接操作线程对象，需要手动管理线程的生命周期，经常使用该方式查看线程信息。
	* GCD(Grand Central Dispatch)：底层使用c来封装，使用灵活方便，效率高，性能好。可根据系统负荷来增减线程。
	* Cocoa NSOperation：基于GCD的封装，面向对象方式，易于理解，多线程更高级的封装。将任务封装为NSOperation，添加到NSOperationQueue对象中。子类化NSOperation的设计，更具面向对象特性，拓展性强，能够更灵活控制线程开启、暂停、关闭等。适用用于复杂的项目中。

3. 进程与线程

	Progress和Thread，进程和线程是操作系统里的基本概念。
	
	##### 线程与进程的区别
	
	* 进程是操作系统资源分配的最小单位。是程序的执行活动。进程拥有独立运行所需的全部资源。各个进程有独立的地址空间。进程切换时，消耗资源大，效率低。一个可运行的app就是一个进程。
	* 线程是进程的一部分，是处理器调度的基本单位。同一个进程里的所有线程共享该进程里的资源。单独的线程不能独立执行，必须依附于进程。

	
* 多进程，允许多个任务同时执行。
* 多线程，允许单个任务分为不同的部分运行。


#### 音频播放相关知识

音频的播放从形式上分为音频播放和音乐播放。

* 音频播放：通常时间短，不需要进度控制、循环控制。使用AudioToolbox.framework。
* 音乐播放：通常时间长，需要进行精准控制。使用AVFoundation.framework。

##### 音频播放

AudioToolbox.framework是基于C语言的框架。原理：将短音频注册到系统声音服务（System Sound Service）中。

系统声音服务（System Sound Service）是一种简单、底层的声音播放服务。

* 音频播放时间不能超过30秒。
* 数据必须是PCM或IMA4格式。
* 音频格式必须打包成.caf, .aif, wav中的一种。


##### 音乐播放

1. 适合播放较大的音频
2. 可以对音频进行精准的播放控制
3. 使用AVFoundatation.framework中的AVAudioPlayer来实现。

使用方式：

1. 初始化AVAudioPlayer对象，通常是指定本地文件路径。
2. 设置播放器属性，例如播放次数，音量大小等。
3. 调用play方法播放。

<span>注意：</span> AVAudioPlayer一次只能播放一个音频文件，所有的上一曲和下一曲都是通过创建多个AVAudioPlayer来实现的。


#### 视频播放

苹果为我们提供了多种方法来实现视频播放，包括MPMoviePlayerController，MPMoviePlayerViewController， AVPlayer， AVPlayerViewController等。但是MPMoviePlayerController与MPMoviePlayerViewController在ios9之后被废弃了。

##### AVPlayer

* 优点：接近底层，自定义UI更加灵活
* 缺点：不自带控制UI，使用频繁
* 使用：继承与NSObject，无法单独显示播放视频，需要借助AVPlayerLayer，添加图层到需要展示的图层上才能显示视频。


##### AVPlayerViewController

* 优点：自带播放控制UI，使用方便
* 缺点：不能自定义UI

* 使用：
	1. 继承于UIViewController，作为视图控制器弹出播放界面，也可添加view的方式播放。
	2. 需要设置AVPlayer成员变量，来创建AVPlayerViewController。


#### oc中的反射机制

1. class反射：通过类名字符串实例化对象

		Class class = NSClassFromString(@"Student");
		Student *student = [[class alloc] init];

2. 类名转化字符串

		Class class = [student class];
		NSString *className = NSStringFromClass(class);
		
3. SEL的反射

		SEL selector = NSSelectorFromClass(@"setName");
		[student performSelector:selector withObject: nil];
		
4. 通过方法字符串形式实例化方法

		NSString *selName = NSStringFromSelector(@selector(setName:));
		

#### 一个对象被创建的三个步骤

1. 开辟内存空间。
2. 初始化参数。
3. 返回内存地址值。

#### layouSubView何时调用

1. 初始化的时候不会触发。
2. 滚动UIScrollview时触发。
3. 旋转屏幕时触发。
4. 改变view的frame时会触发。

#### oc动态运行时语言的理解

1. oc将数据、对象类型的确定从编译阶段推迟到了运行时。
2. 动态绑定，基于消息转发，可以动态的给对象绑定方法等。
3. 动态加载，能够动态的创建类，加载类。

#### 队列

1. 主线程队列
	
	主线程队列为串行队列，和主线程绑定。同普通串行队列一样，队列中的任务一个一个执行。但是队列中的所有任务都是在主线程中执行（即使时通过异步添加到主线程队列的任务，也是在主线程执行）。
	
2. 全局队列

	系统全局队列为并发队列，根据不同的优先级（HIGH, DEFAULT, LOW, BACKGROUND）有四个。
	
3. 自定义队列

	系统提供方法，可以自定义创建串行和并行队列。
	
<span>注意：</span>

1. 串行队列添加同步任务会导致死锁。
2. 主队列中的所有任务都在主线程执行。

#### 常见的http状态吗

302是请求重定向
500及以上是服务器错误，503表示服务器找不到，
400及以上是请求连接错误或者找不到服务器，404
200及以上是正确。

[Http状态码详细说明]("https://tool.oschina.net/commons?type=5")


#### UDID与UUID

* UDID（Unique Device Identifier）用户设备唯一编码
* UUID (Universally Unique Identitifer) 通用唯一识别符

		NSString *uuidString = [[[UIDevice currentDevice] identifierForVendor] UIIDString];

		
#### nil, Nil, NULL, NSNull

1. nil: 一般只把一个空对象置空，完全从内存中释放。
2. Nil: 基本与nil没什么区别。区别在于nil是置空一个对象，Nil是置空一个类。
3. NULL: 源于c，表示一个空指针。 char *p = NULL;
4. NSNull: 表示一个空的对象。 [array addObject:[NSNull new]];

#### MRC和ARC内存管理

ARC，自动引用计数（Automatic Refrence Counting)，省去了程序员手动管理内存的麻烦。

* ARC项目： 加入MRC
	
	target->build phrases->compbile sources, 点击MRC的文件将其设置为-fno-objc-arc
	
* MRC项目： 加入ARC

	target->build phrases->compbile sources, 点击ARC的文件将其设置为-fobjc-arc
	

ios通过引用计数来记录对象的引用，每次runloop完成一次循环时，都会对对象的retainCount进行检查，如果说对象的retainCount为0，说明该对象未被引用，就会释放掉。


#### 黑盒测试与白盒测试

* 黑盒测试：又称为功能测试，注意检查软件的每一个功能是否能正常使用。黑盒法是穷举输入测试，只有把所有可能的输入都作为测试情况使用，才能以这种方法查出程序中所有的错误。

* 白盒测试：也称为结构测试，主要用于检测软件编码过程的错误。全面了解程序内部逻辑结构、对所有逻辑路径进行测试。


#### 浅拷贝和深拷贝

浅拷贝：指针拷贝，不增加新的内存。只是新增加一个指针指向原来的内存区域。
深拷贝：内容拷贝，同时拷贝指针和指针指向的内存区域。新增指针指向新的内存。

拷贝条件：
ios中并非所有的对象都支持copy和mutableCopy，只有遵循了NSCopy协议和NSMutableCopy协议的类才行。如果遵循着两个协议就必须分别实现copyWithZone和mutableCopyZone方法

拷贝原则：

1. 非容器类：像NSString，NSNumber这样的不能包含其他的系统类

	* 不可变对象调用copy时浅拷贝，而调用mutableCopy是深拷贝并得到可变对象。
	* 可变对象调用copy和mutableCopy都是深拷贝，区别于copy返回是不可变对象，mutableCopy返回可变对象。

2. 容器类：NSArray、NSMutableArray等系统类
	
	* 不可变对象调用copy是浅拷贝，而调用mutableCopy是深拷贝，并返回可变对象
	* 可变对象调用copy和mutableCopy都是深拷贝，区别于copy返回不可变对象，mutableCopy返回可变对象。

3. 自定义类：比如我们自定义一个Student类（实现拷贝协议）
	
	* 拷贝协议的具体实现不同，拷贝效果也就不同。在实现的拷贝协议方法中直接返回对象的self就相当于浅拷贝，但是如果返回新创建对象就是深拷贝。

	
#### MVC和MVVM

* MVC弊端：Controller通常负责Model和View关联，造成View和Model的耦合度太高，而且Controller变得庞大复杂。

* MVVM优点

	1. 低耦合，view可以独立于Model变化和修改，一个ViewModel可以绑定到不同的view上。当view变化的时候Model可以不变，当Model变化的时候view可以不变。
	2. 可重用性，可以把一些视图的逻辑放在viewModel里面，让很多view重用这段视图逻辑。
	3. 独立开发，开发人员可以专注与业务逻辑和数据的开发（viewModel）。设计人员可以专注于界面（view）的设计。
	4. 可测试性，可以针对viewModel来对界面（view）进行测试。

#### 类目（category）和拓展（extension）

* 类目（category）

	1. 类目中拓展的方法会被子类继承
	2. 增加原有类的方法，而且是可以增加多个类目将大的功能划分为小功能。
	3. 类目中的方法会比原来类中的方法具有更高优先级。所以不能和原有类的方法重名，否则会被覆盖。
	4. 类目只能添加方法，不能添加变量。

* 拓展（extension）

	1. 对类的一些属性的声明，一般都是在类的实现文件中实现。
	2. 给当前类添加私有方法私有类。
	3. 添加的方法必须要实现。


#### #include，#import和@class

1. "#include" 

	c/c++语言中的包含头文件，include相当于拷贝文件中的声明内容，多次使用就会报重复定义的错误。
	
2. "#import"

	导入头文件，不会产生重复定义的错误，因为它会做判断，如果已经导入，就不会重复导入。
	
3. @class

	* @class仅仅是类的声明，告诉编译器有这么个类，具体这个类怎么定义不知道。
	* @calss可以解决循环依赖问题，编译时两个头文件互相包含会报错，这是就可以使用@class。
	* 能够更快的解决编译问题。

	
<span>注：</span>#import<>和#import""的区别，前者包含ios框架库里的类，后者包含项目自定义的类。

#### tcp和udp

* TCP: 面向连接、传输可靠（保证数据正确性，保证数据顺序传输）、用于传输大量数据（数据流模式）。速度慢，建立连接需要的开销大。

* UDP: 面向非连接、传输不可靠、用于传输少量数据（数据包模式）、速度快、传输的是报文。

#### 区分HTTP与Socket

* HTTP请求：客户端主动发起请求，服务器才能给予响应，请求完成后断开连接，节省资源。

* Socket：客户端与服务器端直接使用socket套接字连接，双方都保持连接通道，都可主动发送数据，像游戏、股票等时时性强的就使用这个。主要使用CFSocketRef。GCDAsyncSocket。

#### 通知和代理