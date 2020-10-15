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

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    [super addPanGestureForViewController:viewController];
    self.model.toViewAnimatedAreaScale = 0;
    self.model.completedVelocity = 1000;
    self.model.completedPercent = 0.4;
}

#pragma mark - SLInteractiveTransitionProtocol
- (void)beginAnimate {
    [super beginAnimate];
    [self.containerView bringSubviewToFront:self.fromView];
    [self tabBarSnapshotAnimation:self.toViewController
                    hidenTabbarVC:self.fromViewController
                   showTabbarView:self.toView];
}

@end
