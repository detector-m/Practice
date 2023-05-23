//
//  main.m
//  DMRThread
//
//  Created by Riven on 2023/5/23.
//

#import <Foundation/Foundation.h>

#import "DMRNSThreadTester.h"

void testNSThread1(void) {
    [DMRNSThreadTester test1];
}

void testNSThread2(void) {
    [DMRNSThreadTester test2];
}

void testNSThread3(void) {
    [DMRNSThreadTester test3];
}

void testNSThreadThreadSafe(void) {
    [DMRNSThreadTester testThreadSafe];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        testNSThread1();
        testNSThread2();
        testNSThread3();
        
        testNSThreadThreadSafe();
    }
    return 0;
}
