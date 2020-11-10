//
//  SLTransitionAnimator.m
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "SLTransitionAnimator.h"

@interface SLTransitionAnimator()

@property (nonatomic, assign, getter=isHang) BOOL hang;

@end

@implementation SLTransitionAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pushTransition = [SLPushTransition new];
        self.pushInteractiveTransition = [SLPushInteractiveTransition new];
        
        self.popTransition = [SLPopTransition new];
        self.popInteractiveTransition = [SLPopInteractiveTransition new];
        
        __weak typeof(self) wSelf = self;
        SLAnimationCallbackModel *pushCallbackModel = self.pushInteractiveTransition.callback;
        pushCallbackModel.gestureRecognizerShouldBegin = ^BOOL(UIGestureRecognizer * _Nonnull gestureRecognizer) {
            __strong typeof(wSelf) self = wSelf;
            return self.isHang == NO;
        };
        pushCallbackModel.interactiveDidCancel = ^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
            __strong typeof(wSelf) self = wSelf;
            self.hang = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hang = NO;
            });
        };
        
        SLAnimationCallbackModel *popCallbackModel = self.popInteractiveTransition.callback;
        popCallbackModel.gestureRecognizerShouldBegin = ^BOOL(UIGestureRecognizer * _Nonnull gestureRecognizer) {
            __strong typeof(wSelf) self = wSelf;
            return self.isHang == NO;
        };
        popCallbackModel.interactiveDidCancel = ^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
            __strong typeof(wSelf) self = wSelf;
            self.hang = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hang = NO;
            });
        };

    }
    return self;
}

- (nullable id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                  interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (animationController == self.popTransition) {
        return self.popInteractiveTransition;
    } else if (animationController == self.pushTransition) {
        return self.pushInteractiveTransition;
    }
    return nil;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                           animationControllerForOperation:(UINavigationControllerOperation)operation
                                                        fromViewController:(UIViewController *)fromVC
                                                          toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        return self.popTransition;
    } else if (operation == UINavigationControllerOperationPush) {
        return self.pushTransition;
    }
    return nil;
}

@end
