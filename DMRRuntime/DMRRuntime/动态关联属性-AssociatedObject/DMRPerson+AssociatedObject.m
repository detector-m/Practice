//
//  DMRPerson+AssociatedObject.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/22.
//

#import "DMRPerson+AssociatedObject.h"
#import <objc/runtime.h>

@implementation DMRPerson (AssociatedObject)
@dynamic name;

static char kPropertyConstraintsKey;

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &kPropertyConstraintsKey, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)name {
    return objc_getAssociatedObject(self, &kPropertyConstraintsKey);
}

@end
