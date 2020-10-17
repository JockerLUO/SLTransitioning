//
//  SLPopInteractiveTransition.m
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "SLPopInteractiveTransition.h"

@interface SLPopInteractiveTransition()

@end

@implementation SLPopInteractiveTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model.toViewAnimatedAreaScale = 0;
        self.model.completedPercent = 0.4;
        self.callback.completedMaskView = ^(UIView * _Nonnull maskView, BOOL flag) {
            if (flag) {
                [maskView removeFromSuperview];
            }
        };
    }
    return self;
}

#pragma mark - SLInteractiveTransitionProtocol
- (void)beginAnimate {
    [super beginAnimate];
    [self.containerView bringSubviewToFront:self.fromView];
    if (self.model.isMaskAnimted) {
        [self.containerView insertSubview:self.maskView belowSubview:self.fromView];
    }
    [self tabBarSnapshotAnimation:self.toViewController
                    hidenTabbarVC:self.fromViewController
                   showTabbarView:self.toView];
}

@end
