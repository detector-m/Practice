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
* 2、指定目标消息转发。forwardingTargetForSelector 将消息发送给指定对象。如果该方法返回 nil , 则进行下面的完整消息转发 (3)
* 3、完整消息转发，这步会调用 methodSignatureForSelector 进行方法签名，该方法可以将函数的参数类型和返回值类型封装。如果返回 nil ，则执行下面的第5步（5）。如果返回正确的方法签名（methodSignature），则进行下一步（4）；
* 4、进入消息处理，forwardInvocation, 在这里可以修改实现方法，修改响应对象等。如果消息响应成功则结束，否则进入下一步（5）；
* 5 报错 unrecognized selector sent to instance。
