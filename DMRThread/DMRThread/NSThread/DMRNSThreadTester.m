//
//  DMRNSThreadTester.m
//  DMRThread
//
//  Created by Riven on 2023/5/23.
//

#import "DMRNSThreadTester.h"

@interface DMRNSThreadTester()
@property (class, nonatomic, assign) NSInteger threadSafeCount;
@end

@implementation DMRNSThreadTester

static NSInteger _threadSafeCount;
+ (NSInteger)threadSafeCount {
    return _threadSafeCount;
}
+ (void)setThreadSafeCount:(NSInteger)threadSafeCount {
    _threadSafeCount = threadSafeCount;
}

static NSThread *thread1;
static NSThread *thread2;

// 先创建线程再启动线程
+ (void)test1 {
    NSThread *th = [[NSThread alloc] initWithTarget:self selector:@selector(run) object: nil];
    [th setName:@"abc"];
    [th start];
    
    [NSThread sleepForTimeInterval:1];
}

// 创建线程后自动启动线程
+ (void)test2 {
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    
    [NSThread sleepForTimeInterval:1];
}

// 隐式创建并启动线程
+ (void)test3 {
    [self performSelectorInBackground:@selector(run) withObject:nil];
    [NSThread sleepForTimeInterval:1];
}

+ (void)run {
    NSLog(@"%@", [NSThread currentThread]);
}

+ (void)testThreadSafe {
    self.threadSafeCount = 50;
    thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(threadSafeRun) object:nil];
    [thread1 setName:@"thread1"];
    
    thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(threadSafeRun) object:nil];
    [thread2 setName:@"thread2"];
    
    [thread1 start];
    [thread2 start];
    
    [NSThread sleepForTimeInterval:15];
}

+ (void)threadSafeRun {
    while (true) {
        @synchronized (self) {
            if (self.threadSafeCount > 0) {
                self.threadSafeCount--;
                NSLog(@"%@, threadSafeCount = %ld", [NSThread currentThread], self.threadSafeCount);
                [NSThread sleepForTimeInterval:0.2];
            } else {
                NSLog(@"已结束");
                break;
            }
        }
    }
}

@end
