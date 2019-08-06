//
//  UIButton+Font.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/11.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "UIButton+Font.h"

@implementation UIButton (Font)

+ (void)load{

    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(fontInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)fontInitWithCoder:(NSCoder *)aDecode{
    
    [self fontInitWithCoder:aDecode];
    if (self) {
        if (self.tag != CDFontTag) {
            
//            NSLog(@"打印字体： familyName：%@ fontName: %@", self.titleLabel.font.familyName, self.titleLabel.font.fontName);

            CGFloat fontSize = self.titleLabel.font.pointSize;
            
            if ([self.titleLabel.font.fontName isEqualToString:@"PingFangSC-Semibold"]) {

                self.titleLabel.font = CDUIFontBoldMake(fontSize);
            } else {
                self.titleLabel.font = CDUIFontMake(fontSize);
            }
        }
    }
    return self;
}

@end
