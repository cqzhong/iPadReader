//
//  CDChapterModel.h
//  iPad_Epub
//
//  Created by cqz on 2018/8/21.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDBaseModel.h"

typedef  NS_ENUM(NSInteger, ReadFileType){

    ReadFileTypeTxt = 0, //纯文本
    ReadFileTypeEpub = 1 //epub
};

@interface CDChapterModel : CDBaseModel

@property (nonatomic, assign) ReadFileType fileType;
@property (nonatomic, assign) NSUInteger pageCount;
//本章开始在全书的第几页
@property (nonatomic, assign) NSUInteger startBookPage;

//txt
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *txtBody;
@property (nonatomic, strong) NSMutableArray *pageMutaArray;
@property (nonatomic, copy) NSMutableAttributedString *attributedString;


//Epub
@property (nonatomic, copy) NSString *filePath;
- (void)pageingEpubLayoutFrame;
- (NSAttributedString *)getEpubAttributedString:(NSUInteger)page;


-(void)updateContentPagingFont;
- (NSAttributedString *)getStringWith:(NSUInteger)page;


+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title;

@end
