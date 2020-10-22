//
//  SLPanGestureControl.m
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import "SLPanGestureControl.h"

@interface SLPanGestureControl() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

@property (nonatomic, assign) BOOL interacting;
///手势起始位置
@property (nonatomic, assign) CGPoint panGesStartPoint;
///转场起始位置
@property (nonatomic, assign) CGPoint interactStartPoint;
@property (nonatomic, assign) SLPanDirectionType currentDirection;


@end

@implementation SLPanGestureControl

- (void)dealloc {
    [self.panGes.view removeGestureRecognizer:self.panGes];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.triggerDistance = 5;
    }
    return self;
}

- (void)addPanGestureToView:(UIView *)view {
    UIPanGestureRecognizer
        *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPan:)];
    panGes.delegate = self;
    [view addGestureRecognizer:panGes];
}

- (void)respondsToPan:(UIPanGestureRecognizer *)pan {

    CGPoint point = [pan locationInView:pan.view.window];
    if (point.x < 0 || point.y < 0 ///已经有其他pop转场手势在进行,所以相应的pan.view在屏幕右侧,手势坐标为负
        || (pan.state == UIGestureRecognizerStateBegan && !CGPointEqualToPoint(CGPointZero, self.panGesStartPoint))
        || (pan.state == UIGestureRecognizerStateChanged && CGPointEqualToPoint(CGPointZero, self.panGesStartPoint))
            ) {
        [pan cancelsTouchesInView];
        return;
    }

    if (pan.state == UIGestureRecognizerStateBegan) {
        self.panGesStartPoint = point;
        return;
    }

    if (pan.state == UIGestureRecognizerStateChanged) {

        if (self.interacting) {

            CGPoint offsetPoint = CGPointMake(point.x - self.interactStartPoint.x,
                                              point.y - self.interactStartPoint.y);
            [self.delegate sl_panGestureChange:pan offsetPoint:offsetPoint];

        } else {

            CGFloat triggerDistance = self.triggerDistance;
            CGPoint offsetPoint = [pan translationInView:pan.view];
            CGFloat distanceOffset = hypotf(offsetPoint.x, offsetPoint.y);

            BOOL distanceArrive = distanceOffset > triggerDistance && distanceOffset < pan.view.bounds.size.width / 2;

            BOOL shouldStart = distanceArrive;
            if (shouldStart) {
                SLPanDirectionType direction = SLPanDirectionTypeUp;
                CGFloat offsetTan = offsetPoint.x / offsetPoint.y;
                if (fabs(offsetTan) > 1) {
                    if (offsetPoint.x > 0) {
                        direction = SLPanDirectionTypeRight;
                    } else {
                        direction = SLPanDirectionTypeLeft;
                    }
                } else {
                    if (offsetPoint.y > 0) {
                        direction = SLPanDirectionTypeDown;
                    } else {
                        direction = SLPanDirectionTypeUp;
                    }
                }

                BOOL beginGes = [self.delegate sl_panGestureBegin:pan direction:direction];
                if (beginGes) {
                    self.interactStartPoint = point;
                    self.interacting = YES;
                    self.currentDirection = direction;
                } else {
                    [self resetSLPanGestureControl];
                    [pan cancelsTouchesInView];
                }
            }
        }
        return;
    }

    // End.
    if (self.interacting) {
        CGPoint offsetPoint = CGPointMake(point.x - self.interactStartPoint.x, point.y - self.interactStartPoint.y);
        [self.delegate sl_panGestureEnd:pan offsetPoint:offsetPoint];
        self.currentDirection = SLPanDirectionTypeUnknow;
    } else {
        [self.delegate sl_panGestureCanacel:pan];
    }
    [self resetSLPanGestureControl];
}

- (void)resetSLPanGestureControl {
    self.interacting = NO;
    self.panGesStartPoint = CGPointZero;
    self.interactStartPoint = CGPointZero;
    self.currentDirection = SLPanDirectionTypeUnknow;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(sl_gestureRecognizerShouldBegin:)]) {
        return [self.delegate sl_gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(sl_panGestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.delegate sl_panGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

@end

CGFloat offsetPercent(CGPoint offsetPoint, CGSize areaSize, SLPanDirectionType direction) {
    CGFloat percent = 0;
    switch (direction) {
        case SLPanDirectionTypeUp: {
            percent = -offsetPoint.y / areaSize.height;
        } break;
        case SLPanDirectionTypeLeft: {
            percent = -offsetPoint.x / areaSize.width;
        } break;
        case SLPanDirectionTypeDown: {
            percent = offsetPoint.y / areaSize.height;
        } break;
        case SLPanDirectionTypeRight: {
            percent = offsetPoint.x / areaSize.width;
        } break;
        case SLPanDirectionTypeUnknow: {
            
        } break;
    }
    return percent;
}
