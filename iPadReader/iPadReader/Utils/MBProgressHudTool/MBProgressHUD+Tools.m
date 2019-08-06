//
//  MBProgressHUD+Tools.m
//  ZhouDao
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import "MBProgressHUD+Tools.h"

@implementation MBProgressHUD (Tools)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    
    if (view == nil) view = [CDAppUtils appWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon")];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = true;
    // 3秒之后再消失
    [hud hideAnimated:YES afterDelay:3.f];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view {
   
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self show:error icon:@"QMUI_tips_error" view:view];
        });
    });
}

#pragma mark 显示成功信息
+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self show:success icon:@"QMUI_tips_done" view:view];
        });
    });
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [CDAppUtils appWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = true;
    return hud;
}

+ (void)showSuccess:(NSString *)success {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUDForView:nil];

        [self showSuccess:success toView:nil];
    });
}

+ (void)showError:(NSString *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self hideHUDForView:nil];

        [self showError:error toView:nil];
    });
}

+ (MBProgressHUD *)showMessage:(NSString *)message {
    
  return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view {
    
    if (view == nil) view = [CDAppUtils appWindow];
    
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self hideHUDForView:nil];
    });
}
+ (void)showMBLoadingWithText:(NSString *)textString {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self hideHUDForView:nil];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[CDAppUtils appWindow] animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = textString;// (textString.length == 0)?@"正在加载":textString;
    });
}

@end
