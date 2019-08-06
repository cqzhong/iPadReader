//
//  CDAppUtils.h
//  CDProgramme
//
//  Created by 庆中 on 2018/7/2.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CDAppUtils : NSObject

/**
 应用 APPID
 
 @return com.changDao.upperFloor
 */
+ (NSString *)buldleID;

/**
 当前 build 版本号
 
 @return  build 版本号
 */
+ (NSString *)build;

/**
 获取app名字
 
 @return app名字
 */
+ (NSString *)appName;

/**
 当前软件版本号
 
 @return 版本号
 */
+ (NSString *)version;


/**
 验证手机号

 @param mobile 手机号码
 @return 手机号是否正确
 */
+ (BOOL)validateMobile:(NSString *)mobile;
//- 把时间转换成为分秒
+ (NSString*)timeFormatFromSeconds:(NSInteger)seconds;

/**
 判断是否为纯数字
 
 @param string 字符串
 @return 是纯数字 NO不是纯数字
 */
+ (BOOL)isPureInt:(NSString*)string;

/**
 启动页横屏
 */
+ (void)launchDeviceOrientationLandscapeRight;

/**
 获取UIWindow
 
 @return window
 */
+ (UIWindow *)appWindow;

/**
 使用UIBezierPath切角
 
 @param roundedRect 图形的frame
 @param rectCorner 需要切除的边角(上左下右)
 @param clipsSize 切除边角的大小
 @param dealView 需要切角的view
 */
+ (void)bezierPathWithRoundedRect:(CGRect) roundedRect
                       rectCorner:(UIRectCorner) rectCorner
                      cornerRadii:(CGSize)clipsSize
                         dealView:(UIView *)dealView;
/**
 *  获取icon
 */
+ (UIImage *)getAppIcon;

/**
 自定义字体

 @param path 字体路径
 @param fontSize 字体大小
 @return 获取字体
 */
+ (UIFont*)customFontPath:(NSString*)path fontSize:(CGFloat)fontSize;
/**
 字体不同屏幕变化
 
 @param fontSize 1024*768上字体大小
 @return 不同iPad屏幕字体大小
 */
UIFont *scaleFont(CGFloat fontSize);

/**
 转换为NSDate
 
 @param dateString 时间
 @param dateFormat 时间格式
 @return 返回时间Date
 */
+ (NSDate *)conversionDateFromDateString:(NSString *)dateString
                          withDateFormat:(NSString *)dateFormat;

/**
 设备信息
 @return 返回json字符串
 */
+ (NSString *)feedBackJsonString;

/**
 转NSData
 @return 返回时间Data
 */
+ (NSData *)toJSONDataString:(id)theData;



@end
