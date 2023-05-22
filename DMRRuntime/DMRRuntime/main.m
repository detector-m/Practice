//
//  main.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/20.
//

#import <Foundation/Foundation.h>
#import "DMRRTPrincipleTester.h"
#import "DMRForwardMsgTester.h"

#import "DMRLoadMethodTest.h"
#import "DMRInitializeMethodTest.h"

#import "DMRPerson.h"
#import "DMRWorker.h"

void testRTMsgSend(void);

#if false
// 动态加载方法
void testAddMethod1(void);
void testAddMethod2(void);
void testAddMethod3(void);
void testAddMethod4(void);

void testAddInstanceMethod1(void);
void testAddInstanceMethod2(void);
void testAddInstanceMethod3(void);


void testForwardMsg1(void);
void testForwardMsg2(void);
void testForwardMsg3(void);
#endif

void testLoadAndInitialize(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
//        testRTMsgSend();
        
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
        
//        testLoadAndInitialize();
    }
    return 0;
}

// 消息发送
void testRTMsgSend() {
    [DMRRTPrincipleTester rtMsgSendTest];
}

// MARK: - 消息转发
#if false
// 动态加载方法
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

#endif

void testLoadAndInitialize() {
    NSLog(@"--------------- InitializeMethodTest ---------------");
    [DMRAnimal new];
    [DMRCat new];
    [DMRDog new];
}
