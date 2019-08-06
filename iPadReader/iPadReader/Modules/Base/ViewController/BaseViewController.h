//
//  BaseViewController.h
//  FT_iPhone
//
//  Created by cqz on 2018/10/31.
//  Copyright © 2018 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, CDNavigationBarStatus) {
    
    CDNavigationBarStatusLeft,
    CDNavigationBarStatusRight
};

@interface BaseViewController : QMUICommonViewController

/**
 
 配置空状页
 */
- (void)configEmptyImage:(UIImage *)image text:(NSString *)text NS_REQUIRES_SUPER;
- (void)configEmptyText:(NSString *)text;
- (void)configLoginEmpty;

- (void)showHideAnAttempt:(NSArray *)array withParentView:(UIView *)view NS_REQUIRES_SUPER;
/**
 pop 到指定类的控制器
 如果找不到，直接 pop dao 跟控制器，然后通过 className 创建一个新的控制器 push 进去
 @param className 类
 */
- (void)popToControllerClass:(Class)className;


/**
 设置导航左右按钮
 
 @param btnStatus 左右按钮
 @param title 标题
 @param imgName 图片名字
 */
- (void)setupNavigationBarButtonItem:(CDNavigationBarStatus)btnStatus
                               title:(NSString *)title
                                 img:(NSString *)imgName;

- (void)rightButtonDidClickAction;

- (void)leftButtonDidClickAction;

/**
 是否是顶层试图
 
 @return true:是， false:否
 */
- (BOOL)isTopViewController;
/**
 配置导航栏
 
 @param navigationBar 导航栏
 */
- (void)configNavigationBar:(UINavigationBar *)navigationBar;



@end
