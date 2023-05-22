//
//  DMRInitializeMethodTest.h
//  DMRPractice
//
//  Created by Riven on 2020/9/4.
//  Copyright © 2020 Riven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMRAnimal : NSObject

@end

@interface DMRAnimal (Test1)

@end

@interface DMRAnimal (Test2)

@end

@interface DMRCat : DMRAnimal

@end

@interface DMRCat (Test1)

@end

@interface DMRDog : DMRAnimal

@end

NS_ASSUME_NONNULL_END
