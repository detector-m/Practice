//
//  ViewController.m
//  DMRObserver
//
//  Created by Riven on 2020/9/2.
//  Copyright © 2020 Riven. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *testLabel;

/** 触发通知的按钮 **/
@property (nonatomic, strong) UIButton *noticeButton;
/** 触发观察者的文本框 **/
@property (nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.testLabel];
    [self.view addSubview:self.noticeButton];
    [self.view addSubview:self.textView];
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"Notification" object:nil];
    
    // kvo
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"abc"];
    
}

#pragma mark - Actions
- (void)clickNoticeButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification" object:@"123"];
}

- (void)receiveNotification:(NSNotification *)noti {
    if ([noti.name isEqualToString:@"Notification"]) {
        NSString *text = [NSString stringWithFormat:@"获取到通知 - %@", noti.object];
        self.testLabel.text = text;
    }
}

// 键值观察
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UITextView *textV = (UITextView *)object;
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = textV.contentSize.height;
        if (height > 100) {
            height = 100;
        } else if (height < 40) {
            height = 40;
        }
        CGRect textViewFrame = self.textView.frame;
        textViewFrame.size.height = height;
        self.textView.frame = textViewFrame;
    }
}

#pragma mark - Getter
- (UILabel *)testLabel {
    if (!_testLabel) {
        _testLabel = [UILabel new];
        _testLabel.frame = CGRectMake(10, 88, 300, 30);
        _testLabel.textColor = UIColor.blueColor;
        _testLabel.text = @"默认";
    }
    
    return _testLabel;
}
- (UIButton *)noticeButton {
    if (!_noticeButton) {
        _noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noticeButton.frame = CGRectMake(10, 50, 130, 30);
        _noticeButton.center = self.view.center;
        [_noticeButton setTitle:@"触发通知" forState:UIControlStateNormal];
        _noticeButton.backgroundColor = [UIColor redColor];
        [_noticeButton addTarget:self action:@selector(clickNoticeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noticeButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, [UIScreen mainScreen].bounds.size.width - 20, 40)];
        _textView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _textView.font = [UIFont systemFontOfSize:16];
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 200, 21)];
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        placeHolderLabel.font = [UIFont systemFontOfSize:16];
        placeHolderLabel.text = @"输入文本触发观察者";
        [_textView addSubview:placeHolderLabel];
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _textView;
}

@end
