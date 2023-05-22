//
//  DMRWorker.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/22.
//

#import "DMRWorker.h"
#import <objc/runtime.h>


@implementation DMRWorker

- (void)work {
    NSLog(@"%s", __func__);
}

- (void)playTest {
    NSLog(@"%s", __func__);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%s, %@", __func__, NSStringFromSelector(aSelector));
    
    return [super forwardingTargetForSelector: aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(jumpTo)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    if (aSelector == @selector(playTest)) {
        Method tM = class_getInstanceMethod([self class], aSelector);
        char *typeName = method_getTypeEncoding(tM);
        
        return [NSMethodSignature signatureWithObjCTypes:typeName];
    }
    
    return [super methodSignatureForSelector: aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation setSelector: @selector(testSel)];
    [anInvocation invokeWithTarget:self];
}

- (void)testSel {
    NSLog(@"%s", __func__);
}

@end
