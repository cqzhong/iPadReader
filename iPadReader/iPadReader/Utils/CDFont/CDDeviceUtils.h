//
//  CDDeviceUtils.h
//  CDProgramme
//
//  Created by 庆中 on 2018/7/11.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_OPTIONS(NSUInteger, iPadType) {
//
//    iPadTypeiPad                      = 0,
//    iPadTypeiPad2                     = 1 << 0,
//    iPadTypeiPadMini                  = 1 << 1,
//    iPadTypeiPad3                     = 1 << 2,
//    iPadTypeiPad4                     = 1 << 3,
//    iPadTypeiPadAir                   = 1 << 4,
//    iPadTypeiPadMiniRetina            = 1 << 5,
//    iPadTypeiPadMini3                 = 1 << 6,
//    iPadTypeiPadMini4                 = 1 << 7,
//    iPadTypeiPadAir2                  = 1 << 8,
//    iPadTypeiPad5                     = 1 << 9,
//    iPadTypeiPadPro97inch             = 1 << 10,
//    iPadTypeiPadPro105inch            = 1 << 11,
//    iPadTypeiPadPro129inch            = 1 << 12,
//};

@interface CDDeviceUtils : NSObject

+ (BOOL)is97InchScreen;
+ (BOOL)is105InchScreen;
+ (BOOL)is129InchScreen;

+ (CGSize)screenSizeFor7997Inch;
+ (CGSize)screenSizeFor105Inch;
+ (CGSize)screenSizeFor129Inch;

@end
