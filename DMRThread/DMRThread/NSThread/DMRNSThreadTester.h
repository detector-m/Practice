//
//  DMRNSThreadTester.h
//  DMRThread
//
//  Created by Riven on 2023/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMRNSThreadTester : NSObject

// 先创建线程再启动线程
+ (void)test1;

// 创建线程后自动启动线程
+ (void)test2;

// 隐式创建并启动线程
+ (void)test3;

// 线程安全/同步
+ (void)testThreadSafe;

@end

NS_ASSUME_NONNULL_END
