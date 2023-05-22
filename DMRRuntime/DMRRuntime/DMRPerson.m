//
//  DMRPerson.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/20.
//

#import "DMRPerson.h"
#import <objc/runtime.h>
#import "DMRWorker.h"


@implementation DMRPerson

- (void)eat {
    NSLog(@"吃东西");
}

- (void)run:(NSUInteger)distance {
    NSLog(@"跑了 %ld 米", distance);
}

// MARK: - ForwardMsg
//  在没有找到方法时，会先调用此方法，可用于动态添加方法
//  返回 YES 表示相应 selector 的实现已经被找到并添加到了类中，否则返回 NO
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"jump")) {
        // 动态添加 jump 方法
        class_addMethod(object_getClass(self), @selector(jump), (IMP)jump, "v@:");
        
        return YES;
    } else if (sel == NSSelectorFromString(@"walk1:")) {
        class_addMethod(object_getClass(self), @selector(walk1:), (IMP)walk1, @"v@:@");
        return true;
    } else if (sel == NSSelectorFromString(@"walk2")) {
        class_addMethod(object_getClass(self), @selector(walk2), class_getMethodImplementation(object_getClass(self), @selector(walk1_2)), ""/*"v@:"*/);
        
        return true;
    } else if (sel == NSSelectorFromString(@"walk3:")) {
        class_addMethod(object_getClass(self), @selector(walk3:), class_getMethodImplementation(object_getClass(self), @selector(walk1_3:)), "");
        
        return true;
    }
    
    return [super resolveClassMethod: sel];
}

void jump(id self, SEL _cmd) {
    NSLog(@"%s, 12", __func__);
}

void walk1(id target, SEL sel, NSNumber *distance) {
    NSLog(@"%s, distance = %@", __func__, distance);
}

+ (void)walk1_2 {
    NSLog(@"%s, distance = 1200", __func__);
}

+ (void)walk1_3:(NSNumber *)distance {
    NSLog(@"%s, distance = %@", __func__, distance);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"play")) {
        class_addMethod(self, @selector(play), (IMP)play, "v@:");
        
        return YES;
    }
    else if (sel == NSSelectorFromString(@"play2")) {
//        class_addMethod(object_getClass(self), @selector(walk2), class_getMethodImplementation(object_getClass(self), @selector(walk2)), ""/*"v@:"*/);

        class_addMethod(self, sel, class_getMethodImplementation(self, @selector(play_2)), "v@:");
        
        return true;
    } else if (sel == NSSelectorFromString(@"play3:")) {
        class_addMethod(self, sel, class_getMethodImplementation(self, @selector(play_3:)), "");

        return true;
    } else if (sel == @selector(work)) {
        return true;
    }
 
    return [super resolveClassMethod: sel];
}

void play(id target, SEL sel) {
    NSLog(@"%s", __func__);
}

- (void)play_2 {
    NSLog(@"%s, 1223", __func__);
}

- (void)play_3:(NSString *)something {
    NSLog(@"%s, something = %@", __func__, something);
}

//  如果第一步的返回 NO 或者直接返回了 YES 而没有添加方法，该方法被调用
//  在这个方法中，我们可以指定一个可以返回一个可以响应该方法的对象
//  如果返回 self 就会死循环
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%s, %@", __func__, NSStringFromSelector(aSelector));

    if (aSelector == @selector(work)) {
        return [DMRWorker new];
    }
    
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(playTest)) {
        DMRWorker *tObject = [DMRWorker new];

        NSMethodSignature *tSign = [tObject methodSignatureForSelector: aSelector];

        return tSign;
    }
    
    return [super methodSignatureForSelector: aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s, %@", __func__, anInvocation);
    DMRWorker *tObject = [DMRWorker new];
    [anInvocation invokeWithTarget:tObject];
}

//- (void)doesNotRecognizeSelector:(SEL)aSelector {
//    NSLog(@"无法处理消息：%@", NSStringFromSelector(aSelector));
//}

@end
