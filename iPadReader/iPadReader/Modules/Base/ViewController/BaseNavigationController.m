//
//  BaseNavigationController.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/3.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - Intial Methods

#pragma mark - Target Methods

#pragma mark - Public Methods

#pragma mark - Private Method

- (UIViewController *)popViewControllerAnimated:(BOOL)animated  {
    
    UIViewController *viewController = [super popViewControllerAnimated:animated];

    return viewController;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}

//- (BOOL)isViewControllerTransiting {
//    // 如果配置表里这个开关关闭，则为了使 isViewControllerTransiting 功能失效，强制返回 NO
//    if (!PreventConcurrentNavigationControllerTransitions) {
//        return NO;
//    }
//    return _isViewControllerTransiting;
//}

#pragma mark - External Delegate

#pragma mark - Setter Getter Methods


@end
