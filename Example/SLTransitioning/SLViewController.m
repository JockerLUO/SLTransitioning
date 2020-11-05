//
//  SLViewController.m
//  SLTransitioning
//
//  Created by Jocker Luo on 10/15/2020.
//  Copyright (c) 2020 Jocker Luo. All rights reserved.
//

#import "SLViewController.h"
#import <SLTransitioning.h>
#import "SLPopViewController.h"

@interface SLViewController ()

@property (nonatomic, strong) UIButton *pushBtn;
@property (nonatomic, strong) UIButton *pushUpBtn;
@property (nonatomic, strong) UIButton *pushDownBtn;
@property (nonatomic, strong) UIButton *pushLeftBtn;
@property (nonatomic, strong) UIButton *pushRightBtn;

@property (strong, nonatomic) SLPushTransition *pushTransition;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition <SLInteractiveTransitionProtocol>*pushInteractiveTransition;

@property (nonatomic, strong) SLTransitionAnimator *transitionAnimator;

@end

@implementation SLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    self.pushBtn = [self creatPushButton:SLPanDirectionTypeUnknow];
    self.pushUpBtn = [self creatPushButton:SLPanDirectionTypeUp];
    self.pushDownBtn = [self creatPushButton:SLPanDirectionTypeDown];
    self.pushLeftBtn = [self creatPushButton:SLPanDirectionTypeLeft];
    self.pushRightBtn = [self creatPushButton:SLPanDirectionTypeRight];
    self.transitionAnimator = [SLTransitionAnimator new];
    
    [self sl_registerPushTransition:^UIViewController * _Nullable(SLPanDirectionType pushDirection) {
        UIViewController *vc = nil;
         if (pushDirection != SLPanDirectionTypeUnknow) {
             SLPopViewController *pushVC = [SLPopViewController new];
             pushVC.sourceDirection = pushDirection;
             pushVC.hidesBottomBarWhenPushed = YES;
             vc = pushVC;
         }
        return vc;
    } completion:^(BOOL flag) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIButton *)creatPushButton:(SLPanDirectionType)direction {
    UIButton *btn = [UIButton new];
    btn.sl_size = CGSizeMake(70, 50);
    btn.tag = direction;
    NSString *title = nil;
    btn.center = self.view.center;
    switch (direction) {
        case SLPanDirectionTypeUp: {
            title = @"up";
            btn.sl_centerY = btn.sl_centerY / 2;
        } break;
        case SLPanDirectionTypeLeft: {
            title = @"left";
            btn.sl_centerX = btn.sl_centerX / 2;
        } break;
        case SLPanDirectionTypeDown: {
            title = @"down";
            btn.sl_centerY = btn.sl_centerY * 3 / 2;
        } break;
        case SLPanDirectionTypeRight: {
            title = @"right";
            btn.sl_centerX = btn.sl_centerX * 3 / 2;
        } break;
        case SLPanDirectionTypeUnknow: {
            title = @"center";
        } break;
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = UIColor.blueColor;
    [self.view addSubview:btn];
    return btn;
}


- (void)pushAction:(UIButton *)btn {
    SLPanDirectionType direction = btn.tag;
    SLPopViewController *vc = [SLPopViewController new];
    vc.sourceDirection = direction;
    vc.title = btn.titleLabel.text;
    vc.hidesBottomBarWhenPushed = YES;
    
    if (direction != SLPanDirectionTypeUnknow) {
        self.transitioningDelegate = self.transitionAnimator;
        self.navigationController.delegate = self.transitionAnimator;
        SLInteractiveTransitionModel *model = self.transitionAnimator.pushInteractiveTransition.model;
        model.animatedDirection = direction;
        model.disablePanGesture = YES;
        model.maskAnimted = YES;
        model.maskAnimtedScale = 1;
        SLAnimationCallbackModel *callback = self.transitionAnimator.pushInteractiveTransition.callback;
        callback.configMaskView = ^(UIView * _Nonnull maskView) {
            maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        };
        vc.sl_transitionAnimator.popInteractiveTransition.model.maskAnimted = YES;
        vc.sl_transitionAnimator.popInteractiveTransition.model.maskAnimtedScale = -1;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


@end
