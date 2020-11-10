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

///禁用平移手势,使用动画直接转场
@property (nonatomic, assign, getter=isDisablePanGesture) BOOL disablePanGesture;
///转场动画方向
@property (nonatomic, assign) SLPanDirectionType animatedDirection;

///完整的转场动画时间
@property (nonatomic, assign) CGFloat animatedDuration;

///是否匀速结束动画,和 finishAnimatedDuration, cancelAnimatedDuration 冲突,默认NO, 
///e.g. uniformSpeedFinishAnimation为YES animatedDuration 为1, completedPercent 为0.3,进度为0.4,转场动画时间为0.6,和 finishAnimatedDuration 无关
@property (nonatomic, assign, getter=isUniformSpeed) BOOL uniformSpeedFinishAnimation;

///结束转场动画时间
@property (nonatomic, assign) CGFloat finishAnimatedDuration;
///取消转场动画时间
@property (nonatomic, assign) CGFloat cancelAnimatedDuration;

///是否有tabBar动画
@property (nonatomic, assign, getter=isTabBarAnimted) BOOL tabBarAnimted;

///遮罩动画
@property (nonatomic, assign, getter=isMaskAnimted) BOOL maskAnimted;
///遮罩动画透明度变化比例,正为由浅到深,负为由深到浅
@property (nonatomic, assign) CGFloat maskAnimtedScale;
///遮罩的tag,用于获取已有的遮罩,如果需要在不同页面有不同的遮罩,可以设置不一样的tag
@property (nonatomic, assign) NSInteger maskViewTag;

@end

NS_ASSUME_NONNULL_END
