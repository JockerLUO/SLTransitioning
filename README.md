# SLTransitioning

[![Version](https://img.shields.io/cocoapods/v/SLTransitioning.svg?style=flat)](https://cocoapods.org/pods/SLTransitioning)
[![License](https://img.shields.io/cocoapods/l/SLTransitioning.svg?style=flat)](https://cocoapods.org/pods/SLTransitioning)
[![Platform](https://img.shields.io/cocoapods/p/SLTransitioning.svg?style=flat)](https://cocoapods.org/pods/SLTransitioning)

## Example

这是一个对转场动画进行封装的框架，可以快速便捷的自定义各种转场动画。
#####通过手势转场

```
[self sl_registerPushTransition:^UIViewController * _Nullable(SLPanDirectionType pushDirection) {
    UIViewController *vc = nil;
     if (pushDirection != SLPanDirectionTypeUnknow) {
         SLPopViewController *pushVC = [SLPopViewController new];
         pushVC.sourceDirection = pushDirection;
         pushVC.hidesBottomBarWhenPushed = YES;
         vc = pushVC;
     }
    return vc;
}];
```
```
[self sl_registerPopTransition:^BOOL(SLPanDirectionType popDirection) {
    return popDirection == SLPanDirectionTypeDown;
}];
```

#####自定义转场方向
```
self.transitioningDelegate = self.transitionAnimator;
self.navigationController.delegate = self.transitionAnimator;
SLInteractiveTransitionModel *model = self.transitionAnimator.pushInteractiveTransition.model;
model.animatedDirection = SLPanDirectionTypeLeft;
[self.navigationController pushViewController:vc animated:YES];
```
更多转场配置请参看 SLInteractiveTransitionModel.h

## Installation

```ruby
`pod 'SLTransitioning', :git => 'https://github.com/JockerLUO/SLTransitioning.git'`
```

## Author

Jocker Luo, 15969574989@163.com

## License

SLTransitioning is available under the MIT license. See the LICENSE file for more info.
