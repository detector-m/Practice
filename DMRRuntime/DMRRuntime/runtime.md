[原文： iOS基础知识 （一）](https://www.jianshu.com/p/d4721aef6517)
[参考：iOS 基础 ——Runtime原理](https://zhuanlan.zhihu.com/p/513790671)

## 一、Runtime 原理

Runtime 是 OC 核心运行机制之一，OC 加载库、加载类、执行和调用方法，都是通过 runtime 来实现。

#### 1、Runtime 消息发送机制

* 1、oc 调用一个方法时，实际上是调用 objc_msgSend(receiver, selector, arg1, arg2, ...) 来实现的。该函数第一个参数是消息的接收者， 第二个参数是方法名，剩下的就是方法的实际参数；
* 2、oc 调用方法时，会先去该类的方法缓存列表里面查找，如果找到就直接调用该方法，否则进行下一步（3）；
* 3、去该类的方法列表里面找，找到直接调用并把该方法及乳缓存列表；否则进行下一步 （4）；
* 4、沿着该类的继承链继续查找，找到直接调用，并把方法加入到缓存列表；否则进入消息转发机制；

#### 2、Runtime 消息转发机制

如果在消息发送阶段无法找到方法，oc 会走消息转发流程，流程图如下所示: 
![消息转发流机制图](%E6%B6%88%E6%81%AF%E8%BD%AC%E5%8F%91%E6%B5%81%E6%9C%BA%E5%88%B6%E5%9B%BE.webp)

* 1、动态消息解析，检查是否该类是否重写了 resolveInstanceMethod/resolveClassMethod 方法，如果返回 YES 则可以在 resolveInstanceMethod/resolveClassMethod 中通过 class_addMethod 函数动态添加方法来处理消息。经过这些处理后，如果还是无法处理消息则进入下一步（2）；
* 2、指定目标转发消息。forwardingTargetForSelector 将消息发送给指定对象。如果该方法返回 nil , 则进行下面的完整消息转发 (3)
* 3、完整消息转发，这步会调用 methodSignatureForSelector 进行方法签名，该方法可以将函数的参数类型和返回值类型封装。如果返回 nil ，则执行下面的第5步（5）。如果返回正确的方法签名（methodSignature），则进行下一步（4）；
* 4、进入消息处理，forwardInvocation, 在这里可以修改实现方法，修改响应对象等。如果消息响应成功则结束，否则进入下一步（5）；如果未实现该方法且未实现 doesNotRecognizeSelector方法 进入下一步 （5）。
* 5 报错 unrecognized selector sent to instance。


## 二、load 与 initialize

#### 相同点
* 1、load 与 initialize 会被自动调用，而不需要手动调用；
* 2、子类实现 load/initialize 的话，也会默认调用父类的；
* 3、属于线程安全，内部调用这个两个方法时使用了锁机制。

#### 不同点

##### 调用时机

* load: load 方法，在类或类目所在文件被引用（即运行时加载该类或类目）时被调用，在 main 函数之前。
* initialize: initialize 方法，只有在第一次向类/子类发送消息（第一次调用）时才会调用，而且只会调用一次，在 main 函数之后。

##### 调用规则

###### load

* 1、主类、父类、类目只要被引用，各自的 load 方法都会被调用。
* 2、load 方法步遵循继承规则，如果子类本身未实现 load 方法，加载子类时不会调用父类的 load 方法。
* 3、load 方法执行的优先级是，父类 > 子类 > 父类/子类类目（按编译规则顺序调用）。

###### initialize

* 1、遵循继承规则， 但都只执行一次，子类未实现，则调用父类的。
* 2、类目的 initialize 会覆盖主类的 initialize 方法。存在分类的情况下，调用最后编译的分类类目的 initialize 方法，且都是先调用父类，再到子类。

#### 使用场景

* load：load 方法实现 method swizzing 功能。
* initialize: 一般用与初始化全局变量或者静态变量。

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

## 三、方法交换（MethodSwizzling）

方法交换：在运行时将一个方法的实现替换成另一个方法的实现。每个方法都是由方法选择子（SEL）和方法实现（IMP）组合而成。方法交换就是将 SEL 与原来 IMP 断开，进而将 SEL 与 新的 IMP 组合成新的方法。

AOP：面向切面编程就是使用了该方式。AOP 是面向切面提取、封装，提取各个模块中的公用部分，提高模块的复用率，降低业务之间的耦合。
