//
//  DMRForwardMsgTester.h
//  DMRRuntime
//
//  Created by Riven on 2023/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMRForwardMsgTester : NSObject

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

+ (void)rtForwardMsgTest;

@end

NS_ASSUME_NONNULL_END
