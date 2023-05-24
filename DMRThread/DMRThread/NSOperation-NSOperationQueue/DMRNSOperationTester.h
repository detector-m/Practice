//
//  DMRNSOperationTester.h
//  DMRThread
//
//  Created by Riven on 2023/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMRNSOperationTester : NSObject

- (void)testInvocationOperation;
- (void)testBlockOperation;
- (void)testCustomOperation;

- (void)testOperationQueueAddOperation;
- (void)testOperationQueueAddBlock;

// 控制队列并发执行 1 为串行
- (void)testOperationQueueMaxConcurrent: (NSInteger)maxConcurrent;

// 添加依赖
- (void)testOperationDependency;

// 线程安全
- (void)testThreadSafe;

@end

NS_ASSUME_NONNULL_END
