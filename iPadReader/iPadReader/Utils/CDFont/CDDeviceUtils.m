//
//  CDDeviceUtils.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/11.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDDeviceUtils.h"

@implementation CDDeviceUtils

static NSInteger is97InchScreen = -1;
+ (BOOL)is97InchScreen {
    if (is97InchScreen < 0) {
        is97InchScreen = (__MAIN_SCREEN_WIDTH__ == self.screenSizeFor7997Inch.width && __MAIN_SCREEN_HEIGHT__ == self.screenSizeFor7997Inch.height) ? 1 : 0;
    }
    return is97InchScreen > 0;
}

static NSInteger is105InchScreen = -1;
+ (BOOL)is105InchScreen {
    if (is105InchScreen < 0) {
        is105InchScreen = (__MAIN_SCREEN_WIDTH__ == self.screenSizeFor105Inch.width && __MAIN_SCREEN_HEIGHT__ == self.screenSizeFor105Inch.height) ? 1 : 0;
    }
    return is105InchScreen > 0;
}

static NSInteger is129InchScreen = -1;
+ (BOOL)is129InchScreen {
    if (is129InchScreen < 0) {
        is129InchScreen = (__MAIN_SCREEN_WIDTH__ == self.screenSizeFor129Inch.width && __MAIN_SCREEN_HEIGHT__ == self.screenSizeFor129Inch.height) ? 1 : 0;
    }
    return is105InchScreen > 0;
}

//MARK: 屏幕尺寸
+ (CGSize)screenSizeFor7997Inch {
    return CGSizeMake(768, 1024);
}

+ (CGSize)screenSizeFor105Inch {
    return CGSizeMake(834, 1112);
}

+ (CGSize)screenSizeFor129Inch {
    return CGSizeMake(1024, 1366);
}
@end
