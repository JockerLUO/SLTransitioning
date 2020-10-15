//
//  SLTransitionAnimator.h
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLPushTransition.h"
#import "SLPushInteractiveTransition.h"

#import "SLPopTransition.h"
#import "SLPopInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLTransitionAnimator : NSObject<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) SLPushTransition *pushTransition;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition <SLInteractiveTransitionProtocol>*pushInteractiveTransition;

@property (strong, nonatomic) SLPopTransition *popTransition;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition <SLInteractiveTransitionProtocol>*popInteractiveTransition;

@end

NS_ASSUME_NONNULL_END
