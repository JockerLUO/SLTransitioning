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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionAnimator = [SLTransitionAnimator new];
        SLInteractiveTransitionModel *model = self.transitionAnimator.popInteractiveTransition.model;
        model.disablePanGesture = YES;
        model.maskAnimted = YES;
        model.maskAnimtedScale = -1;
    }
    return self;
}

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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)popAction:(UIButton *)btn {
    
    if (self.popDirection != SLPanDirectionTypeUnknow) {
        self.transitioningDelegate = self.transitionAnimator;
        self.navigationController.delegate = self.transitionAnimator;
        self.transitionAnimator.popInteractiveTransition.model.animatedDirection = self.popDirection;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
