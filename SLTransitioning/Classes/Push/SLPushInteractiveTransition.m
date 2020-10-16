//
//  SLPushInteractiveTransition.m
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "SLPushInteractiveTransition.h"

@interface SLPushInteractiveTransition()

@end

@implementation SLPushInteractiveTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model.fromViewAnimatedScale = 0.3;
        self.model.completedVelocity = 600;
        self.model.completedPercent = 0.3;
        self.callback.completedMaskView = ^(UIView * _Nonnull maskView, BOOL flag) {
            if (!flag) {
                [maskView removeFromSuperview];
            }
        };
    }
    return self;
}

#pragma mark - SLInteractiveTransitionProtocol
- (void)beginAnimate {
    [super beginAnimate];
    [self.containerView bringSubviewToFront:self.toView];
    if (self.model.isMaskAnimted) {
        [self.containerView insertSubview:self.maskView belowSubview:self.toView];
    }
    [self tabBarSnapshotAnimation:self.fromViewController
                    hidenTabbarVC:self.toViewController
                   showTabbarView:self.fromView];
}

@end
