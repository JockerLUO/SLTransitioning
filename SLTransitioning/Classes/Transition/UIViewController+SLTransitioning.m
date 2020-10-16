//
//  UIViewController+SLTransitioning.m
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "UIViewController+SLTransitioning.h"
#import <objc/runtime.h>

@interface UIViewController()

@property (nonatomic, strong) SLTransitionAnimator *sl_transitionAnimator;
@property (nonatomic, weak) UIView *tabBarSnapshot;

@end

@implementation UIViewController (SLTransitioning)

- (SLTransitionAnimator *)sl_transitionAnimator {
    SLTransitionAnimator *transitionAnimator = objc_getAssociatedObject(self, _cmd);
    if (transitionAnimator == nil) {
        transitionAnimator = [SLTransitionAnimator new];
        objc_setAssociatedObject(self, _cmd, transitionAnimator,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return transitionAnimator;
}

- (void)sl_registerPushTransition:( UIViewController * _Nullable (^)(SLPanDirectionType direction))directionBlock {
    [self sl_registerPushTransition:directionBlock completion:nil];
}

- (void)sl_registerPushTransition:( UIViewController * _Nullable (^)(SLPanDirectionType direction))directionBlock
                       completion:(void (^)(BOOL flag))completion {
    [self.sl_transitionAnimator.pushInteractiveTransition addPanGestureForViewController:self];
    self.sl_transitionAnimator.pushInteractiveTransition.callback.interactiveCompletion = completion;
    __weak typeof(self) wSelf = self;
    self.sl_transitionAnimator.pushInteractiveTransition.callback.transitionDirectionBlock = ^BOOL(SLPanDirectionType direction) {
        __strong typeof(wSelf) self = wSelf;
        BOOL res = NO;
        UIViewController *vc = directionBlock(direction);
         if (vc) {
             res = YES;
             self.transitioningDelegate = self.sl_transitionAnimator;
             self.navigationController.delegate = self.sl_transitionAnimator;
             [self.navigationController pushViewController:vc animated:YES];
         }
        return res;
    };
}

- (void)sl_registerPopTransition:(BOOL (^)(SLPanDirectionType))directionBlock {
    [self sl_registerPopTransition:directionBlock completion:nil];
}

- (void)sl_registerPopTransition:(BOOL (^)(SLPanDirectionType direction))directionBlock
                      completion:(void (^)(BOOL flag))completion {
    [self.sl_transitionAnimator.popInteractiveTransition addPanGestureForViewController:self];
    self.sl_transitionAnimator.popInteractiveTransition.callback.interactiveCompletion = completion;
    __weak typeof(self) wSelf = self;
    self.sl_transitionAnimator.popInteractiveTransition.callback.transitionDirectionBlock = ^BOOL(SLPanDirectionType direction) {
        __strong typeof(wSelf) self = wSelf;
        BOOL res = directionBlock(direction);
        if (res) {
            self.transitioningDelegate = self.sl_transitionAnimator;
            self.navigationController.delegate = self.sl_transitionAnimator;
            [self.navigationController popViewControllerAnimated:YES];
        }
        return res;
    };
}

@end
