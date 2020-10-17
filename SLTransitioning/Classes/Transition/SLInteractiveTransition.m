//
//  SLInteractiveTransition.m
//  test
//
//  Created by jocker luo on 2020/9/28.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "SLInteractiveTransition.h"

@interface SLInteractiveTransition()

@end

@implementation SLInteractiveTransition

@synthesize isStartTransition;
@synthesize model;
@synthesize panGestureControl;
@synthesize percent;
@synthesize tabBarAnimting;
@synthesize transitionContext;
@synthesize hidenTabbarVC;
@synthesize showTabbarVC;
@synthesize tabBarSnapshot;
@synthesize callback;
@synthesize maskView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [SLInteractiveTransitionModel new];
        self.callback = [SLAnimationCallbackModel new];
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    self.panGestureControl = [SLPanGestureControl new];
    [self.panGestureControl addPanGestureToView:viewController.view];
    self.panGestureControl.delegate = self;
}

#pragma mark - SLPanGestureControlDelegate
- (BOOL)sl_panGestureBegin:(nonnull UIPanGestureRecognizer *)gesture
                 direction:(SLPanDirectionType)direction {
    BOOL res = NO;
    if (self.callback.transitionDirectionBlock) {
        res = self.callback.transitionDirectionBlock(direction);
    }
    return res;
}

- (void)sl_panGestureCanacel:(nonnull UIPanGestureRecognizer *)gesture {
    NSLog(@" animate fail ");
}

- (void)sl_panGestureChange:(nonnull UIPanGestureRecognizer *)gesture offsetPoint:(CGPoint)offsetPoint {
    self.percent = 0;
    self.percent = offsetPercent(offsetPoint, gesture.view.bounds.size, self.currentDirection);
    self.percent = MAX(0, self.percent);
    self.percent = MIN(1, self.percent);
    [self updateInteractiveTransition];
}

- (void)sl_panGestureEnd:(nonnull UIPanGestureRecognizer *)gesture
             offsetPoint:(CGPoint)offsetPoint {
    CGPoint velocity = [gesture velocityInView:gesture.view];
    
    BOOL velocityArrive = ABS(velocity.x) > self.model.completedVelocity;
    BOOL distanceArrive = ABS(self.percent) > self.model.completedPercent;
    
    BOOL shouldTransit = distanceArrive || velocityArrive;
    if (self.isStartTransition) {
        [self startTimerAnimationWithFinishTransition:shouldTransit];
    } else {
        ///转场动画还没开始,手势就提前结束了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startTimerAnimationWithFinishTransition:shouldTransit];
        });
        NSLog(@" transit wait ");
    }
}

- (BOOL)sl_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.callback.gestureRecognizerShouldBegin) {
        return self.callback.gestureRecognizerShouldBegin(gestureRecognizer);
    }
    return YES;
}

- (BOOL)sl_panGestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if (self.callback.recognizeSimultaneouslyBlock) {
        return self.callback.recognizeSimultaneouslyBlock(gestureRecognizer, otherGestureRecognizer);
    }
    return NO;
}

#pragma mark - UIPercentDrivenInteractiveTransition
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isStartTransition) {
        return;
    }
    self.isStartTransition = YES;
    self.transitionContext = transitionContext;
    [self beginAnimate];
    if (self.model.isDisablePanGesture) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishInteractiveTransition];
            [UIView animateWithDuration:self.model.animatedDuration animations:^{
                [self updateTransform:1];
                if (self.callback.interactiveEnd) {
                    self.callback.interactiveEnd(self.transitionContext);
                }
            } completion:^(BOOL finished) {
                if (self.tabBarAnimting && self.showTabbarVC == self.toViewController) {
                    UITabBar *tabBar = self.showTabbarVC.tabBarController.tabBar;
                    tabBar.hidden = NO;
                }
                [self finishMaskViewAnimation:YES];
                [self transitionEnd];
                [self.transitionContext completeTransition:YES];
                if (self.callback.interactiveCompletion) {
                    self.callback.interactiveCompletion(YES);
                }
            }];
        });
    }
}


#pragma mark - SLInteractiveTransitionProtocol
- (void)beginAnimate {
    [self.containerView addSubview:self.fromView];
    [self.containerView addSubview:self.toView];
    [self configMaskViewAnimation];
    [self updateTransform:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.callback.interactiveBegin) {
            self.callback.interactiveBegin(self.transitionContext);
        }
    });
}

