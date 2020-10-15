#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SLPopInteractiveTransition.h"
#import "SLPopTransition.h"
#import "SLPushInteractiveTransition.h"
#import "SLPushTransition.h"
#import "SLTransitioning.h"
#import "SLInteractiveTransition.h"
#import "SLInteractiveTransitionModel.h"
#import "SLTransitionAnimator.h"
#import "UIViewController+SLTransitioning.h"
#import "SLPanGestureControl.h"
#import "UIView+SLTransitioning.h"

FOUNDATION_EXPORT double SLTransitioningVersionNumber;
FOUNDATION_EXPORT const unsigned char SLTransitioningVersionString[];

