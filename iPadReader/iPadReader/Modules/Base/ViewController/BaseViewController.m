//
//  BaseViewController.m
//  FT_iPhone
//
//  Created by cqz on 2018/10/31.
//  Copyright © 2018 ChangDao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - Life Cycle Methods
- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - Intial Methods
- (void)initSubviews {
    [super initSubviews];
    
    [self setAutomaticallyAdjustsScrollViewInsets:false];
    //[self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    //[self.navigationController.navigationBar setTranslucent:true];
    [self.view setBackgroundColor:UIColorMakeWithHex(@"#F8F8F8")];
}
#pragma mark - Network Methods
- (void)loadData {
    
}

#pragma mark - Target Methods
- (void)rightButtonDidClickAction {
    
}
- (void)leftButtonDidClickAction {
    if ([self.navigationController.viewControllers count] >1) {
        
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }
}
- (void)loginButtonEvent {
    
    
    [self.emptyView.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_offset(30);
        make.width.mas_offset(120.0);
        make.top.equalTo(self.emptyView.imageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.emptyView);
    }];
}
#pragma mark - Public Methods
//MARK: 配置空状页
- (void)configEmptyImage:(UIImage *)image text:(NSString *)text  {
    
    [self showEmptyViewWithImage:image text:text detailText:nil buttonTitle:nil buttonAction:NULL];
    self.emptyView.textLabelInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.emptyView.textLabelTextColor = UIColorMakeWithHex(@"#8C8E91");
    self.emptyView.textLabelFont = CDUIFontMake(13.0);
    self.emptyView.verticalOffset = CDREALVALUE_HEIGHT(-80.0);
    [self hideEmptyView];
}
- (void)configEmptyText:(NSString *)text  {
    
    [self showEmptyViewWithImage:nil text:text detailText:nil buttonTitle:nil buttonAction:NULL];
    self.emptyView.textLabelInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.emptyView.textLabelTextColor = UIColorMakeWithHex(@"#8C8E91");
    self.emptyView.textLabelFont = CDUIFontMake(13.0);
    self.emptyView.verticalOffset = CDREALVALUE_HEIGHT(-80.0);
    [self hideEmptyView];
}
- (void)configLoginEmpty {
    
}
- (void)showHideAnAttempt:(NSArray *)array withParentView:(UIView *)view {
    if ([array count] == 0) {
        [self showEmptyView];
        if (view) [view addSubview:self.emptyView];
    } else {
        [self hideEmptyView];
    }
}
//MARK:pop 到指定类的控制器
- (void)popToControllerClass:(Class)className {
    
    NSMutableArray <UIViewController *>*array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    __block UIViewController *popToVC = nil;
    [array enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:className]) {
            popToVC = obj;
            *stop = true;
        }
    }];
    if (!popToVC) {
        NSArray *viewControllers = @[array.firstObject,[[className alloc] init]];
        [self.navigationController setViewControllers:viewControllers animated:YES];
    } else {
        [self.navigationController popToViewController:popToVC animated:YES];
    }
}
//MARK: 是否是顶层试图
- (BOOL)isTopViewController {
    if ([[QMUIHelper visibleViewController] isKindOfClass:[self class]]) {
        
        return true;
    }
    return false;
}

- (void)configNavigationBar:(UINavigationBar *)navigationBar {
    
}

#pragma mark - Private Method
- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    [self configNavigationBar:self.navigationController.navigationBar];
}
- (void)setupNavigationBarButtonItem:(CDNavigationBarStatus)btnStatus
                               title:(NSString *)title
                                 img:(NSString *)imgName {
    SEL selectorName = (btnStatus == CDNavigationBarStatusLeft) ? @selector(leftButtonDidClickAction) : @selector(rightButtonDidClickAction);
    
    if (title.length > 0) {
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:selectorName];
        [btnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:CDUIFontMake(16.f),NSFontAttributeName,nil] forState:UIControlStateNormal];
        
        [self accordingWithNaviBarBtn:btnStatus withBarButtonItem:btnItem];
    } else if (imgName.length > 0) {
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:UIImageMake(imgName) style:UIBarButtonItemStyleDone target:self action:selectorName];
        
        [self accordingWithNaviBarBtn:btnStatus withBarButtonItem:btnItem];
    }
    //去除导航栏返回按钮中的文字
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100)
    //                                                         forBarMetrics:UIBarMetricsDefault];
}
- (void)accordingWithNaviBarBtn:(CDNavigationBarStatus)btnStatus
              withBarButtonItem:(UIBarButtonItem *)btnItem {
    
    if (btnStatus == CDNavigationBarStatusLeft) {
        [self.navigationItem setLeftBarButtonItem:btnItem];
    } else {
        [self.navigationItem setRightBarButtonItem:btnItem];
    }
}

#pragma mark - External Delegate
#pragma mark - QMUINavigationControllerDelegate
- (UIColor *)navigationBarTintColor {
    
    return NavBarTintColor;
}
//- (BOOL)shouldSetStatusBarStyleLight {
//    return false;
//}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return true;
}
- (BOOL)preferredNavigationBarHidden {
    return false;
}
- (UIImage *)navigationBarShadowImage {
    return [self navigationBarCuttingLine] ? [UIImage imageWithColor:UIColorMakeWithHex(@"#EFEFEF") size:CGSizeMake(SCREEN_WIDTH, 1)] : [UIImage new];
}
- (BOOL)navigationBarCuttingLine {
    return false;
}
// 是否允许手动滑回 @return true 是、 false否
- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return true;
}

/**
 info.plist文件中，View controller-based status bar appearance项设为YES，
 则View controller对status bar的设置优先级高于application的设置。
 为NO则以application的设置为准，view controller的prefersStatusBarHidden方法无效，是根本不会被调用的。
 
 @return true false
 */
- (BOOL)prefersStatusBarHidden {
    return false;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

//MARK: 屏幕
- (BOOL)shouldAutorotate {
    return true;
}
- (UIInterfaceOrientationMask)supportedOrientationMask {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Setter Getter Methods

@end
