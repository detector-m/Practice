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

* 同：都用于对象之间的通信。
* 异：代理适合一对一通信，通知是一对多。

#### method和selector

method包含了方法名和方法实现。selector只是方法选择子（一个方法名）。

#### isKindOfClass与isMemberOfClass

* isKindOfClass：确定一个对象是否是一个类的成员，或者是派生该类的成员（子类）
* isMemeberOfClass：确定一个对象是否是当前类

<span>注：</span>isMemeberOfClass只检查是否是当前类，isKindOfClass可向父类链进行检查。

#### 面向过程和面向对象

* 面向过程：以事件的过程为编程中心，各个功能是按照事件的先后顺序或因果关系进行的编程思想。
*  面向对象：以对象为编程中心，以事件驱动，各个功能之间是相互独立的、模块化的一种编程思想。

#### xcode中Project与Target

* Project： 是一个项目的整体，相当于一个仓库，包含了所有的代码和资源文件。
*  Target：相当于一个具体的产品，包含了对于代码、资源文件的具体的使用和配置。

<span>注意：</span>一个Project可以包含多个Target，也就是说不同的Target可以生成不同的app或库。

#### 类方法和实例方法

* 类方法：调用时直接使用类名，不依赖任何实例对象。适合不需要访问成员变量或者改变实例状态时使用。
* 实例方法：在一个类的具体实例范围内使用，使用前必须创建该对象。适合需要访问实例成员变量或者实例状态的时候使用。

##### 使用注意

1. 类方法可以调用类方法，但是不能调用实例的方法和实例变量。
2. 类方法不可以调用实例方法，除非在其中创建对象来调用。
3. 类方法和实例方法中都可以使用self，但是意义不同，类方法中的self是当前类，而实例方法中的self是该对象的首地址，也就是当前实例对象。


#### laod和initialize方法 (参考DMRPractice demo)

##### 相同点

1. load和initialize会被自动调用，而不能手动调用它们。
2. 子类实现load或者initialize方法的话，也会默认调用父类的。
3. load和initialize方法内部使用了锁机制，所以是线程安全。

##### 不同点 

* 调用时机
	
	* load：load方法，在类或者类目所在的文件被引用（即运行时加载该类或类目）时被调用，在main函数调用去。
	* initialize: initialize方法，只用在第一次向类发送消息（第一次调用）时才会调用，而且只会调用一次。在main函数之后。

* 调用规则：

	* load：

		1. 主类、父类、类目只要被引用了，各自的load方法都会被调用。
		2. load方法不遵循继承规则，如果子类本身没有实现load方法，不会调用父类的load方法。
		3. load方法执行的优先级是，父类>子类>父类子类类目（按编译顺序调用）。

	* initialize:
		1. 遵循继承规则，但都只执行一次，子类未实现，则调用父类的。
		2. 类目的initialize会覆盖主类的initialize方法。存在分类的情况下都调用各自分类最后编译的类目的initialize方法。且都是先调用父类，再到子类。
		
* 使用场景：
	
	* load：load方法在runtime实现Method Swizzing功能的使用。
	* initialize：一般用于初始化全局变量或者静态变量。

