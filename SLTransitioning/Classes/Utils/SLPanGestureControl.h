//
//  SLPanGestureControl.h
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SLPanDirectionType) {
    SLPanDirectionTypeUnknow,
    ///上
    SLPanDirectionTypeUp,
    ///左
    SLPanDirectionTypeLeft,
    ///下
    SLPanDirectionTypeDown,
    ///右
    SLPanDirectionTypeRight,
};

NS_ASSUME_NONNULL_BEGIN

@protocol SLPanGestureControlDelegate<NSObject>
@optional
///手势是否开始
- (BOOL)sl_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
///手势共存
- (BOOL)sl_panGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@required
///手势是否沿方向开始,平移手势已经开始
- (BOOL)sl_panGestureBegin:(UIPanGestureRecognizer *)gesture direction:(SLPanDirectionType)direction;
///手势移动
- (void)sl_panGestureChange:(UIPanGestureRecognizer *)gesture offsetPoint:(CGPoint)offsetPoint;
///手势结束
- (void)sl_panGestureEnd:(UIPanGestureRecognizer *)gesture offsetPoint:(CGPoint)offsetPoint;
///手势取消
- (void)sl_panGestureCanacel:(UIPanGestureRecognizer *)gesture;

@end


@interface SLPanGestureControl : NSObject

- (void)addPanGestureToView:(UIView *)view;
@property (weak, nonatomic) id<SLPanGestureControlDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL interacting;

@property (nonatomic, assign, readonly) SLPanDirectionType currentDirection;

@end

CGFloat offsetPercent(CGPoint offsetPoint, CGSize areaSize, SLPanDirectionType direction);

NS_ASSUME_NONNULL_END
