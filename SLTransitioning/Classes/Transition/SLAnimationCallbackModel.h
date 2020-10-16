//
//  SLAnimationCallbackModel.h
//  SLTransitioning
//
//  Created by jocker luo on 2020/10/16.
//

#import <UIKit/UIKit.h>
#import "SLPanGestureControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLAnimationCallbackModel : NSObject

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

///初始化遮罩,也可以从外部传入遮罩
@property (nonatomic, copy) void(^ configMaskView)(UIView *maskView);
///转场结束,是否移除遮罩,未移除下次仍旧使用相同的遮罩
@property (nonatomic, copy) void(^ completedMaskView)(UIView *maskView, BOOL flag);

@end

NS_ASSUME_NONNULL_END
