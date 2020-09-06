## ios消息转发机制

参考：[消息转发机制]("https://blog.csdn.net/wtdask/article/details/80613446")、[iOS中类找不到方法时消息处理机制](https://www.jianshu.com/p/6e6a01d96d72)

若想令类能理解某条消息，我们必须实现对应的方法才行，但是在编译期向类发送了其无法理解的消息并不会报错，因为在运行期可以继续向类中添加方法，所以编译器在编译时还不确定类中到底会不会有某个方法的实现。当对象接收到无法解读的消息后，就会启动“消息转发”机制，程序可由此过程告诉对象应该如何处理未知消息。

消息转发分为两大阶段，第一阶段先征询接收者所属的类，看其是否能动态添加方法，以处理当前这个“未知的选择子”，这叫做“动态方法解析”。如果运行期系统已经把第一阶段执行完了，那么接收者自己就无法再以动态新增方法的手段来响应包含该选择子的消息了。此时运行期系统会请求接收者以其他手段来处理与消息相关的方法调用。这又细分为两小步。首先请接收者看看有没有其他对象可以处理这条消息，若有，则运行期会把消息转给那个对象，于是消息转发过程结束，一切如常。若没有“备援的接收者”，则启动完整的消息转发机制，运行期会把与消息有关的全部细节都封装到NSInvocation对象中，再给接收者最后一次机会，令其设法解决当前还未处理的这条消息。

1. 动态方法解析：对象在收到无法处理的消息时，会调用如下方法。

	```
	// 未实现类方法调用（类）
	+ (BOOL)resolveClassMethod:(SEL)sel;
	// 未实现实例方法调用（对象）
	+ (BOOL)resolveInstanceMethod:(SEL)sel;
	```
	
	在该类方法中，需要给对象所属的类或类添加一个方法，并返回YES，表明可以处理。
	
	```
	+ (BOOL)resolveInstanceMethod:(SEL)sel {
		NSString *methodName = NSStringFromSelector(self);
		if ([@"testResolve" isEqulToString: methodName]) {
			SEL aSel = NSSelectorFromString(@"xxx");
			Method aMethod = class_getInstanceMethod(self, aSel);
			class_addMethod(self, sel, method_getImplementation(aMethod), "v@:");
			return YES;
		}
		
		return NO;
	}
	```
	
	使用这种方法前提是：相关方法代码已经实现，只是在运行时将方法动态的添加到目标类中。如coredata中使用的@dynamic属性。
	
2. 备援接收者

	经历步骤1后，如果该消息还是无法处理，那就就会调用下面方法，查询是否有其他的对象能够处理该消息。
	
	```
	- (id)forwardingTargetForSelector:(SEL)aSelector;
	```
	
	在这个方法里，我们需要返回一个能够处理该消息的对象。
	
	```
	- (id)forwardingTargetForSelector:(SEL)aSelector {
		NSString *selName = NSStringFromSelector(aSelector);
		if ([@"testForwarding" isEqualToString:selName]) {
			OtherObj *ob = [OtherObj new];
			return ob;
		}
		
		return [super forwardingTargetForSelector:aSelector];
	}
	```
	
3. 完整的消息转发

	经历1，2两步，还是无法处理消息，那么就会做最后的尝试，先调用methodSignatureForSelector:获取方法签名，然后再调用forwardInvocation:进行处理。如果methodSignatureForSelector返回nil未实现forwardInvocation最终会调用doesNotRecognizeSelector。如果methodSignatureForSelector返回nil实现forwardInvocation最终会crash。
	
	```
	- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
		NSString *method = NSStringFromSelector(aSelector);
		if ([@"testForward" isEqualToString:selName]) {
			NSMethodSignature *sign = [ObjClass instanceMethodSignatureForSelector:aSelector];
			return sign;
		}
		
		return nil;
	}
	
	- (void)forwardInvaction:(NSInvocation *)anInvocation {
		TestObj *tObj = [TestObj new];
		if ([tObj respondsToSelecotor:[anInvocation selector]]) {
			[anInvocation invokeWithTarget:tObj];
			return;
		}
		
		return [super forwardingInvocation: anInvocation];
	}
	```