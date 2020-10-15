//
//  SLPopViewController.m
//  SLTransitioning_Example
//
//  Created by jocker luo on 2020/10/15.
//  Copyright © 2020 Jocker Luo. All rights reserved.
//

#import "SLPopViewController.h"

@interface SLPopViewController ()

@property (nonatomic, strong) UIButton *popBtn;
@property (nonatomic, strong) SLTransitionAnimator *transitionAnimator;

@end

@implementation SLPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @(self.sourceDirection).stringValue;
    switch (self.sourceDirection) {
        case SLPanDirectionTypeUp: {
            self.view.backgroundColor = UIColor.redColor;
            self.popDirection = SLPanDirectionTypeDown;
        } break;
        case SLPanDirectionTypeLeft: {
            self.view.backgroundColor = UIColor.yellowColor;
            self.popDirection = SLPanDirectionTypeRight;
        } break;
        case SLPanDirectionTypeDown: {
            self.view.backgroundColor = UIColor.blueColor;
            self.popDirection = SLPanDirectionTypeUp;
        } break;
        case SLPanDirectionTypeRight: {
            self.view.backgroundColor = UIColor.greenColor;
            self.popDirection = SLPanDirectionTypeLeft;
        } break;
        case SLPanDirectionTypeUnknow: {
            self.view.backgroundColor = UIColor.whiteColor;
        } break;
    }
    
    self.popBtn = [UIButton new];
    [self.view addSubview:self.popBtn];
    [self.popBtn setTitle:@"pop" forState:UIControlStateNormal];
    self.popBtn.frame = CGRectMake(0, 0, 100, 40);
    self.popBtn.center = self.view.center;
    self.popBtn.backgroundColor = UIColor.orangeColor;
    [self.popBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    self.transitionAnimator = [SLTransitionAnimator new];
    self.transitionAnimator.popInteractiveTransition.model.disablePanGesture = YES;
    self.transitionAnimator.popInteractiveTransition.model.animatedDirection = self.popDirection;
    
    __weak typeof(self) wSelf = self;
    [self sl_registerPopTransition:^BOOL(SLPanDirectionType popDirection) {
        __strong typeof(wSelf) self = wSelf;
        BOOL res = NO;
        if (popDirection == self.popDirection) {
            res = YES;
        }
        return res;
    } completion:nil];
    
    SLInteractiveTransitionModel *model = self.sl_transitionAnimator.popInteractiveTransition.model;
    __block UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    model.interactiveBegin = ^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
        __strong typeof(wSelf) self = wSelf;
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [toView addSubview:maskView];
        maskView.frame = CGRectMake(0, 0, toView.sl_width, toView.sl_height);
        UIView *tabBarSnapshot = self.sl_transitionAnimator.popInteractiveTransition.tabBarSnapshot;
        if (tabBarSnapshot && tabBarSnapshot.sl_bottom > maskView.sl_height) {
            maskView.sl_height = tabBarSnapshot.sl_bottom;
        }
    };
    model.interactiveChange = ^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, CGFloat percent) {
        maskView.alpha = (1 - percent);
    };
    model.interactiveEnd = ^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
        maskView.alpha = 0;
    };
    model.interactiveCancel = ^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
        maskView.alpha = 1;
    };
    model.interactiveCompletion = ^(BOOL flag) {
        [maskView removeFromSuperview];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)popAction:(UIButton *)btn {
    
    if (self.popDirection != SLPanDirectionTypeUnknow) {
        self.transitioningDelegate = self.transitionAnimator;
        self.navigationController.delegate = self.transitionAnimator;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
