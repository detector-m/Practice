//
//  DMRForwardMsgTester.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/22.
//

#import "DMRForwardMsgTester.h"
#import "DMRPerson.h"
#import "DMRWorker.h"

@implementation DMRForwardMsgTester

+ (void)rtForwardMsgTest {
    // 动态加载方法
    testAddMethod1();
    testAddMethod2();
    testAddMethod3();
    testAddMethod4();
    
    testAddInstanceMethod1();
    testAddInstanceMethod2();
    testAddInstanceMethod3();
    
    testForwardMsg1();
    testForwardMsg2();
    testForwardMsg3();
}

void testAddMethod1() {
    [DMRPerson performSelector:@selector(jump)];
}
void testAddMethod2() {
    [DMRPerson performSelector:@selector(walk1:) withObject:@1000];
}
void testAddMethod3() {
    [DMRPerson performSelector:@selector(walk2)];
}

void testAddMethod4() {
    [DMRPerson performSelector:@selector(walk3:) withObject:@1900];
}

void testAddInstanceMethod1() {
    DMRPerson *t = [DMRPerson new];
    [t performSelector: @selector(play)];
}

void testAddInstanceMethod2() {
    DMRPerson *t = [DMRPerson new];
    [t performSelector: @selector(play2)];
}

void testAddInstanceMethod3() {
    DMRPerson *t = [DMRPerson new];
    [t performSelector: @selector(play3:) withObject: @"abcd2jfidjfie"];
}

// 消息转发
void testForwardMsg1() {
    DMRPerson *t = [DMRPerson new];
    [t performSelector: @selector(work)];
}

void testForwardMsg2() {
    DMRPerson *t = [DMRPerson new];
    [t playTest];
}

void testForwardMsg3() {
    DMRWorker *t = [DMRWorker new];
    [t performSelector:@selector(jumpTo)];
}

@end
