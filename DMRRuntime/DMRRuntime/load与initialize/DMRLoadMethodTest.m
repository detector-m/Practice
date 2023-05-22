//
//  DMRLoadMethodTest.m
//  DMRPractice
//
//  Created by Riven on 2020/9/4.
//  Copyright © 2020 Riven. All rights reserved.
//

#import "DMRLoadMethodTest.h"

@implementation Person

+ (void)load {
    NSLog(@"%s", __func__);
}

@end

@implementation Person (Test1)

+ (void)load {
    NSLog(@"%s", __func__);
}

@end

@implementation Student

+ (void)load {
    NSLog(@"%s", __func__);
}

@end

@implementation Student (Test1)

+ (void)load {
    NSLog(@"%s", __func__);
}

@end

@implementation Student (Test2)

+ (void)load {
    NSLog(@"%s", __func__);
}

@end

@implementation Student (Test3)

+ (void)load {
    NSLog(@"%s", __func__);
}

@end

@implementation Person (Test3)

+ (void)load {
    NSLog(@"%s", __func__);
}

@end

@implementation Person1

+ (void)load {
    NSLog(@"%s", __func__);
}

@end

@implementation Teacher

@end

