//
//  SLTransitionAnimator.m
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "SLTransitionAnimator.h"

@interface SLTransitionAnimator()

@end

@implementation SLTransitionAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pushTransition = [SLPushTransition new];
        self.pushInteractiveTransition = [SLPushInteractiveTransition new];
        self.popTransition = [SLPopTransition new];
        self.popInteractiveTransition = [SLPopInteractiveTransition new];
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
