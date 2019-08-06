//
//  CDFontUtils.h
//  CDProgramme
//
//  Created by 庆中 on 2018/7/11.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDDeviceUtils.h"

// 设备屏幕尺寸
// iPad 7.9, 9.7
#define IS_97INCH_SCREEN [CDDeviceUtils is97InchScreen]
// iPad 10.5
#define IS_105INCH_SCREEN [CDDeviceUtils is105InchScreen]
// iPad 12.9
#define IS_129INCH_SCREEN [CDDeviceUtils is129InchScreen]

#define CDSIZE_SCALE   ((__MAIN_SCREEN_WIDTH__ > 768.0) ? __MAIN_SCREEN_WIDTH__/768.0 : 1)

#define CDCHANGE_SIZE(size)  (CDSIZE_SCALE * size)

//当使用xib时候，如果不想根据屏幕改变字体大小就设置tag为
FOUNDATION_EXPORT NSUInteger const CDFontTag;

/**
 *  正常系统字体
 */
FOUNDATION_EXTERN UIFont * CDNormalSystemFont(CGFloat inch_9_7,
                                            CGFloat inch_10_5,
                                            CGFloat inch_12_9);

/**
 *  粗体
 */
FOUNDATION_EXTERN UIFont * CDBoldSystemFont(CGFloat inch_9_7,
                                            CGFloat inch_10_5,
                                            CGFloat inch_12_9);

#define CDUIFontMake(font)           CDNormalSystemFont(font, (font + 1), (font + 2))
#define CDUIFontBoldMake(font)       CDBoldSystemFont(font, (font + 1), (font + 2))
