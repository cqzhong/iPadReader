//
//  CDChapterModel.m
//  iPad_Epub
//
//  Created by cqz on 2018/8/21.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDChapterModel.h"
#import "CDReadSettings.h"

#import "NSString+HTML.h"
#import <DTCoreText.h>

@interface CDChapterModel ()

//全章的富文本
@property (nonatomic, copy) NSAttributedString *chapterAttributeContent;
@property (nonatomic, strong, readwrite) NSMutableArray *pageEpubMutaArr;
@end

@implementation CDChapterModel

+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title {
    
    CDChapterModel *model = [[CDChapterModel alloc] init];
    model.title = title;
    model.fileType = ReadFileTypeEpub;
    model.filePath = chapterpath;
    
    [model setupHTMLOptions];
    [model pagingEpubWithBounds:READ_BOUNDS];
    return model;
}
- (void)pageingEpubLayoutFrame {
    
    [self pagingEpubWithBounds:READ_BOUNDS];
}
//断页
- (void)pagingEpubWithBounds:(CGRect)bounds {
    
    if (self.chapterAttributeContent.length == 0) {
        
        [self setupHTMLOptions];
    }

    //每一页在章节中的位置
     NSMutableArray *tempMutaArray = [NSMutableArray arrayWithCapacity:0];

    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:self.chapterAttributeContent];
    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:bounds range:NSMakeRange(0, self.chapterAttributeContent.length)];
    
    NSRange pageVisibleRange = [layoutFrame visibleStringRange];
    NSInteger rangeOffset = pageVisibleRange.location + pageVisibleRange.length;
    NSInteger count = 1;

    while (rangeOffset <= self.chapterAttributeContent.length && rangeOffset !=0) {
        
//NSAttributedString *subAttStr = [self.chapterAttributeContent attributedSubstringFromRange:pageVisibleRange];
        
        layoutFrame = [layouter layoutFrameWithRect:bounds range:NSMakeRange(rangeOffset, self.chapterAttributeContent.length - rangeOffset)];
        pageVisibleRange = [layoutFrame visibleStringRange];
        
        if (!pageVisibleRange.length) {
            rangeOffset = 0;
        } else {
            rangeOffset = pageVisibleRange.location + pageVisibleRange.length;
        }
        
//        NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:subAttStr];
//        [pageAttributeStrings addObject:mutableAttStr];
        [tempMutaArray addObject:@(pageVisibleRange.location)];
        count += 1;
    }
    
    NSArray *arrayM= [tempMutaArray sortedArrayUsingSelector:@selector(compare:)];
    self.pageEpubMutaArr = [NSMutableArray arrayWithArray:arrayM];
    self.pageCount = [_pageEpubMutaArr count];
    CDDLog(@"循环完");
}

-(void)updateContentPagingFont {
    
    if (_fileType == ReadFileTypeEpub) {
        
        [self pagingEpubWithBounds:READ_BOUNDS];
    } else {
        
        [self pagingTxtWithBounds:READ_BOUNDS];
    }
}
//获取epub每一页的内容
- (NSAttributedString *)getEpubAttributedString:(NSUInteger)page {
    
    if (self.chapterAttributeContent.length == 0) {
        
        [self pagingEpubWithBounds:READ_BOUNDS];
    }
    if (page < _pageEpubMutaArr.count) {
        NSUInteger loc = [_pageEpubMutaArr[page] integerValue];
        NSUInteger len = 0;
        if (page == _pageEpubMutaArr.count - 1) {
            len = self.chapterAttributeContent.length - loc;
        } else {
            len = [_pageEpubMutaArr[page + 1] integerValue] - loc;
        }
        return [self.chapterAttributeContent attributedSubstringFromRange:NSMakeRange(loc, len)];
    }
    return nil;
}
//MARK: -txt
-(void)pagingTxtWithBounds:(CGRect)bounds {
    
    _pageMutaArray = @[].mutableCopy;
    CDReadSettings *settings = [CDReadSettings manager];
    
    NSString *content = self.txtBody;
    NSMutableAttributedString *attr = [[NSMutableAttributedString  alloc] initWithString:content attributes:settings.readerAttributes];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attr);
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    CFRange range;
    NSUInteger rangeOffset = 0;
    do {
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, NULL);
        range = CTFrameGetVisibleStringRange(frame);
        rangeOffset += range.length;
        [_pageMutaArray addObject:@(range.location)];
        if (frame) {
            CFRelease(frame);
        }
    } while (range.location + range.length < attr.length);
    if (path) {
        CFRelease(path);
    }
    if (frameSetter) {
        CFRelease(frameSetter);
    }
    _pageCount = _pageMutaArray.count;
    _attributedString = attr;
}
- (NSAttributedString *)getStringWith:(NSUInteger)page {
    if (page < _pageMutaArray.count) {
        NSUInteger loc = [_pageMutaArray[page] integerValue];
        NSUInteger len = 0;
        if (page == _pageMutaArray.count - 1) {
            len = _attributedString.length - loc;
        } else {
            len = [_pageMutaArray[page + 1] integerValue] - loc;
        }
        return [_attributedString attributedSubstringFromRange:NSMakeRange(loc, len)];
    }
    return nil;
}

