//
//  CDReaderUtils.m
//  iPad_Epub
//
//  Created by cqz on 2018/8/21.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDReaderUtils.h"

#import "CDChapterModel.h"
#import "TouchXML.h"
#import <SSZipArchive/SSZipArchive.h>


@implementation CDReaderUtils

+(NSUInteger)separateChapter:(NSMutableArray * __autoreleasing *)chapters content:(NSString *)content {

    [*chapters removeAllObjects];
    __block NSUInteger pages = 0;
    NSString *parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];

    NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];

    if (match.count != 0) {
        
        __block NSRange lastRange = NSMakeRange(0, 0);
        [match enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [obj range];
            if (idx == 0) {
                CDChapterModel *model = [[CDChapterModel alloc] init];
                model.title = @"开始";
                pages += model.pageCount;
                model.startBookPage = pages;
                [*chapters addObject:model];
            }
            if (idx > 0 ) {
                CDChapterModel *model = [[CDChapterModel alloc] init];
                model.title = [content substringWithRange:lastRange];
                pages += model.pageCount;
                model.startBookPage = pages;
                [*chapters addObject:model];
            }
            if (idx == match.count-1) {
                CDChapterModel *model = [[CDChapterModel alloc] init];
                model.title = [content substringWithRange:range];
                pages += model.pageCount;
                model.startBookPage = pages;
                [*chapters addObject:model];
            }
            lastRange = range;
        }];
    } else {
        CDChapterModel *model = [[CDChapterModel alloc] init];
        pages += model.pageCount;
        model.startBookPage = pages;
        [*chapters addObject:model];
    }
    return pages;
}
+(NSString *)encodeWithURL:(NSURL *)url
{
    if (!url) {
        return @"";
    }
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
    }
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
    }
    if (!content) {
        return @"";
    }
    return content;
}

#pragma mark - ePub处理
+(NSMutableArray *)ePubFileHandle:(NSString *)path;
{
    NSString *ePubPath = [self unZip:path];
    if (!ePubPath) {
        return nil;
    }
    NSString *OPFPath = [self OPFPath:ePubPath];
    return [self parseOPF:OPFPath];
}
#pragma mark - 解压文件路径
+(NSString *)unZip:(NSString *)path {

    NSString *zipFile = [[path stringByDeletingPathExtension] lastPathComponent];
    NSString *zipPath = [NSString stringWithFormat:@"%@/%@",kDocuments,zipFile];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:zipPath]) {

        NSError *error;
        [fileManager removeItemAtPath:zipPath error:&error];
    }
    if ([SSZipArchive unzipFileAtPath:path toDestination:zipPath]) {

        NSLog(@"解压成功");
        return zipFile;
    }
    return nil;
}
#pragma mark - OPF文件路径
+(NSString *)OPFPath:(NSString *)epubPath
{

    NSString *containerPath = [NSString stringWithFormat:@"%@/%@/META-INF/container.xml",kDocuments,epubPath];
    //container.xml文件路径 通过container.xml获取到opf文件的路径
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:containerPath]) {
        CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:containerPath] options:0 error:nil];
        CXMLNode* opfPath = [document nodeForXPath:@"//@full-path" error:nil];
        // xml文件中获取full-path属性的节点  full-path的属性值就是opf文件的绝对路径
        NSString *path = [NSString stringWithFormat:@"%@/%@",epubPath,[opfPath stringValue]];
        return path;
    } else {
        NSLog(@"ERROR: ePub not Valid");
        return nil;
    }

}
#pragma mark - 图片的相对路径
//+(NSString *)ePubImageRelatePath:(NSString *)epubPath
//{
//    NSString *containerPath = [NSString stringWithFormat:@"%@/META-INF/container.xml",epubPath];
//    //container.xml文件路径 通过container.xml获取到opf文件的路径
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    if ([fileManager fileExistsAtPath:containerPath]) {
//        CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:containerPath] options:0 error:nil];
//        CXMLNode* opfPath = [document nodeForXPath:@"//@full-path" error:nil];
//        // xml文件中获取full-path属性的节点  full-path的属性值就是opf文件的绝对路径
//        NSString *path = [NSString stringWithFormat:@"%@/%@",epubPath,[opfPath stringValue]];
//        return [path stringByDeletingLastPathComponent];
//    } else {
//        NSLog(@"ERROR: ePub not Valid");
//        return nil;
//    }
//}
#pragma mark - 解析OPF文件
+(NSMutableArray *)parseOPF:(NSString *)opfPath
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",kDocuments,opfPath];
    CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath] options:0 error:nil];
    NSArray* itemsArray = [document nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    //opf文件的命名空间 xmlns="http://www.idpf.org/2007/opf" 需要取到某个节点设置命名空间的键为opf 用opf:节点来获取节点
    NSString *ncxFile;
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray){
        [itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFile = [[element attributeForName:@"href"] stringValue]; //获取ncx文件名称 根据ncx获取书的目录

        }
    }

    NSString *absolutePath = [fullPath stringByDeletingLastPathComponent];
    CXMLDocument *ncxDoc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", absolutePath,ncxFile]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray) {
        NSString* href = [[element attributeForName:@"href"] stringValue];

        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
        //根据opf文件的href获取到ncx文件中的中对应的目录名称
        NSArray* navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
        if ([navPoints count] == 0) {
            NSString *contentpath = @"//ncx:content";
            NSArray *contents = [ncxDoc nodesForXPath:contentpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
            for (CXMLElement *element in contents) {
                NSString *src = [[element attributeForName:@"src"] stringValue];
                if ([src hasPrefix:href]) {
                    xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", src];
                    navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
                    break;
                }
            }
        }

        if([navPoints count]!=0){
            CXMLElement* titleElement = navPoints.firstObject;
            [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
    }
    NSArray* itemRefsArray = [document nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    NSMutableArray *chapters = [NSMutableArray array];
    NSUInteger pages = 0;
    for (CXMLElement* element in itemRefsArray){
        NSString* chapHref = [itemDictionary objectForKey:[[element attributeForName:@"idref"] stringValue]];
        //        CDChapterModel *model = [CDChapterModel chapterWithEpub:[NSString stringWithFormat:@"%@/%@",absolutePath,chapHref] title:[titleDictionary valueForKey:chapHref] imagePath:[opfPath stringByDeletingLastPathComponent]];
        NSString *path = [[opfPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:chapHref];
        CDChapterModel *model = [CDChapterModel chapterWithEpub:path title:[titleDictionary objectForKey:chapHref]];
        model.startBookPage = pages + 1;
        pages += model.pageCount;
        [chapters addObject:model];
    }
    return [NSMutableArray arrayWithArray:@[chapters, @(pages)]];
}
@end
