//
//  SLInteractiveTransitionModel.m
//  test
//
//  Created by jocker luo on 2020/9/28.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "SLInteractiveTransitionModel.h"

@implementation SLInteractiveTransitionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.completedPercent = 0.5;
        self.completedVelocity = 1000;
        
        self.animatedScale = 1;
        self.toViewAnimatedScale = 1;
        self.toViewAnimatedAreaScale = 1;
        self.fromViewAnimatedScale = 1;
        self.fromViewAnimatedAreaScale = 1;
        
        self.finishAnimatedDuration = 0.25;
        self.cancelAnimatedDuration = 0.15;
        
        self.animatedDuration = 0.25;
        self.animatedDirection = SLPanDirectionTypeLeft;
        
        self.tabBarAnimted = YES;
        
        self.maskViewTag = 1873952;
    }
    return self;
}

@end
