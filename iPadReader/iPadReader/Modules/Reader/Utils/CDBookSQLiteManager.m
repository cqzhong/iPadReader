//
//  CDBookSQLiteManager.m
//  CDProgramme
//
//  Created by cqz on 2018/8/29.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDBookSQLiteManager.h"

//models
#import "CDBookEpubModel.h"
#import "CDRecordModel.h"
#import "CDBookModel.h"

#define CDBookSqlitePath @"CDBookSqlitePath"

#define CDBookRecordPath @"CDBookRecordPath"

#define CDUserBookKey @"CDUserBookKey"


@interface CDBookSQLiteManager ()

@property (nonatomic, strong) YYDiskCache *cache;
@property (nonatomic, copy) NSString *booksFolder;

@property (nonatomic, copy) NSString *recordPathFolder;

//每个用户的阅读记录文件夹
@property (nonatomic, strong) YYDiskCache *userRecordCache;
@property (nonatomic, copy) NSString *userRecordPath;

//用户书架
@property (nonatomic, strong, readwrite) NSMutableArray *userBooks;

@end

@implementation CDBookSQLiteManager

+ (instancetype)manager {
    static CDBookSQLiteManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCache];
    }
    return self;
}
- (void)setupCache {
    
    self.recordPathFolder = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true) firstObject]  stringByAppendingPathComponent:CDBookRecordPath];

    self.booksFolder = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true) firstObject] stringByAppendingPathComponent:CDBookSqlitePath];
    
}
- (void)logOutOfLoginCleaningInformation {
    
    _userRecordCache = nil;
    _userRecordPath = nil;
    
    [_userBooks removeAllObjects];
    _userBooks = nil;
//    _recordModel = nil;
}
//查询下载书籍
- (CDBookEpubModel *)accessToEpubBook:(NSString *)bookToken {
    
    CDBookEpubModel *epubBookModel = (CDBookEpubModel *)[self.cache objectForKey:bookToken];
    return epubBookModel;
}
//存储书籍
- (void)setupStoreBooks:(CDBookEpubModel *)epubBookModel {
    
    [self.cache setObject:epubBookModel forKey:epubBookModel.bookToken withBlock:^{
        
        CDDLog(@"存储书籍完成bookToken：%@", epubBookModel.bookToken);
    }];
}

//MARK: 阅读记录
- (CDRecordModel *)accessToReadRecordModel:(NSString *)bookToken {
        
    if (self.userRecordCache == nil) {
        
        self.userRecordCache = [[YYDiskCache alloc] initWithPath:self.userRecordPath];
    }

    CDRecordModel *recordModel = (CDRecordModel *)[self.userRecordCache objectForKey:bookToken];
    return recordModel;
}

- (void)updateReadingRecordModel:(CDRecordModel *)recordModel {
    
    if (recordModel) {
        [self.userRecordCache setObject:recordModel forKey:recordModel.bookToken];
    }
}

//MARK: 更新用户书架
- (void)addUserBooksWithBookModel:(CDBookModel *)bookModel {
    
    if (self.userRecordCache == nil)
        self.userRecordCache = [[YYDiskCache alloc] initWithPath:self.userRecordPath];
    
    if (![self.userRecordCache containsObjectForKey:bookModel.bookToken]) {
        
        [self.userBooks addObject:bookModel];
        [self.userRecordCache setObject:self.userBooks forKey:CDUserBookKey withBlock:^{
            CDDLog(@"更新用户书架成功");
        }];
    }
}
//MARK: 懒加载
- (YYDiskCache *)cache {
    if (!_cache) {
        _cache = [[YYDiskCache alloc] initWithPath:self.booksFolder];
        _cache.ageLimit = MAXFLOAT;
        _cache.autoTrimInterval = MAXFLOAT;
        _cache.errorLogsEnabled = true;
    }
    return _cache;
}
- (NSString *)userRecordPath {

    return @"QWERZXCV123"; //用户uid
}
- (NSMutableArray *)userBooks {
    if (!_userBooks) {
        NSArray *arr = @[];
        if (self.userRecordCache == nil) {
            
            self.userRecordCache = [[YYDiskCache alloc] initWithPath:self.userRecordPath];
            arr = (NSArray *)[self.cache objectForKey:CDUserBookKey];
        }
        _userBooks = [NSMutableArray arrayWithObjects:arr, nil];
    }
    return _userBooks;
}
@end