- (void)updateInteractiveTransition {
    if (!self.isStartTransition) return;
    [self updateTransform:self.percent];
    if (self.callback.interactiveChange) {
        self.callback.interactiveChange(self.transitionContext, self.percent);
    }
    CGFloat percentComplete = self.percent * self.model.animatedScale;
    [self updateInteractiveTransition:percentComplete];
}

- (void)startTimerAnimationWithFinishTransition:(BOOL)isFinish {
    if (isFinish) {
        [self finishInteractiveTransition];
        [self finishAnimate:^(BOOL finished) {
            if (self.tabBarAnimting && self.showTabbarVC == self.toViewController) {
                UITabBar *tabBar = self.showTabbarVC.tabBarController.tabBar;
                tabBar.hidden = NO;
            }
            [self finishMaskViewAnimation:isFinish];
            [self transitionEnd];
            if (self.model.isMaskAnimted && self.callback.completedMaskView) {
                self.callback.completedMaskView(self.maskView, isFinish);
            }
            [self.transitionContext completeTransition:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.callback.interactiveCompletion) {
                    self.callback.interactiveCompletion(YES);
                }
            });
        }];
    } else {
        [self cancelInteractiveTransition];
        [self cancelAnimate:^(BOOL finished) {
            if (self.tabBarAnimting && self.showTabbarVC == self.fromViewController) {
                UITabBar *tabBar = self.showTabbarVC.tabBarController.tabBar;
                tabBar.hidden = NO;
            }
            [self finishMaskViewAnimation:isFinish];
            [self transitionEnd];
            [self.transitionContext completeTransition:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.callback.interactiveCompletion) {
                    self.callback.interactiveCompletion(NO);
                }
            });
        }];
    }
}

- (void)finishAnimate:(void (^ __nullable)(BOOL finished))completion {
    if (!self.isStartTransition) return;
    self.isStartTransition = NO;
    [UIView animateWithDuration:self.model.finishAnimatedDuration animations:^{
        [self updateTransform:1];
        if (self.callback.interactiveEnd) {
            self.callback.interactiveEnd(self.transitionContext);
        }
    } completion:completion];
}

- (void)cancelAnimate:(void (^ __nullable)(BOOL finished))completion {
    if (!self.isStartTransition) return;
    self.isStartTransition = NO;
    [UIView animateWithDuration:self.model.cancelAnimatedDuration animations:^{
        [self updateTransform:0];
        if (self.callback.interactiveCancel) {
            self.callback.interactiveCancel(self.transitionContext);
        }
    } completion:completion];
}

- (void)transitionEnd {
    self.isStartTransition = NO;
    [self tabBarSnapshotAnimationEnd];
    UIViewController *fromViewController = self.fromViewController;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.transitionContext = nil;
        fromViewController.transitioningDelegate = nil;
        fromViewController.navigationController.delegate = nil;
    });
}

- (void)updateTransform:(CGFloat)percent {
    
    SLPanDirectionType direction = self.currentDirection;
    UIView *fromView = self.fromView;
    UIView *toView = self.toView;
    CGFloat fromViewPercent = percent * self.model.fromViewAnimatedScale;
    CGFloat toViewPercent = (1 - percent * self.model.toViewAnimatedScale);
        
    CGFloat toViewAnimatedArea = 0;
    CGFloat fromViewAnimatedArea = 0;
    if (direction == SLPanDirectionTypeUp || direction == SLPanDirectionTypeDown) {
        toViewAnimatedArea = toView.sl_height;
        fromViewAnimatedArea = toView.sl_height;
    } else if (direction == SLPanDirectionTypeLeft || direction == SLPanDirectionTypeRight) {
        toViewAnimatedArea = toView.sl_width;
        fromViewAnimatedArea = toView.sl_width;
    }
    toViewAnimatedArea *= self.model.toViewAnimatedAreaScale;
    fromViewAnimatedArea *= self.model.fromViewAnimatedAreaScale;
    
    CGFloat toViewAnimatedOffset = toViewAnimatedArea * toViewPercent;
    CGFloat fromViewAnimatedOffset = fromViewAnimatedArea * fromViewPercent;
    
    switch (direction) {
        case SLPanDirectionTypeUp: {
            fromView.sl_y = -fromViewAnimatedOffset;
            toView.sl_y   = toViewAnimatedOffset;
        } break;
        case SLPanDirectionTypeLeft: {
            fromView.sl_x = -fromViewAnimatedOffset;
            toView.sl_x   = toViewAnimatedOffset;
        } break;
        case SLPanDirectionTypeDown: {
            fromView.sl_y = fromViewAnimatedOffset;
            toView.sl_y   = -toViewAnimatedOffset;
        } break;
        case SLPanDirectionTypeRight: {
            fromView.sl_x = fromViewAnimatedOffset;
            toView.sl_x   = -toViewAnimatedOffset;
        } break;
        case SLPanDirectionTypeUnknow: {
            
        } break;
    }
    
    if (self.model.isMaskAnimted) {
        CGFloat alpha = 0;
        if (self.model.maskAnimtedScale > 0) {
            alpha = percent * self.model.maskAnimtedScale;
        } else if (self.model.maskAnimtedScale < 0) {
            alpha = 1 + percent * self.model.maskAnimtedScale;
        }
        self.maskView.alpha = alpha;
    }
}
#pragma mark - tabBarAnimation