```
// load和initialize 测试示例
2020-09-05 00:01:56.614924+0800 DMRPractice[7482:187912] +[Person load]
2020-09-05 00:01:56.615327+0800 DMRPractice[7482:187912] +[Student load]
2020-09-05 00:01:56.615365+0800 DMRPractice[7482:187912] +[Person1 load]
2020-09-05 00:01:56.615389+0800 DMRPractice[7482:187912] +[Person(Test1) load]
2020-09-05 00:01:56.615413+0800 DMRPractice[7482:187912] +[Student(Test1) load]
2020-09-05 00:01:56.615450+0800 DMRPractice[7482:187912] +[Student(Test2) load]
2020-09-05 00:01:56.615492+0800 DMRPractice[7482:187912] +[Student(Test3) load]
2020-09-05 00:01:56.615535+0800 DMRPractice[7482:187912] +[Person(Test3) load]
2020-09-05 00:01:56.615631+0800 DMRPractice[7482:187912] main
2020-09-05 00:01:56.615661+0800 DMRPractice[7482:187912] Hello, World!
2020-09-05 00:01:56.615707+0800 DMRPractice[7482:187912] --------------- InitializeMethodTest ---------------
2020-09-05 00:01:56.615806+0800 DMRPractice[7482:187912] +[DMRAnimal(Test2) initialize]
2020-09-05 00:01:56.615873+0800 DMRPractice[7482:187912] +[DMRCat(Test1) initialize]
2020-09-05 00:01:56.615973+0800 DMRPractice[7482:187912] +[DMRAnimal(Test2) initialize]
Program ended with exit code: 0
```

#### 静态库与动态库

1. 开源库和闭源库

	* 开源库：代码公开，可以方便使用着学习和拓展。
	* 闭源库：代码不公开，库中代码被编译成二进制文件，使用时只能通过公开的头文件进行调用。由于是编译好的二进制文件，所以在整个程序编译的过程中不需要编译这些库，只需要进行链接（link）就好。由于链接的方式不同，又分为静态库和动态库（动态链接）。

<span>注：</span>程序的编译过程：代码编写->编译->链接（link）->生成可执行二进制文件。

2. 封装库的好处

	1. 重要的代码不需公开，又能提供对应的功能给使用者。只提供部分需要公开的头文件，以供使用者使用。
	2. 将不经常改动的功能模块代码编译成库，目标项目在编译时不需编译这些库，只需要进行连接即可，大大减少编译的时间，同时也便于代码的管理。

3. 静态库和动态库的区别

	* 静态库：以.a, .framework为后缀。静态库在连接的时候，会被完整的复制到可执行文件中，多次使用就有多次拷贝。
	* 动态库：以.dylib，.tbd, .framework为后缀。动态库在连接时不会复制，系统只加载一次动态库，当目标程序运行时加载对应的动态库到内存中。多个程序共用，节省内存。

4. 同为framework类型的库如何区分时动态还是静态

	* 静态库：包含头文件夹和资源文件夹Resources
	* 动态库：会将代码打包出黑色的可执行文件，还可能包含真机下的签名文件和bundle文件。

<span>注：</span>

```
1. cd到.framework目录之下
2.  file 库文件：file xxx
3. 查看上一步的输出信息，如果出现了cpu架构为dynamically标识符的为动态库，否则就是静态库。
```

-------------

#### 内存优化方案

1. 懒加载，延迟对象创建，按需创建。
2. 复用，单元格复用，避免过多的创建对象
3. 可变容器的使用要谨慎。
4. 及时删除缓存信息。

#### BAD_ACCESS的原因

访问了野指针，比如已经释放的对象的成员变量或者发送消息。

调试：Enaable zombie objects 、设置全局断点

#### 解决报错libc++abi.dylib handler threw exception

遇到这种错误，即使用了All Exceptions，也断点到相应的代码了，但是没打印对应的日志。此时我们可以添加如下的代码来打印异常log:

```
@try {
	// 抛异常代码
} @catch(NSException *exception) {
	NSLog(@"%@", exception);
} @finally {}
```

#### 关闭默认KVO

```
+ (BOOL)automaticallyNotifiesObserverForKey:(NSString *)key {
	if ([key isEqualToString:@"xxx"]) {
		return NO;
	}
	
	return [super automaticallyNotifiesObserverForKey: key];
}

// 但是手动关闭实现的时候，需要自己调用下面的两个方法，才会调用监听方法
- (void)willChangeValueForKey:(NSString *)key {
	[super willChangeValueForKey: key];
}

- (void)didChangeValueForKey:(NSString *)key {
	[super didChangeValueForKey: key];
}
```