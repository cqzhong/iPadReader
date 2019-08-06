//
//  DZMATViewController.m
//  DZMAnimatedTransitioning
//
//  Created by 邓泽淼 on 2017/12/20.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#import "DZMATViewController.h"

@interface DZMATViewController ()

@property (nonatomic, assign) BOOL isAT;

@end

@implementation DZMATViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (self.isAT) {
        
        return [[DZMAnimatedTransitioning alloc] initWithOperation:operation];
    }
    
    return nil;
}

@end
