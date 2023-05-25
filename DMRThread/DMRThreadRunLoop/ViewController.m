//
//  ViewController.m
//  DMRThreadRunLoop
//
//  Created by Riven on 2023/5/25.
//

#import "ViewController.h"
#import "DMRRunLoopTester.h"

@interface ViewController ()

@property (nonatomic, strong) UITextView *tView;
@property (nonatomic, strong) UIButton *testBtn;
@property (nonatomic, strong) DMRRunLoopTester *tester;

@end

@implementation ViewController
@synthesize tView, testBtn, tester;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tView = [UITextView new];
    CGRect tFrame = self.view.bounds;
    tFrame.size.height -= 200;
    tView.frame = tFrame;
    [self.view addSubview:tView];
    
    testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:testBtn];
    
    [testBtn setTitle:@"test" forState:UIControlStateNormal];
    [testBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    testBtn.frame = CGRectMake(10, CGRectGetMaxY(tFrame), self.view.bounds.size.width - 20, 30);
    [testBtn addTarget:self action:@selector(clickTestBtn) forControlEvents:UIControlEventTouchUpInside];
    
    tView.text = @"CFRunLoopTimerRef是定时源（RunLoop模型图中提到过），理解为基于时间的触发器，基本上就是NSTimer（哈哈，这个理解就简单了吧）。\n\n下面我们来演示下CFRunLoopModeRef和CFRunLoopTimerRef结合的使用用法，从而加深理解。\n\n首先我们新建一个iOS项目，在Main.storyboard中拖入一个Text View。在ViewController.m文件中加入以下代码，Demo中请调用[self ShowDemo1];来演示。- (void)viewDidLoad {[super viewDidLoad];// 定义一个定时器，约定两秒之后调用self的run方法 NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];// 将定时器添加到当前RunLoop的NSDefaultRunLoopMode下[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];}- (void)run{NSLog();}\n\n然后运行，这时候我们发现如果我们不对模拟器进行任何操作的话，定时器会稳定的每隔2秒调用run方法打印。\n\n但是当我们拖动Text View滚动时，我们发现：run方法不打印了，也就是说NSTimer不工作了。而当我们松开鼠标的时候，NSTimer就又开始正常工作了。\n\n这是因为：\n\n当我们不做任何操作的时候，RunLoop处于NSDefaultRunLoopMode下。而当我们拖动Text View的时候，RunLoop就结束NSDefaultRunLoopMode，切换到了UITrackingRunLoopMode模式下，这个模式下没有添加NSTimer，所以我们的NSTimer就不工作了。\n但当我们松开鼠标的时候，RunLoop就结束UITrackingRunLoopMode模式，又切换回NSDefaultRunLoopMode模式，所以NSTimer就又开始正常工作了。\n你可以试着将上述代码中的[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];语句换为[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];，也就是将定时器添加到当前RunLoop的UITrackingRunLoopMode下，你就会发现定时器只会在拖动Text View的模式下工作，而不做操作的时候定时器就不工作。\n\n那难道我们就不能在这两种模式下让NSTimer都能正常工作吗？\n\n当然可以，这就用到了我们之前说过的伪模式（kCFRunLoopCommonModes），这其实不是一种真实的模式，而是一种标记模式，意思就是可以在打上Common Modes标记的模式下运行。\n\n那么哪些模式被标记上了Common Modes呢？\n\nNSDefaultRunLoopMode 和 UITrackingRunLoopMode。 \n\n所以我们只要我们将NSTimer添加到当前RunLoop的kCFRunLoopCommonModes（Foundation框架下为NSRunLoopCommonModes）下，我们就可以让NSTimer在不做操作和拖动Text View两种情况下愉快的正常工作了。\n\n具体做法就是讲添加语句改为[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];\n\n既然讲到了NSTimer，这里顺便讲下NSTimer中的scheduledTimerWithTimeInterval方法和RunLoop的关系。添加下面的代码：";
    
    tester = [DMRRunLoopTester new];
    
//    [tester testTimerInDefaultMode];
//    [tester testTimerInCommonMode];
//
//    [tester testTimerScheduled];
    
//    [tester testObserver];
    [tester testKeepAliveThread];
}

- (void)clickTestBtn {
    [self performSelector:@selector(clickTestBtnCallback) onThread:tester.keepAliveThread withObject:nil waitUntilDone:false];
}

- (void)clickTestBtnCallback {
    NSLog(@"点击了 按钮");
}

@end
