//
//  CDToastService.h
//  CDProgramme
//
//  Created by 庆中 on 2018/7/3.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CDToastPosition) {
    
    //显示位置在上层
    CDToastViewPositionTop = 0,
    //显示位置在中间
    CDToastViewPositionCenter = 1,
    //显示位置在底部
    CDToastViewPositionBottom = 2
};

@interface CDToastService : UIWindow

+ (void)showToast:(NSString *)toast;
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString;

+ (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString hideAfterDelay:(NSTimeInterval)delay;


+ (void)showToast:(NSString *)toast withPosition:(CDToastPosition)position;
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString withPosition:(CDToastPosition)position;

+ (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withPosition:(CDToastPosition)position;
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString hideAfterDelay:(NSTimeInterval)delay withPosition:(CDToastPosition)position;

@end
