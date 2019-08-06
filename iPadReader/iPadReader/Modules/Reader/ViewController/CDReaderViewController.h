//
//  CDReaderViewController.h
//  CDProgramme
//
//  Created by cqz on 2018/8/20.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZMATViewController.h"
@class CDBookEpubModel, CDChapterModel, CDRecordModel;

@interface CDReaderViewController : DZMATViewController

@property (nonatomic, strong) CDBookEpubModel *bookModel;

@end