//MARK: Private
- (void)setupHTMLOptions {
    //[path pathExtension] 获取文件类型
    //[path lastPathComponent] 获取最后一段路径
    
    CGSize imageSize = CGSizeMake(READ_BOUNDS.size.width, READ_BOUNDS.size.height - __CDLANDSCAPE_HEIGHT(50.0));

    NSString *path = [kDocuments stringByAppendingPathComponent:self.filePath];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    CDDLog(@"9999Path:  %@", path);

    //    model.content = [html stringByConvertingHTMLToPlainText];
    //    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
    //
    //        // the block is being called for an entire paragraph, so we check the individual elements
    //        element.textColor = [DTColor redColor];
    //        for (DTHTMLElement *oneChildElement in element.childNodes)
    //        {
    //            oneChildElement.textColor = [DTColor redColor];
    //            oneChildElement.backgroundStrokeColor = [DTColor redColor];
    //        }
    //    };
    
    //
    //    DTDefaultFontSize : @([CDReadSettings manager].fontSize),
    //    DTDefaultFontFamily : @"DFPYuanW7-GB",
    //    [UIColor redColor];
    //    NSTextSizeMultiplierDocumentOption : @(1.0),
    //[DTColor redColor]
    //    NSTextSizeMultiplierDocumentOption
    //    DTMaxImageSize : [NSValue valueWithCGSize:READ_BOUNDS.size]
    //                              DTWillFlushBlockCallBack : callBackBlock
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:@{
//                                                                                   DTDefaultFontSize : @([CDReadSettings manager].fontSize),
                                                                                   DTDefaultFontName : @"DFKaiGB-W5",
                                                                                   NSTextSizeMultiplierDocumentOption : [NSNumber numberWithFloat:1.5],
//                                                                                   DTDefaultLinkColor  : @"purple",
//                                                                                   DTDefaultTextColor : UIColorMakeWithHex(@"#333333"),
//                                                                                   DTDefaultTextAlignment : @"0",
//                                                                                   DTDefaultHeadIndent : @"0",
//                                                                                   DTDefaultFirstLineHeadIndent : @(32.0),
//                                                                                   DTDefaultLineHeightMultiplier : @(1.625),
                                                                                   NSBaseURLDocumentOption : [NSURL fileURLWithPath:path],
                                                                                   DTMaxImageSize : [NSValue valueWithCGSize:imageSize],
                                                                                   }];
    
    if ([[self.filePath lastPathComponent] isEqualToString:@"chapter0.html"]) { //对封面处理

        [options removeObjectForKey:DTDefaultFirstLineHeadIndent];
//        [options setObject:[NSNumber numberWithFloat:2.0] forKey:NSTextSizeMultiplierDocumentOption];

        NSString* html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSString *replaceString = [NSString stringWithFormat:@"<head><style>#book_cover{width: %.2fpx;height: %.2fpx;vertical-align: middle;text-align: center;} p{width: auto;height: 20px;line-height: 20px;text-align: center;}p:nth-child(2){font-size:32px;}</style>", __CDLANDSCAPE_WIDTH(205.0), __CDLANDSCAPE_HEIGHT(256.0)];
        html = [html stringByReplacingOccurrencesOfString:@"<head>" withString:replaceString];
        html = [html stringByReplacingOccurrencesOfString:@"<img" withString:@"<br><br><img id=\"book_cover\""];

        data = [html dataUsingEncoding:NSUTF8StringEncoding];
    }
//
//     if (![[self.filePath lastPathComponent] isEqualToString:@"chapter0.html"]) {
//
//         NSString* html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//         [html stringByAppendingString:@"<br/><br/><br/><br/><br/><br/><br/><br/>"];
////         html = [html stringByReplacingOccurrencesOfString:@"<div><br/></div>" withString:@"<br/><br/><br/><br/><br/><br/><br/><br/>"];
//         data = [html dataUsingEncoding:NSUTF8StringEncoding];
//     }
    
    self.chapterAttributeContent = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];;
}

//MARK:- Setter Getter Methods
- (NSMutableArray *)pageMutaArray {
    if (!_pageMutaArray) {
        _pageMutaArray = [NSMutableArray array];
    }
    return _pageMutaArray;
}
- (NSString *)adjustParagraphFormat:(NSString *)string {
    if (!string) {
        return nil;
    }
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [@"\t" stringByAppendingString:string];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
    return string;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.fileType = [[aDecoder decodeObjectForKey:@"fileType"] integerValue];
        self.pageCount = [[aDecoder decodeObjectForKey:@"pageCount"] integerValue];
        self.startBookPage = [[aDecoder decodeObjectForKey:@"startBookPage"] integerValue];

        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.txtBody = [aDecoder decodeObjectForKey:@"txtBody"];
        self.pageMutaArray = [aDecoder decodeObjectForKey:@"pageMutaArray"];
        self.attributedString = [aDecoder decodeObjectForKey:@"attributedString"];

//        self.chapterAttributeContent = [aDecoder decodeObjectForKey:@"chapterAttributeContent"];
//        self.pageAttributeStrings = [aDecoder decodeObjectForKey:@"pageAttributeStrings"];
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.pageEpubMutaArr = [aDecoder decodeObjectForKey:@"pageEpubMutaArr"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:@(self.fileType) forKey:@"fileType"];
    [aCoder encodeObject:@(self.pageCount) forKey:@"pageCount"];
    [aCoder encodeObject:@(self.startBookPage) forKey:@"startBookPage"];

    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.txtBody forKey:@"txtBody"];
    [aCoder encodeObject:self.pageMutaArray forKey:@"pageMutaArray"];
    [aCoder encodeObject:self.attributedString forKey:@"attributedString"];

//    [aCoder encodeObject:self.chapterAttributeContent forKey:@"chapterAttributeContent"];
//    [aCoder encodeObject:self.pageAttributeStrings forKey:@"pageAttributeStrings"];
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.pageEpubMutaArr forKey:@"pageEpubMutaArr"];
}

@end
