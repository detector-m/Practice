//
//  DMRCustomOperation.m
//  DMRThread
//
//  Created by Riven on 2023/5/24.
//

#import "DMRCustomOperation.h"

@implementation DMRCustomOperation

- (void)main {
    NSLog(@"%s, name = %@, thread = %@", __func__, self.name, [NSThread currentThread]);
}

@end
