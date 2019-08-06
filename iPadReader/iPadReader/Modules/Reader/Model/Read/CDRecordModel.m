//
//  CDRecordModel.m
//  CDProgramme
//
//  Created by cqz on 2018/8/28.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDRecordModel.h"
#import "CDChapterModel.h"

@interface CDRecordModel ()

@property (nonatomic, copy, readwrite) NSString * bookToken;
@property (nonatomic, copy, readwrite) NSString *readTimeString;

@end

@implementation CDRecordModel

- (instancetype)initWithBookToken:(NSString *)bookToken withAllChapters:(NSUInteger)chapters {
    if (self = [super init]) {
        
        self.bookToken = bookToken;
        self.chapterCount = chapters;
        
        self.readingChapter = 0;
        self.readingChapterPage = 0;
        
        self.isFinished = false;
        self.readTime = 0;
    }
    return self;
}


- (void)setReadTime:(NSUInteger)readTime {
    _readTime = readTime;
    
    self.readTimeString = [self timeFormatFromSeconds:readTime];
}

//MARK: - 把时间转换成为分秒
- (NSString*)timeFormatFromSeconds:(NSInteger)seconds {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat"
    
    NSUInteger hours = seconds/3600;
    NSUInteger minute = (seconds%3600)/60;
    NSUInteger second = seconds%60;
    
    NSMutableString *tmp = [[NSMutableString alloc] init];
    
    if (hours > 0) {
        [tmp appendString:[NSString stringWithFormat:@"%ld小时", hours]];
    }
    
    if (minute > 0 || hours > 0) {
        [tmp appendString:[NSString stringWithFormat:@"%ld分钟", minute]];
    }
    
    if (second > 0 || minute > 0 || hours > 0) {
        [tmp appendString:[NSString stringWithFormat:@"%ld秒", second]];
    }

    NSString *format_time = [NSString stringWithFormat:@"阅读了%@",tmp];
    return format_time;
    
#pragma clang diagnostic pop
}


//- (void)jk_setWithCoder:(NSCoder *)aDecoder {
//    [super jk_setWithCoder:aDecoder];
//}
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [super encodeWithCoder:aCoder];
//}

@end
