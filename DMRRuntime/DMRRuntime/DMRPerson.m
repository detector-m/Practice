//
//  DMRPerson.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/20.
//

#import "DMRPerson.h"

@implementation DMRPerson

- (void)eat {
    NSLog(@"吃东西");
}

- (void)run:(NSUInteger)distance {
    NSLog(@"跑了 %ld 米", distance);
}

@end
