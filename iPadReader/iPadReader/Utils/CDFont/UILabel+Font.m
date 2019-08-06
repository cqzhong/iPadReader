//
//  UILabel+Font.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/11.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "UILabel+Font.h"

@implementation UILabel (Font)
+ (void)load{
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(fontInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)fontInitWithCoder:(NSCoder *)aDecode{
    
    [self fontInitWithCoder:aDecode];
    if (self) {
        
        if (self.tag != CDFontTag) {

//            NSLog(@"打印字体： text：%@ fontName: %@", self.text, self.font.fontName);

            CGFloat fontSize = self.font.pointSize;
            if ([self.font.fontName isEqualToString:@"PingFangSC-Semibold"] ||
                [self.font.fontName isEqualToString:@".SFUIDisplay-Bold"]) {
                
                self.font = CDUIFontBoldMake(fontSize);
            } else {
                
                self.font = CDUIFontMake(fontSize);
            }
        }
    }
    return self;
}
@end
