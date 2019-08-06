//
//  CDReadSettings.h
//  iPad_Epub
//
//  Created by cqz on 2018/8/21.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDReadSettings : NSObject

+ (instancetype)manager;

@property (nonatomic, assign) double brightness;
@property (nonatomic, assign) BOOL isTraditional;
@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat fontSize;

@property (copy, nonatomic) void(^refreshReaderView)(void);
@property (copy, nonatomic) void(^refreshPageStyle)(void);

@property (nonatomic, strong, readonly) UIColor *textColor;
//其他如标题,电池,时间等
@property (nonatomic, strong, readonly) UIColor *otherTextColor;

@property (nonatomic, strong, readonly) NSDictionary *readerAttributes;

- (NSString *)transformToTraditionalWith:(NSString *)string;

@end
