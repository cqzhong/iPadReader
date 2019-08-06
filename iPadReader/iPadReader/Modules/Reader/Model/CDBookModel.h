//
//  CDBookModel.h
//  CDProgramme
//
//  Created by cqz on 2018/8/31.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDBaseModel.h"

@interface CDBookModel : CDBaseModel

@property (nonatomic , copy) NSString              * bookToken;
@property (nonatomic , copy) NSString              * book_cover_one;

@property (nonatomic , assign) NSInteger              finish_time;
@property (nonatomic , assign) BOOL              finished;

@property (nonatomic , copy) NSString              * savePath;

@end
