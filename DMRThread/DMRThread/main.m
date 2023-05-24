//
//  main.m
//  DMRThread
//
//  Created by Riven on 2023/5/23.
//

#import <Foundation/Foundation.h>

#import "DMRNSThreadTester.h"
#import "DMRNSOperationTester.h"

// MARK: - NSThread
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

// MARK: - NSOperation
void testInvocationOperation(void) {
    DMRNSOperationTester *t = [DMRNSOperationTester new];
    [t testInvocationOperation];
}

void testBlockOperation(void) {
    DMRNSOperationTester *t = [DMRNSOperationTester new];
    [t testBlockOperation];
}

void testCustomOeration(void) {
    DMRNSOperationTester *t = [DMRNSOperationTester new];
    [t testCustomOperation];
}

void testOperationQueueAddOperation(void) {
    DMRNSOperationTester *t = [DMRNSOperationTester new];
    [t testOperationQueueAddOperation];
}

void testOperationQueueAddBlock(void) {
    DMRNSOperationTester *t = [DMRNSOperationTester new];
    [t testOperationQueueAddBlock];
}

void testOperationQueueMaxConcurrent(NSInteger max) {
    DMRNSOperationTester *t = [DMRNSOperationTester new];
    [t testOperationQueueMaxConcurrent:max];
}

void testOperationDependency(void) {
    DMRNSOperationTester *t = [DMRNSOperationTester new];
    [t testOperationDependency];
}

void testThreadSafe(void) {
    DMRNSOperationTester *t = [DMRNSOperationTester new];
    [t testThreadSafe];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
//        testNSThread1();
//        testNSThread2();
//        testNSThread3();
//        testNSThreadThreadSafe();
        
        testInvocationOperation();
        testBlockOperation();
        testCustomOeration();
        
        testOperationQueueAddOperation();
        
        testOperationQueueAddBlock();
        
        testOperationQueueMaxConcurrent(1);
        testOperationQueueMaxConcurrent(2);
        testOperationQueueMaxConcurrent(4);
        
        testOperationDependency();
        
        testThreadSafe();
    }
    
    return 0;
}
