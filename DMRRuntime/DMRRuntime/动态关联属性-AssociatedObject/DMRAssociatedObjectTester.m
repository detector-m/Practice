//
//  DMRAssociatedObjectTester.m
//  DMRRuntime
//
//  Created by Riven on 2023/5/22.
//

#import "DMRAssociatedObjectTester.h"
#import "DMRPerson+AssociatedObject.h"
#import "DMRPlant+AssociatedObject.h"

@implementation DMRAssociatedObjectTester

+ (void)rtAssociatedObjectTest {
    NSLog(@"%s", __func__);

    DMRPerson *t = [DMRPerson new];
    NSLog(@"Person name = %@, 1", t.name);
    t.name = @"123";
    NSLog(@"Person name = %@, 2", t.name);
    
    DMRPlant *tPlant = [DMRPlant new];
    
    NSLog(@"Plant name = %@, high = %@, code = %@, 1", tPlant.associatedName, tPlant.associatedHigh, tPlant.associatedCode);
    
    tPlant.associatedName = @"1234567890";
    tPlant.associatedHigh = @290;
    tPlant.associatedCode = @"09099jfjej";
    
    NSLog(@"Plant name = %@, high = %@, code = %@, 2", tPlant.associatedName, tPlant.associatedHigh, tPlant.associatedCode);
}

@end
