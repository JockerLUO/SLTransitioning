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

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    [super addPanGestureForViewController:viewController];
    self.model.fromViewAnimatedScale = 0.3;
    self.model.completedVelocity = 600;
    self.model.completedPercent = 0.3;
}

#pragma mark - SLInteractiveTransitionProtocol
- (void)beginAnimate {
    [super beginAnimate];
    [self.containerView bringSubviewToFront:self.toView];
    [self tabBarSnapshotAnimation:self.fromViewController
                    hidenTabbarVC:self.toViewController
                   showTabbarView:self.fromView];
}

@end
