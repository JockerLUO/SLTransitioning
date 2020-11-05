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
        self.callback.configContainerView = ^NSArray * _Nonnull(UIView * _Nonnull fromView, UIView * _Nonnull toView, UIView * _Nullable maskView) {
            if (maskView != nil) {
                return @[toView, maskView, fromView];
            } else {
                return @[toView, fromView];
            }
        };
    }
    return self;
}

#pragma mark - SLInteractiveTransitionProtocol
- (void)beginAnimate {
    [super beginAnimate];
    [self tabBarSnapshotAnimation:self.toViewController
                    hidenTabbarVC:self.fromViewController
                   showTabbarView:self.toView];
}

@end
