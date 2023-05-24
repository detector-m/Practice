//
//  DMRNSOperationTester.m
//  DMRThread
//
//  Created by Riven on 2023/5/24.
//

#import "DMRNSOperationTester.h"
#import "DMRCustomOperation.h"

@interface DMRNSOperationTester ()

@end

@implementation DMRNSOperationTester
//@synthesize lock = _lock;
{
    NSLock *lock;
    NSInteger ticketCount;
}

- (void)testInvocationOperation {
    // 创建 invocationOpeartion
    NSLog(@"%s, thread = %@", __func__, [NSThread currentThread]);
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask:) object:@"123"];
    
    op.name = @"abc";
    
    [op start];
}

- (void)invocationOperationTask: (NSString *)object {
    NSLog(@"%s, %@, thread = %@", __func__, object, [NSThread currentThread]);
}

- (void)testBlockOperation {
    NSLog(@"%s, thread = %@", __func__, [NSThread currentThread]);

    NSBlockOperation *op = [[NSBlockOperation alloc] init];
    [op addExecutionBlock:^{
        NSLog(@"%s, thread = %@, 1", __func__, [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"%s, thread = %@, 2", __func__, [NSThread currentThread]);
    }];
    
    [op start];
}

- (void)testCustomOperation {
    NSLog(@"%s, thread = %@", __func__, [NSThread currentThread]);

    DMRCustomOperation *op = [[DMRCustomOperation alloc] init];
    op.name = @"custom";
    [op start];
}

- (void)testOperationQueueAddOperation {
    NSLog(@"\n\n-----\n\n");
    NSLog(@"%s, thread = %@", __func__, [NSThread currentThread]);
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationInQueueTask:) object:@"中华人民"];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Opeartion --- 2 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Opeartion --- 3 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
//    [NSThread sleepForTimeInterval:3];
    
    // 阻塞当前线程，直到该操作结束。可用于线程执行顺序的同步。
    [op3 waitUntilFinished];
}

- (void)invocationOperationInQueueTask: (NSString *)object {
    for (int i=0; i < 4; i++) {
        NSLog(@"Queue Opeartion --- 1 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.2];
    }
}

- (void)testOperationQueueAddBlock {
    NSLog(@"\n\n-----\n\n");
    NSLog(@"%s, thread = %@", __func__, [NSThread currentThread]);
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [queue addOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Block --- 1 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Block --- 2 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Block --- 3 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    
//    [NSThread sleepForTimeInterval:3];
    // 阻塞当前线程，直到队列中的操作全部执行完毕。
    [queue waitUntilAllOperationsAreFinished];
}

- (void)testOperationQueueMaxConcurrent: (NSInteger)maxConcurrent {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = maxConcurrent;
    
    NSLog(@"\n\n-----\n\n");
    NSLog(@"%s, thread = %@, maxConcurrentOperationCount = %ld", __func__, [NSThread currentThread], maxConcurrent);

    [queue addOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Block --- 1 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Block --- 2 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Block --- 3 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    
//    [NSThread sleepForTimeInterval:3];
    // 阻塞当前线程，直到队列中的操作全部执行完毕。
    [queue waitUntilAllOperationsAreFinished];
}

// 添加依赖
- (void)testOperationDependency {
    NSLog(@"\n\n-----\n\n");
    NSLog(@"%s, thread = %@", __func__, [NSThread currentThread]);
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Opeartion --- 1 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i < 4; i++) {
            NSLog(@"Queue Opeartion --- 2 count = %d %s, thread = %@", i, __func__, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"回到主线程");
        }];
    }];
    
    // 添加依赖 op2 依赖于 op1，op1 先执行，op2 后执行
    [op2 addDependency:op1];
    
    [queue addOperation:op2];
    [queue addOperation:op1];
    
//    [NSThread sleepForTimeInterval:3];
    
    // 阻塞当前线程，直到队列中的操作全部执行完毕。
    [queue waitUntilAllOperationsAreFinished];
}

// 线程安全
- (void)testThreadSafe {
    NSLog(@"\n\n-----\n\n");
    NSLog(@"%s, thread = %@", __func__, [NSThread currentThread]);
    
    self->lock = [NSLock new];
    self->ticketCount = 50;
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(threadSafeTask:) object:@"1234567890"];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(threadSafeTask:) object:@"0987654321"];

    [queue addOperation:op2];
    [queue addOperation:op1];
    
    // 阻塞当前线程，直到队列中的操作全部执行完毕。
    [queue waitUntilAllOperationsAreFinished];
}

- (void)threadSafeTask: (NSString *)object {
    while (true) {
        [self->lock lock];
        if (self->ticketCount > 0) {
            self->ticketCount--;
            NSLog(@"threadSafeTask ticketCount = %ld, thread = %@", (long)ticketCount, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
            [lock unlock];
        } else {
            [lock unlock];
            NSLog(@"ticketCount 为零，结束了");
            return;
        }
    }
}


@end
