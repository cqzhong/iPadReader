//
//  CDBookSQLiteManager.h
//  CDProgramme
//
//  Created by cqz on 2018/8/29.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDBookEpubModel, CDRecordModel, CDBookModel;

@interface CDBookSQLiteManager : NSObject

//只存书籍
@property (nonatomic, strong, readonly) YYDiskCache *cache;

//用户书架
@property (nonatomic, strong, readonly) NSMutableArray *userBooks;

+ (instancetype)manager;

//查询下载书籍
- (CDBookEpubModel *)accessToEpubBook:(NSString *)bookToken;
//存储书籍
- (void)setupStoreBooks:(CDBookEpubModel *)epubBookModel;
//退出登录调用
- (void)logOutOfLoginCleaningInformation;

//阅读记录
- (CDRecordModel *)accessToReadRecordModel:(NSString *)bookToken;

- (void)updateReadingRecordModel:(CDRecordModel *)recordModel;

//MARK: 更新用户书架
- (void)addUserBooksWithBookModel:(CDBookModel *)bookModel;
@end
