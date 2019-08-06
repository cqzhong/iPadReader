//
//  CDMacroDefine.h
//  CDCountdownTimerLabel
//
//  Created by cqz on 2019/3/7.
//  Copyright © 2019 ChangDao. All rights reserved.
//

#ifndef CDMacroDefine_h
#define CDMacroDefine_h



//#define IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define __MAIN_SCREEN_HEIGHT__      MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define __MAIN_SCREEN_WIDTH__       MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define __MAIN_SCREEN_BOUNDS__      [[UIScreen mainScreen] bounds]

#define  CDSCALE_W                 (IS_IPHONE ? (__MAIN_SCREEN_WIDTH__ / 375.0) : (__MAIN_SCREEN_WIDTH__ / 768.0))
#define  CDSCALE_H                 (IS_IPHONE ? (__MAIN_SCREEN_WIDTH__ / 375.0) : (__MAIN_SCREEN_HEIGHT__ / 1024.0))

#define  CDREALVALUE_WIDTH(w)      (CDSCALE_W * w)
#define  CDREALVALUE_HEIGHT(h)     (CDSCALE_H * h)

#define __CDLANDSCAPE_WIDTH(w)      (IS_IPHONE ? ((w/667.0)*__MAIN_SCREEN_HEIGHT__) : ((w/1024.0)*__MAIN_SCREEN_HEIGHT__))
#define __CDLANDSCAPE_HEIGHT(h)     (IS_IPHONE ? ((h/375.0)*__MAIN_SCREEN_WIDTH__) : ((h/768.0)*__MAIN_SCREEN_WIDTH__))


/// 操作系统版本号，只获取第二级的版本号，例如 10.3.1 只会得到 10.3
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] doubleValue])

#define CD_IS_IPHONE_X ((IOS_VERSION >= 11.f) && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))

// iPhone X 系类安全区域适配
#define SafeAreaTopHeight (CD_IS_IPHONE_X ? 88 : 64)
#define SafeAreaBottomHeight (CD_IS_IPHONE_X ? 34 : 0)
#define SafeAreaStatusHeight (CD_IS_IPHONE_X ? 24 : 0)



#if defined(DEBUG)
#define CDString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define CDDLog(...) printf("\n\n[文件名:%s] [函数名:%s] [第%d行: %s]\n\n", [CDString UTF8String] ,__FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define CDDLog(...);
#endif


#define CD_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
__REF = nil;\
}\
}

//view安全释放
#define CDVIEW_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF removeFromSuperview];\
__REF = nil;\
}\
}

//释放定时器
#define CD_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}

//阅读
#define READ_BOUNDS CGRectMake(0, 0, __CDLANDSCAPE_WIDTH(412.0), __CDLANDSCAPE_HEIGHT(552.0))
#define CDBookDownloadPath @"CDBookDownloadPath"
#define kDocuments [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true) firstObject]  stringByAppendingPathComponent:CDBookDownloadPath]
#define TextLine_Space  CDREALVALUE_WIDTH(5)

#define kReadNight  0.3
#define kReadDay    0.8


#define CDTHEME_COLOR  [QDThemeManager  sharedInstance].currentTheme.themeTintColor

#endif /* CDMacroDefine_h */
