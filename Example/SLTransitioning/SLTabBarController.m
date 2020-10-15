//
//  SLTabBarController.m
//  SLTransitioning_Example
//
//  Created by jocker luo on 2020/10/15.
//  Copyright © 2020 Jocker Luo. All rights reserved.
//

#import "SLTabBarController.h"
#import "SLViewController.h"
@interface SLTabBarController ()

@end

@implementation SLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = UIColor.redColor;
    self.tabBar.unselectedItemTintColor = UIColor.greenColor;
    self.tabBar.backgroundColor = UIColor.blueColor;

    [self setupChildViewController:[SLViewController new] title:@"0"];
    [self setupChildViewController:[UIViewController new] title:@"1"];
    [self setupChildViewController:[UIViewController new] title:@"2"];
}

- (void)setupChildViewController:(UIViewController *)childVC title:(NSString *)title {
    
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:@"find_def"];
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:@"find_sel"];
    
    [childVC.tabBarItem setImageInsets:UIEdgeInsetsMake(-30, 0, 0, 0)];

    UINavigationController *baseNaviVC = [[UINavigationController alloc] initWithRootViewController:childVC];
    [baseNaviVC willMoveToParentViewController:self];
    [self addChildViewController:baseNaviVC];
    [baseNaviVC didMoveToParentViewController:self];
}


@end
