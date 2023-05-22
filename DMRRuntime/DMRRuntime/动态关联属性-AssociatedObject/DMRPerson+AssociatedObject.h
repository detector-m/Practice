//
//  DMRPerson+AssociatedObject.h
//  DMRRuntime
//
//  Created by Riven on 2023/5/22.
//

#import "DMRPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMRPerson (AssociatedObject)

@property(nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
