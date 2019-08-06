//
//  CDAppUtils.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/2.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDAppUtils.h"


@implementation CDAppUtils

+ (NSString *)version
{
    NSString *obj = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@",obj];
}

+ (NSString *)buldleID
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    return bundleIdentifier;
}

+ (NSString *)build
{
    NSString *obj =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@",obj];
}

+ (NSString *)appName {
    
    NSString *obj =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return [NSString stringWithFormat:@"%@",obj];
}
+ (BOOL)validateMobile:(NSString *)mobile {
    
    if (mobile.length != 11) return false;
    
    NSString *phoneRegex = @"^1[3|4|5|6|7|8|9][0-9]\\d{8}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phonePredicate evaluateWithObject:mobile];
}
//MARK: - 把时间转换成为分秒
+ (NSString*)timeFormatFromSeconds:(NSInteger)seconds {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat"

    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
    
#pragma clang diagnostic pop
}

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
//MARK: 启动页横屏
+ (void)launchDeviceOrientationLandscapeRight {
    
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarOrientation:)]){
//        
//        SEL selector = NSSelectorFromString(@"setStatusBarOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIApplication instanceMethodSignatureForSelector:selector]];
//        UIDeviceOrientation orentation = UIDeviceOrientationLandscapeRight;
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIApplication sharedApplication]];
//        [invocation setArgument:&orentation atIndex:2];
//        [invocation invoke];
//    }
}
//MARK: -获取icon
+ (UIImage *)getAppIcon {
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSArray *arrayM = [infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"];
    
    NSString *icon = [arrayM lastObject];
    return [UIImage imageNamed:icon];
}

//MARK: 获取UIWindow
+ (UIWindow *)appWindow {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

+ (void)bezierPathWithRoundedRect:(CGRect) roundedRect
                       rectCorner:(UIRectCorner) rectCorner
                      cornerRadii:(CGSize)clipsSize
                         dealView:(UIView *)dealView {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIBezierPath *maskPath      = [UIBezierPath bezierPathWithRoundedRect:roundedRect byRoundingCorners:rectCorner cornerRadii:clipsSize];
        CAShapeLayer *shapelayer    = [[CAShapeLayer alloc] init];

        dispatch_async(dispatch_get_main_queue(), ^{

            shapelayer.frame            = roundedRect;
            shapelayer.path             = maskPath.CGPath;
            dealView.layer.mask         = shapelayer;
        });
    });
}
         
///MARK: -获取字体路径
+ (UIFont*)customFontPath:(NSString*)path fontSize:(CGFloat)fontSize {
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    CGFontRelease(fontRef);
    return font;
}
UIFont *scaleFont(CGFloat fontSize) {
    if (IS_IPAD && (DEVICE_WIDTH == 834)) {
        return [UIFont systemFontOfSize:fontSize + 1];
    } else if (IS_IPAD && (DEVICE_WIDTH == 1024)) {
        return [UIFont systemFontOfSize:fontSize + 2];
    } else {
        return [UIFont systemFontOfSize:fontSize];
    }
}

+ (NSDate *)conversionDateFromDateString:(NSString *)dateString withDateFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//MARK: 问题反馈json信息
+ (NSString *)feedBackJsonString {
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *dimensionString = [NSString stringWithFormat:@"%.0f*%.0f",SCREEN_WIDTH,SCREEN_HEIGHT];
    
    NSDictionary *deviceDict = @{@"Platform":@"iOS", @"SystemVersion":currentDevice.systemVersion, @"Model":currentDevice.machineModel, @"AppVersion":[CDAppUtils version], @"Size":dimensionString};
    NSString *deviceJsonString = [[NSString alloc] initWithData:[CDAppUtils toJSONDataString: deviceDict] encoding:NSUTF8StringEncoding];
    return deviceJsonString;
}
+ (NSData *)toJSONDataString:(id)theData {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error: &error];
    if ( error == nil){
        return jsonData;
    }else{
        return nil;
    }
}
@end
