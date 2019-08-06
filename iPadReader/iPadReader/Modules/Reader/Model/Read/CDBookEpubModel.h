//
//  CDBookEpubModel.h
//  iPad_Epub
//
//  Created by cqz on 2018/8/21.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDChapterModel.h"

@interface CDBookEpubModel : CDBaseModel

@property (nonatomic, copy) NSString * bookToken;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSURL *resource;
@property (nonatomic, assign) ReadFileType fileType;

@property (nonatomic, strong) NSMutableArray <CDChapterModel *>*chapters;

//服务器记录
@property (nonatomic , assign) NSUInteger              finish_time;
@property (nonatomic , assign) BOOL              finished;


//书的总页数
@property (nonatomic, assign) NSUInteger pages;

-(instancetype)initWithContent:(NSString *)content;
-(instancetype)initWithePub:(NSString *)ePubPath;

+(id)getLocalModelWithURL:(NSURL *)url;
//更新存储记录
+(void)updateLocalModel:(CDBookEpubModel *)readModel url:(NSURL *)url;

//- (void)updateReadingChapter:(NSUInteger)chapter page:(NSUInteger)page;

@end
