//
//  CDBookEpubModel.m
//  iPad_Epub
//
//  Created by cqz on 2018/8/21.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDBookEpubModel.h"
#import "CDReaderUtils.h"

@interface CDBookEpubModel ()


@end

@implementation CDBookEpubModel

//纯文本
-(instancetype)initWithContent:(NSString *)content {
    
    self = [super init];
    if (self) {
        _content = content;
        NSMutableArray *charpter = [NSMutableArray array];
        _pages = [CDReaderUtils separateChapter:&charpter content:content];
        _chapters = charpter;
        _fileType = ReadFileTypeTxt;
    }
    return self;
}
//epub
-(instancetype)initWithePub:(NSString *)ePubPath {
    
    self = [super init];
    if (self) {
        NSMutableArray *arrayM = [CDReaderUtils ePubFileHandle:ePubPath];
        _chapters = [arrayM firstObject];
        _pages = [[arrayM lastObject] integerValue];
        _fileType = ReadFileTypeEpub;
    }
    return self;
}

//MARK: -解析下载的书籍
+(id)getLocalModelWithURL:(NSURL *)url {
    
    NSString *key = [url.path lastPathComponent];
    
    if ([[key pathExtension] isEqualToString:@"txt"]) {
        
        CDBookEpubModel *model = [[CDBookEpubModel alloc] initWithContent:[CDReaderUtils encodeWithURL:url]];
        model.resource = url;
        [CDBookEpubModel updateLocalModel:model url:url];
        return model;
    } else if ([[key pathExtension] isEqualToString:@"epub"]){
        
        CDDLog(@"这是 epub电子书");
        CDBookEpubModel *model = [[CDBookEpubModel alloc] initWithePub:url.path];
        model.resource = url;
        [CDBookEpubModel updateLocalModel:model url:url];
        return model;
    } else {
        @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
    }
}

//MARK: -更新存储书籍内容 和 阅读记录
+(void)updateLocalModel:(CDBookEpubModel *)readModel url:(NSURL *)url {
    
    //    NSString *key = [url.path lastPathComponent];
    //存储
}



//- (void)jk_setWithCoder:(NSCoder *)aDecoder {
//    [super jk_setWithCoder:aDecoder];
//}
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [super encodeWithCoder:aCoder];
//}

@end
