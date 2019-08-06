//
//  CDServerModel.h
//  CDProgramme
//
//  Created by 庆中 on 2018/7/2.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDBaseModel.h"

@interface CDServerModel : CDBaseModel

/**
 数据内容 (NSArray* , NSDictionary*, NSString*)
 */
@property(nonatomic, strong, nullable) id data;


/**
 content 字典转过模型的数据 (NSArray<BaseModel *>*, BaseModel*)
 */
@property(nonatomic, strong, nullable) id modelData;
/**
 状态码
 */
@property(nonatomic, assign) NSInteger code;

/**
 提示信息
 */
@property(nonatomic, copy, nullable) NSString *msg;

/**
 debug 信息
 */
@property(nonatomic, copy, nullable) NSString *remark;


@end
