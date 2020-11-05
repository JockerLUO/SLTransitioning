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
@property (nonatomic, strong) UIButton *pushBtn;
@property (nonatomic, strong) SLTransitionAnimator *transitionAnimator;

@end

@implementation SLPopViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionAnimator = [SLTransitionAnimator new];
        SLInteractiveTransitionModel *model = self.transitionAnimator.popInteractiveTransition.model;
        model.disablePanGesture = YES;
        model.maskAnimted = YES;
        model.maskAnimtedScale = -1;
        self.backViewAlpha = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @(self.sourceDirection).stringValue;
    switch (self.sourceDirection) {
        case SLPanDirectionTypeUp: {
            self.view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:self.backViewAlpha];
            self.popDirection = SLPanDirectionTypeDown;
        } break;
        case SLPanDirectionTypeLeft: {
            self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:self.backViewAlpha];
            self.popDirection = SLPanDirectionTypeRight;
        } break;
        case SLPanDirectionTypeDown: {
            self.view.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:self.backViewAlpha];
            self.popDirection = SLPanDirectionTypeUp;
        } break;
        case SLPanDirectionTypeRight: {
            self.view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:self.backViewAlpha];
            self.popDirection = SLPanDirectionTypeLeft;
        } break;
        case SLPanDirectionTypeUnknow: {
            self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:self.backViewAlpha];
        } break;
    }
    
    self.popBtn = [UIButton new];
    [self.view addSubview:self.popBtn];
    [self.popBtn setTitle:@"pop" forState:UIControlStateNormal];
    self.popBtn.frame = CGRectMake(0, 0, 100, 40);
    self.popBtn.center = self.view.center;
    self.popBtn.sl_centerY = self.popBtn.sl_centerY * 0.7;
    self.popBtn.backgroundColor = UIColor.orangeColor;
    [self.popBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pushBtn = [UIButton new];
    [self.view addSubview:self.pushBtn];
    [self.pushBtn setTitle:@"push" forState:UIControlStateNormal];
    self.pushBtn.frame = CGRectMake(0, 0, 100, 40);
    self.pushBtn.center = self.view.center;
    self.pushBtn.sl_centerY = self.pushBtn.sl_centerY * 1.3;
    self.pushBtn.backgroundColor = UIColor.orangeColor;
    [self.pushBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];

    __weak typeof(self) wSelf = self;
    [self sl_registerPopTransition:^BOOL(SLPanDirectionType popDirection) {
        __strong typeof(wSelf) self = wSelf;
        BOOL res = NO;
        if (popDirection == self.popDirection) {
            res = YES;
        }
        return res;
    } completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.sourceDirection != SLPanDirectionTypeUnknow animated:animated];
}

- (void)popAction:(UIButton *)btn {
    
    if (self.popDirection != SLPanDirectionTypeUnknow) {
        self.transitioningDelegate = self.transitionAnimator;
        self.navigationController.delegate = self.transitionAnimator;
        self.transitionAnimator.popInteractiveTransition.model.animatedDirection = self.popDirection;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushAction:(UIButton *)btn {
    [self.navigationController pushViewController:[SLPopViewController new] animated:YES];
}

@end
