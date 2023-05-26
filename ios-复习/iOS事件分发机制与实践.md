[参考-iOS事件分发机制与实践](https://juejin.cn/post/6844903556017995784)

## 事件分发机制

iOS 检测到手指触摸（UITouch）操作时会将其打包成一个 UIEvent 对象，并放入到当前活动的 Application 的事件队列，UIApplication 会从事件队列中取出触摸事件并传递给 UIWindow 来处理，UIWindow 对象首先会使用 hitTest:withEvent: 方法寻找此次 UITouch 操作的的初始点所在的视图（UIView），那么就需要将触摸事件传递给它视图，这个过程称之为 hit-test view。

hitTest:withEvent: 处理流程如下：

* 1、判断是否可以接受事件；
* 2、调用当前视图的 pointInside:withEvent: 方法判断触摸点是否在当前视图内；
* 3、向所有子视图（subviews）发送 hitTest:withEvent: 消息，递归调用，直到返回处理对象/nil。
* 4、如果所有子视图都返回为空那么返回自己。

```
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //首先判断是否可以接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    //然后判断点是否在当前视图上
    if ([self pointInside:point withEvent:event] == NO) return nil;
    //循环遍历所有子视图，查找是否有最合适的视图
    for (NSInteger i = self.subviews.count - 1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        //转换点到子视图坐标系上
        CGPoint childPoint = [self convertPoint:point toView:childView];
        //递归查找是否存在最合适的view
        UIView *fitView = [childView hitTest:childPoint withEvent:event];
        //如果返回非空，说明子视图中找到了最合适的view，那么返回它
        if (fitView) {
            return fitView;
        }
    }
    //循环结束，仍旧没有合适的子视图可以处理事件，那么就认为自己是最合适的view
    return self;
}
```

## 事件响应链

iOS 的事件分发机制是为了找到第一响应者，事件的处理机制叫做响应链原理。
所有事件响应的类都是 UIResponder 的子类。
