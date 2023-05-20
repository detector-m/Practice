//
//  DMRRTPrincipleTester.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/20.
//

#import "DMRRTPrincipleTester.h"
#import <objc/message.h>
#import "DMRPerson.h"

@implementation DMRRTPrincipleTester

+ (void)rtMsgSendTest {
    // 使用 Runtime 创建一个对象
    // 根据类名获取到类
    Class personClass = objc_getClass("DMRPerson");
    // 同过类创建实例对象
    // 如果这里报错，请将 Build Setting -> Enable Strict Checking of objc_msgSend Calls 改为 NO
    DMRPerson *tPersion1 = objc_msgSend(personClass, @selector(alloc));
    
    // 通过 Runtime 初始化对象
    tPersion1 = objc_msgSend(tPersion1, @selector(init));
    
    // 通过 Runtime 调用对象方法
    // 调用的这个方法没有声明只有实现所以这里会有警告
    // 但是发送消息的时候会从方法列表里寻找方法
    // 所以这个能够成功执行
    objc_msgSend(tPersion1, @selector(eat));
    
    // 当然，objc_msgSend 可以传递参数
    DMRPerson *tPersion2 = objc_msgSend(personClass, sel_registerName("alloc"));

    tPersion2 = objc_msgSend(tPersion1, sel_registerName("init"));
    objc_msgSend(tPersion2, @selector(run:), 10);
}

@end
