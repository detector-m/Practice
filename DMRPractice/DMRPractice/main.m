//
//  main.m
//  DMRPractice
//
//  Created by Riven on 2020/9/4.
//  Copyright © 2020 Riven. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DMRInitializeMethodTest.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"%s", __func__);
        NSLog(@"Hello, World!");
        
        NSLog(@"--------------- InitializeMethodTest ---------------");
        [DMRAnimal new];
        [DMRCat new];
        [DMRDog new];

    }
    return 0;
}
