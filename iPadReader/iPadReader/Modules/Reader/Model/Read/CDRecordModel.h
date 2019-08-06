//
//  CDRecordModel.h
//  CDProgramme
//
//  Created by cqz on 2018/8/28.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDBaseModel.h"
@class CDChapterModel;
@interface CDRecordModel : CDBaseModel

@property (nonatomic, copy, readonly) NSString * bookToken;

////阅读到书的总页数的第几页
//@property (nonatomic, assign) NSUInteger *readingPage;

//阅读的章节数
@property (nonatomic) NSUInteger readingChapter;

//阅读到章节的第几页
@property (nonatomic) NSUInteger readingChapterPage;

//总章节数
@property (nonatomic) NSUInteger chapterCount;

//是否阅读完成
@property (nonatomic, assign) BOOL isFinished;

//阅读时长
@property (nonatomic, assign) NSUInteger readTime;


@property (nonatomic, copy, readonly) NSString *readTimeString;

- (instancetype)initWithBookToken:(NSString *)bookToken withAllChapters:(NSUInteger)chapters;
@end