- (void)tabBarSnapshotAnimation:(UIViewController *)showTabbarVC
                  hidenTabbarVC:(UIViewController *)hidenTabbarVC
                 showTabbarView:(UIView *)showTabbarView {
    UITabBar *tabBar = showTabbarVC.tabBarController.tabBar;

    BOOL res1 = showTabbarVC.hidesBottomBarWhenPushed;
    BOOL res2 = hidenTabbarVC.hidesBottomBarWhenPushed;
    
    if (self.model.isTabBarAnimted == NO
        || res1 == YES
        || res2 == NO
        || tabBar == nil) {
        return;
    }

/*
 参考:https://github.com/alanwangmodify/WXSTransition
 不可以使用snapshotViewAfterScreenUpdates,在pop中无法截到图
 UIView *tabBarSnapshot = [tabBar snapshotViewAfterScreenUpdates:NO];
 截图需要全屏,避免截不到 tabBar 的子控件超出部分,比如 tabBar.shadowImage
*/
    CGRect tabBarRect = [tabBar convertRect:tabBar.bounds toView:showTabbarView];
    CGSize ctxSize = showTabbarView.bounds.size;
    if (!tabBar.isTranslucent) {
        ctxSize = CGSizeMake(ctxSize.width, ctxSize.height + tabBarRect.size.height);
    }
    
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, tabBarRect.origin.y); //需要偏移ctx
    [tabBar.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *tabBarSnapshot = [[UIImageView alloc] initWithImage:image];

    [showTabbarView addSubview:tabBarSnapshot];
    self.tabBarSnapshot = tabBarSnapshot;
    tabBar.hidden = YES;
    
    hidenTabbarVC.hidesBottomBarWhenPushed = NO;
    self.showTabbarVC = showTabbarVC;
    self.hidenTabbarVC = hidenTabbarVC;
    self.tabBarAnimting = YES;
}

- (void)tabBarSnapshotAnimationEnd {
    if (self.isTabBarAnimting == NO) return;;
    [self.tabBarSnapshot removeFromSuperview];
    self.tabBarSnapshot = nil;
    self.hidenTabbarVC.hidesBottomBarWhenPushed = YES;
    UITabBar *tabBar = self.showTabbarVC.tabBarController.tabBar;
    if (tabBar.layer.animationKeys  > 0) {
        [tabBar.layer removeAllAnimations];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        tabBar.frame = CGRectMake(0, CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), CGRectGetHeight(tabBar.frame));
    });
    self.tabBarAnimting = NO;
}

#pragma mark - maskView

- (void)configMaskViewAnimation {
    if (self.model.isMaskAnimted) {
        UIView *maskView = [self.containerView viewWithTag:self.model.maskViewTag];
        if (maskView == nil) {
            maskView = [UIView new];
            maskView.tag = self.model.maskViewTag;
        }
        if (self.callback.configMaskView) {
            self.callback.configMaskView(maskView);
        }
        [self.containerView addSubview:maskView];
        maskView.frame = CGRectMake(0, 0, self.containerView.sl_width, self.containerView.sl_height);
        self.maskView = maskView;
    }
}

- (void)finishMaskViewAnimation:(BOOL)flag {
    if (self.model.isMaskAnimted && self.callback.completedMaskView) {
        self.callback.completedMaskView(self.maskView, flag);
        self.maskView = nil;
    }
}

#pragma mark - getter

- (SLPanDirectionType)currentDirection {
    if (self.model.disablePanGesture) {
        return self.model.animatedDirection;
    } else {
        return self.panGestureControl.currentDirection;
    }
}

- (UIView *)containerView {
    return self.transitionContext.containerView;
}

- (UIView *)fromView {
    return [self.transitionContext viewForKey:UITransitionContextFromViewKey];
}

- (UIView *)toView {
    return [self.transitionContext viewForKey:UITransitionContextToViewKey];
}

- (UIViewController *)fromViewController {
    return [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (UIViewController *)toViewController {
    return [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
}

@end
