//
//  DMRPlant+AssociatedObject.h
//  DMRRuntime
//
//  Created by Riven on 2023/5/22.
//

#import "DMRPlant.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMRPlant (AssociatedObject)

@property(nonatomic, strong) NSString *associatedName;
@property(nonatomic, strong) NSNumber *associatedHigh;
@property(nonatomic, strong) NSString *associatedCode;

@end

NS_ASSUME_NONNULL_END
