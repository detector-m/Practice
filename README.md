# Practice

## DMRObserver

### NSNotificationCenter
NSNotificationCenter: 通过addObserver注册对某一类型通知感兴趣，不会对观察者进行引用计数+1操作，一定要同removeObserver进行移除。通过postNotificationName来发送通知，广播方式。

### KVO
KVO 的全称是 Key-Value Observer，即键值观察。是一种没有中心枢纽的观察者模式的实现方式。一个主题对象管理所有依赖于它的观察者对象，并且在自身状态发生改变的时候主动通知观察者对象。

注册观察者 [object addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:]。
更改主题对象属性的值，即触发发送更改的通知。
在制定的回调函数中，处理收到的更改通知。
注销观察者 [object removeObserver:self forKeyPath:property]。