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
        self.model.completedPercent = 0.3;
        self.callback.completedMaskView = ^(UIView * _Nonnull maskView, BOOL flag) {
            if (!flag) {
                [maskView removeFromSuperview];
            }
        };
        self.callback.configContainerView = ^NSArray * _Nonnull(UIView * _Nonnull fromView, UIView * _Nonnull toView, UIView * _Nullable maskView) {
            if (maskView != nil) {
                return @[fromView, maskView, toView];
            } else {
                return @[fromView, toView];
            }
        };
    }
    return self;
}

#pragma mark - SLInteractiveTransitionProtocol
- (void)beginAnimate {
    [super beginAnimate];
    [self tabBarSnapshotAnimation:self.fromViewController
                    hidenTabbarVC:self.toViewController
                   showTabbarView:self.fromView];
}

@end
