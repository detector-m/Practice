//
//  DMRPlant+AssociatedObject.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/22.
//

#import "DMRPlant+AssociatedObject.h"
#import <objc/runtime.h>

@implementation DMRPlant (AssociatedObject)

@dynamic associatedName;
@dynamic associatedHigh;
@dynamic associatedCode;

void associatedObjcetSetter(id self, SEL _cmd, id value) {
    objc_setAssociatedObject(self, &_cmd, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

id associatedObjectGetter(id self, SEL _cmd) {
    return objc_getAssociatedObject(self, &_cmd);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selName = NSStringFromSelector(sel);
    if ([selName hasPrefix: @"setAssociated"]) {
        class_addMethod(self, sel, (IMP)associatedObjcetSetter, "v@:@");
        return true;
    } else if ([selName hasPrefix: @"associated"]) {
        class_addMethod(self, sel, (IMP)associatedObjectGetter, "@@:");
        return true;
    }
    
    return [super resolveInstanceMethod: sel];
}

@end
