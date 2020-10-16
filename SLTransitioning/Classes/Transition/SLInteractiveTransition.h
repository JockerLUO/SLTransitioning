//
//  SLInteractiveTransition.h
//  test
//
//  Created by jocker luo on 2020/9/28.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SLTransitioning.h"
#import "SLPanGestureControl.h"
#import "SLInteractiveTransitionModel.h"
#import "SLAnimationCallbackModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLInteractiveTransitionProtocol <NSObject>

@property (nonatomic, strong) SLInteractiveTransitionModel *model;
@property (nonatomic, strong) SLAnimationCallbackModel *callback;

@property (nonatomic, weak) UIViewController *weakVC;
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

///转场进度
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) BOOL isStartTransition;

- (SLPanDirectionType)currentDirection;

- (void)beginAnimate;
- (void)updateInteractiveTransition;
- (void)startTimerAnimationWithFinishTransition:(BOOL)isFinish;

- (void)finishAnimate:(void (^ __nullable)(BOOL finished))completion;
- (void)cancelAnimate:(void (^ __nullable)(BOOL finished))completion;
- (void)transitionEnd;
- (void)updateTransform:(CGFloat)percent;
- (void)addPanGestureForViewController:(UIViewController *)viewController;

- (UIView *)containerView;
- (UIView *)fromView;
- (UIView *)toView;
- (UIViewController *)fromViewController;
- (UIViewController *)toViewController;

///tabBar动画中
@property (nonatomic, assign, getter=isTabBarAnimting) BOOL tabBarAnimting;

- (void)tabBarSnapshotAnimation:(UIViewController *)showTabbarVC
                  hidenTabbarVC:(UIViewController *)hidenTabbarVC
                 showTabbarView:(UIView *)showTabbarView;
@property (nonatomic, strong, nullable) UIView *tabBarSnapshot;
@property (nonatomic, weak) UIViewController *showTabbarVC;
@property (nonatomic, weak) UIViewController *hidenTabbarVC;

@property (nonatomic, weak) UIView *maskView;

@end

@interface SLInteractiveTransition : UIPercentDrivenInteractiveTransition<SLPanGestureControlDelegate, SLInteractiveTransitionProtocol>

@property (nonatomic, strong) SLPanGestureControl *panGestureControl;

@end

NS_ASSUME_NONNULL_END
