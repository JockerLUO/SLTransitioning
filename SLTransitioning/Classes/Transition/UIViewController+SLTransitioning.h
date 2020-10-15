//
//  UIViewController+SLTransitioning.h
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLPanGestureControl.h"
#import "SLTransitionAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SLTransitioning)

@property (nonatomic, strong, readonly) SLTransitionAnimator *sl_transitionAnimator;

- (void)sl_registerPushTransition:( UIViewController * _Nullable (^)(SLPanDirectionType pushDirection))directionBlock;
- (void)sl_registerPushTransition:( UIViewController * _Nullable (^)(SLPanDirectionType pushDirection))directionBlock
                       completion:(void (^ _Nullable)(BOOL flag))completion;

- (void)sl_registerPopTransition:(BOOL (^)(SLPanDirectionType popDirection))directionBlock;
- (void)sl_registerPopTransition:(BOOL (^)(SLPanDirectionType popDirection))directionBlock
                      completion:(void (^ _Nullable)(BOOL flag))completion;

@end

NS_ASSUME_NONNULL_END
