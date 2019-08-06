//
//  UINavigationController+DZM.h
//  DZMAnimatedTransitioning
//
//  Created by 邓泽淼 on 2017/12/21.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (DZM)

/// 执行转场动画
- (void)pushATViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
