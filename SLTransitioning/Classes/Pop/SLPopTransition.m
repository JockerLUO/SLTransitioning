//
//  SLPopTransition.m
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "SLPopTransition.h"

@implementation SLPopTransition

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
}

@end
