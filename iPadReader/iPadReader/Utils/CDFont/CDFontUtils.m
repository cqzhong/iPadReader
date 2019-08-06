//
//  CDFontUtils.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/11.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDFontUtils.h"

NSUInteger const CDFontTag = 7101746;


//不用版本使用不同字体
UIFont * PingFangFontMediumSize(CGFloat size) {
    
//    if (IOS_VERSION >= 9.0) // PingFangSC-Regular
//        return [UIFont fontWithName:@"PingFang-SC-Medium" size:size];
//    NSString *fontPath = [MYBUNDLE pathForResource:@"DFGB_Y7" ofType:@"ttc"];
//    return [CDAppUtils customFontPath:fontPath fontSize:size];
    return [UIFont fontWithName:@"DFPYuanW7-GB" size:size];
}

UIFont * PingFangFontBoldSize(CGFloat size) {
    
//    if (IOS_VERSION >= 9.0)
//        return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    
//    NSString *fontPath = [MYBUNDLE pathForResource:@"DFGB_Y9" ofType:@"ttc"];
//    return [CDAppUtils customFontPath:fontPath fontSize:size];
    return [UIFont fontWithName:@"DFPYuanW9-GB" size:size];
}

UIFont * SystemFont(BOOL isBold,
                    CGFloat inch_9_7,
                    CGFloat inch_10_5,
                    CGFloat inch_12_9) {
    if (IS_97INCH_SCREEN) {
        
        return isBold ? PingFangFontBoldSize(inch_9_7) : PingFangFontMediumSize(inch_9_7);
    }
    if (IS_105INCH_SCREEN) {
        
        return isBold ? PingFangFontBoldSize(inch_10_5) : PingFangFontMediumSize(inch_10_5);
    }
    if (IS_129INCH_SCREEN) {
        
        return isBold ? PingFangFontBoldSize(inch_12_9) :  PingFangFontMediumSize(inch_12_9);
    }

    return isBold ? PingFangFontBoldSize(inch_9_7) :  PingFangFontMediumSize(inch_9_7);
}

//使用常规字体
UIFont * CDNormalSystemFont(CGFloat inch_9_7,
                          CGFloat inch_10_5,
                          CGFloat inch_12_9) {
    return SystemFont(NO, inch_9_7, inch_10_5, inch_12_9);
}

//使用加粗体
UIFont * CDBoldSystemFont(CGFloat inch_9_7,
                          CGFloat inch_10_5,
                          CGFloat inch_12_9) {
    return SystemFont(YES, inch_9_7, inch_10_5, inch_12_9);
}



