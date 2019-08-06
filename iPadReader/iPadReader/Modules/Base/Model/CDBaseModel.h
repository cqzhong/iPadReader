//
//  CDBaseModel.h
//  CDProgramme
//
//  Created by 庆中 on 2018/7/2.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用户校验该模型本身是否可用
 */
@protocol ModelValid <NSObject>

/**
 是否有效
 
 @return 是否有效
 */
- (BOOL)isValid;

/**
 错误信息
 */
- (nullable NSError *)validError;

/**
 不允许为空的属性
 
 @return 属性字典
 */
- (nullable NSDictionary <NSString *,id>*)nonnullDefaultValueProperties;

@end

@interface CDBaseModel : NSObject  <NSCopying,NSCoding, ModelValid>

@end
