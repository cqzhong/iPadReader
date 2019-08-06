//
//  UINavigationController+DZM.m
//  DZMAnimatedTransitioning
//
//  Created by 邓泽淼 on 2017/12/21.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#import "UINavigationController+DZM.h"
#import "DZMATViewController.h"

@implementation UINavigationController (DZM)

- (void)pushATViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //去除安全拦截
    QMUICMI.preventConcurrentNavigationControllerTransitions = false;

    if ([viewController isKindOfClass:[DZMATViewController class]]) {

        [viewController setValue:[NSNumber numberWithBool:YES] forKey:@"isAT"];
        
        self.delegate = (id<UINavigationControllerDelegate>)viewController;
    }
    [self pushViewController:viewController animated:animated];
}

@end
