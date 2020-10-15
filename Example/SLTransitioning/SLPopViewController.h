//
//  SLPopViewController.h
//  SLTransitioning_Example
//
//  Created by jocker luo on 2020/10/15.
//  Copyright © 2020 Jocker Luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLTransitioning.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLPopViewController : UIViewController

@property (nonatomic, assign) SLPanDirectionType sourceDirection;
@property (nonatomic, assign) SLPanDirectionType popDirection;

@end

NS_ASSUME_NONNULL_END
