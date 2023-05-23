//
//  DMRPlant+MethodSwizzling.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/23.
//

#import "DMRPlant+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation DMRPlant (MethodSwizzling)

+ (void)load {
    // 获取两个方法
    Method om = class_getInstanceMethod(self, @selector(grow));
    if (om == nil) {
        return;
    }
    
    Method nm = class_getInstanceMethod(self, @selector(ms_grow));
    if (nm == nil) {
        return;
    }
    
    // 交换方法
    method_exchangeImplementations(om, nm);    
}

- (void)ms_grow {
    [self ms_grow];
    
    NSLog(@"%s, 生长 拓展", __func__);
}

@end
