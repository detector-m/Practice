//
//  DMRInitializeMethodTest.m
//  DMRPractice
//
//  Created by Riven on 2020/9/4.
//  Copyright © 2020 Riven. All rights reserved.
//

#import "DMRInitializeMethodTest.h"

@implementation DMRAnimal

+ (void)initialize {
    NSLog(@"%s", __func__);
}

@end

@implementation DMRAnimal (Test3)

+ (void)initialize {
    NSLog(@"%s", __func__);
}

@end

@implementation DMRAnimal (Test2)

+ (void)initialize {
    NSLog(@"%s", __func__);
}

@end

@implementation DMRCat

+ (void)initialize {
    NSLog(@"%s", __func__);
}

@end

@implementation DMRCat (Test1)

+ (void)initialize {
    NSLog(@"%s", __func__);
}

@end

@implementation DMRDog

//+ (void)initialize {
//    NSLog(@"%s", __func__);
//}

@end
