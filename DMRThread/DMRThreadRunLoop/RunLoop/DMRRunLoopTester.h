//
//  DMRRunLoopTester.h
//  DMRThread
//
//  Created by Riven on 2023/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMRRunLoopTester : NSObject

@property (nonatomic, strong) NSThread *keepAliveThread;

// MARK: - 测试 NSTimer 的在运行模式下的使用
- (void)testTimerInDefaultMode;
- (void)testTimerInTrackingMode;
- (void)testTimerInCommonMode;

- (void)testTimerScheduled;
- (void)testTimerFire;

// MARK: - 观察者
- (void)testObserver;

// MARK: - 推迟显示
- (void)testDelayDisplay;

// 后台常驻线程
- (void)testKeepAliveThread;

@end

NS_ASSUME_NONNULL_END
