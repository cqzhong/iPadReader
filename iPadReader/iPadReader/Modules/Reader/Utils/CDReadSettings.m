//
//  CDReadSettings.m
//  iPad_Epub
//
//  Created by cqz on 2018/8/21.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDReadSettings.h"

#define kFontSizeMax 30.0
#define kFontSizeMin 13.0


@interface CDReadSettings ()

@property (nonatomic, assign) BOOL needUpdateAttributes;
@property (nonatomic, strong) NSDictionary *readerAttributes;

@property (strong, nonatomic) NSString *simplifiedStr;
@property (strong, nonatomic) NSString *traditionalStr;
@end

@implementation CDReadSettings

+ (instancetype)manager {
    static CDReadSettings *setting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[self alloc] init];
    });
    return setting;
}

//忽略属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"textColor",@"pageImage",@"readerAttributes",@"needUpdateAttributes",@"cover",@"idField"];
}

- (instancetype)init {
    if (self = [super init]) {
        
        _isTraditional = false;
        _lineSpacing = 20.0f;
        
        _fontSize = 16.f;

        _font = CDUIFontMake(_fontSize);
        
        _textColor = UIColorMakeWithHex(@"#333333");
        _otherTextColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark - Set

- (void)setFontSize:(CGFloat)fontSize {
    if (fontSize >= kFontSizeMin && fontSize <= kFontSizeMax) {
        _fontSize = fontSize;
        _font = CDUIFontMake(_fontSize);
        _needUpdateAttributes = true;
        [self updateReaderSettings];
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    _needUpdateAttributes = YES;
    [self updateReaderSettings];
}

- (void)setIsTraditional:(BOOL)isTraditional {
    _isTraditional = isTraditional;
    [self updateReaderSettings];
}

- (void)updateReaderSettings {
    if (self.refreshReaderView) {
        self.refreshReaderView();
    }
}

- (NSString *)transformToTraditionalWith:(NSString *)string {
    NSMutableString *mutableStr = string.mutableCopy;
    NSInteger length = [string length];
    for (NSInteger i = 0; i< length; i++) {
        NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
        NSRange gbRange = [self.simplifiedStr rangeOfString:str];
        if(gbRange.location != NSNotFound) {
            NSString *tString = [self.traditionalStr substringWithRange:gbRange];
            [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:tString];
        }
    }
    return mutableStr.copy;
}
- (NSString *)simplifiedStr {
    if (!_simplifiedStr) {
        _simplifiedStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"simplified" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    }
    return _simplifiedStr;
}

- (NSString *)traditionalStr {
    if (!_traditionalStr) {
        _traditionalStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"traditional" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    }
    return _traditionalStr;
}

- (NSDictionary *)readerAttributes {
    if (!_needUpdateAttributes && _readerAttributes) {
        return _readerAttributes;
    }
    _needUpdateAttributes = NO;
    NSMutableDictionary *dic = @{}.mutableCopy;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = self.lineSpacing;
    //这种方式两个字符位置更加准确,但是每一页的开始也会空格,但是这不一定是段落的开始
    //    paragraphStyle.firstLineHeadIndent = [@"汉字" boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:NULL].size.width;
    dic[NSForegroundColorAttributeName] = self.textColor;
    dic[NSFontAttributeName] = self.font;
    dic[NSParagraphStyleAttributeName] = paragraphStyle;
    _readerAttributes = dic.copy;
    return _readerAttributes;
}

@end
