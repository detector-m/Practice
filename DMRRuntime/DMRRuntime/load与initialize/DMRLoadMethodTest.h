//
//  DMRLoadMethodTest.h
//  DMRPractice
//
//  Created by Riven on 2020/9/4.
//  Copyright © 2020 Riven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@end

@interface Person (Test1)

@end

@interface Student : Person

@end

@interface Student (Test1)

@end

@interface Student (Test2)

@end

@interface Student (Test3)

@end

@interface Person (Test3)

@end

@interface Person1 : NSObject

@end

// 未实现load方法
@interface Teacher : Person1

@end

NS_ASSUME_NONNULL_END
