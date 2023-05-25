//
//  DMRRunLoopTester.m
//  DMRThread
//
//  Created by Riven on 2023/5/25.
//

#import "DMRRunLoopTester.h"
#import <CoreFoundation/CoreFoundation.h>

@interface DMRRunLoopTester()
@property (nonatomic, strong) NSTimer *scheduledTimer;
@end

@implementation DMRRunLoopTester

- (void)testTimerInDefaultMode {
    NSTimer *t = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(runInDefaultMode) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
}
- (void)runInDefaultMode {
    NSLog(@"1111111");
}

- (void)testTimerInTrackingMode {
//    NSTimer *t = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(runInUITrackingMode) userInfo:nil repeats:true];
//    [[NSRunLoop currentRunLoop] addTimer:t forMode:UITrackingRunLoopMode];
}
- (void)runInUITrackingMode {
    NSLog(@"222222222");
}

- (void)testTimerInCommonMode {
    NSTimer *t = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(runInCommonMode) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
}
- (void)runInCommonMode {
    NSLog(@"33333333");
}

- (void)testTimerScheduled {
    self.scheduledTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(runTimeScheduled) userInfo:nil repeats:true];
}

- (void)runTimeScheduled {
    NSLog(@"444444444444, RunLoopMode = %@", [[NSRunLoop currentRunLoop] currentMode]);
}

- (void)testTimerFire {
    self.scheduledTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(runTimeFire) userInfo:nil repeats:true];

    [self.scheduledTimer fire];
}

- (void)runTimeFire {
    NSLog(@"555555555555, RunLoopMode = %@", [[NSRunLoop currentRunLoop] currentMode]);
}

- (void)testObserver {
    //创建上下文,用于控制器数据的获取
//    CFRunLoopObserverContext obContext = {
//        0,
//        (__bridge void *)self,
//        &CFRetain,
//        &CFRelease,
//        NULL
//    };
    
    // 创建观察者
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopAllActivities, true, 0, runLoopObserverCallback, NULL);
//    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
//    CFRelease(observer);
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop发生改变---%zd", activity);
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSLog(@"监听到RunLoop发生改变---%zd", activity);
}

// MARK: - 推迟显示
- (void)testDelayDisplay {
//    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"tupian"] afterDelay:4.0 inModes:NSDefaultRunLoopMode];
}

- (void)testKeepAliveThread {
    _keepAliveThread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"Keep Alive Thread 开始");
        // 添加 RunLoop
        [[NSRunLoop currentRunLoop] addPort:[NSPort port]  forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"Keep Alive Thread 未开启 RunLoop");
    }];
    
    [_keepAliveThread start];
}

@end
