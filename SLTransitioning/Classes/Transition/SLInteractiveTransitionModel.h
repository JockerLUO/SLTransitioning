//
//  SLInteractiveTransitionModel.h
//  test
//
//  Created by jocker luo on 2020/9/28.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLPanGestureControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLInteractiveTransitionModel : NSObject

@property (nonatomic, assign) CGFloat completedVelocity;
@property (nonatomic, assign) CGFloat completedPercent;

///转场中系统动画的进度比例
@property (nonatomic, assign) CGFloat animatedScale;
///转场中toView动画的移动速度比例
@property (nonatomic, assign) CGFloat toViewAnimatedScale;
///转场中toView动画的可移动范围比例 ,pop动画中 toViewAnimatedAreaScale为0,toView不移动,
@property (nonatomic, assign) CGFloat toViewAnimatedAreaScale;
///转场中fromView动画的移动速度比例
@property (nonatomic, assign) CGFloat fromViewAnimatedScale;
///转场中toView动画的可移动范围比例,
@property (nonatomic, assign) CGFloat fromViewAnimatedAreaScale;

///是否开始动画
@property (nonatomic, copy) BOOL(^ transitionDirectionBlock)(SLPanDirectionType direction);
///开始转场
@property (nonatomic, copy) void(^ interactiveBegin)(id<UIViewControllerContextTransitioning> transitionContext);
///转场中
@property (nonatomic, copy) void(^ interactiveChange)(id<UIViewControllerContextTransitioning> transitionContext, CGFloat percent);
///转场结束,动画中
@property (nonatomic, copy) void(^ interactiveEnd)(id<UIViewControllerContextTransitioning> transitionContext);
///转场取消,动画中
@property (nonatomic, copy) void(^ interactiveCancel)(id<UIViewControllerContextTransitioning> transitionContext);
///转场结果
@property (nonatomic, copy) void(^ interactiveCompletion)(BOOL flag);

///手势共存
@property (nonatomic, copy) BOOL(^ recognizeSimultaneouslyBlock)(UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer);
///手势开始
@property (nonatomic, copy) BOOL(^ gestureRecognizerShouldBegin)(UIGestureRecognizer *gestureRecognizer);

///禁用平移手势,使用动画直接转场
@property (nonatomic, assign, getter=isDisablePanGesture) BOOL disablePanGesture;
///转场动画方向
@property (nonatomic, assign) SLPanDirectionType animatedDirection;

///完整的转场动画时间
@property (nonatomic, assign) CGFloat animatedDuration;
///结束转场动画时间
@property (nonatomic, assign) CGFloat finishAnimatedDuration;
///取消转场动画时间
@property (nonatomic, assign) CGFloat cancelAnimatedDuration;


///是否有tabBar动画
@property (nonatomic, assign, getter=isTabBarAnimted) BOOL tabBarAnimted;

@end

NS_ASSUME_NONNULL_END
