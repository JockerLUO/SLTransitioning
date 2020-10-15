//
//  UIView+SLTransitioning.h
//  test
//
//  Created by jocker luo on 2020/9/26.
//  Copyright © 2020 jocker luo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SLTransitioning)

@property CGPoint sl_position;
@property CGFloat sl_x;
@property CGFloat sl_y;
@property CGFloat sl_top;
@property CGFloat sl_bottom;
@property CGFloat sl_left;
@property CGFloat sl_right;
@property CGFloat sl_centerX;
@property CGFloat sl_centerY;
@property CGFloat sl_width;
@property CGFloat sl_height;
@property CGPoint sl_origin;
@property CGSize sl_size;

@end

NS_ASSUME_NONNULL_END
