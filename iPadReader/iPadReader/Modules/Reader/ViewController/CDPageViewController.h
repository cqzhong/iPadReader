//
//  CDPageViewController.h
//  CDProgramme
//
//  Created by cqz on 2018/8/28.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDBookEpubModel, CDChapterModel, CDRecordModel;

@interface CDPageViewController : UIViewController

@property (nonatomic, strong) CDBookEpubModel *bookModel;

@property (nonatomic, strong) NSTimer *readTimer;

- (void)invalidateTimer;

//读取目录
- (void)reloadReaderPageViewControllerWith:(NSUInteger)chapter;

@end
