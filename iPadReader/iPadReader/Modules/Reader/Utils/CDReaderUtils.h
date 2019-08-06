//
//  CDReaderUtils.h
//  iPad_Epub
//
//  Created by cqz on 2018/8/21.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDReaderUtils : NSObject

+(NSUInteger)separateChapter:(NSMutableArray **)chapters content:(NSString *)content;
+(NSString *)encodeWithURL:(NSURL *)url;

/**
 * ePub格式处理
 * 返回章节信息数组
 */
+(NSMutableArray *)ePubFileHandle:(NSString *)path;

@end
