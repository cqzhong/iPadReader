//
//  CDReadPageViewController.h
//  CDProgramme
//
//  Created by cqz on 2018/8/28.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CDChapterModel.h"

@interface CDReadPageViewController : UIViewController


//文本类型
@property (nonatomic, copy) NSString *bookToken;
@property (nonatomic, assign) ReadFileType fileType;
@property (nonatomic, copy) NSString *booktitle;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger chapter;

@property (nonatomic, copy) NSAttributedString *pageContent;

//总页数
@property (nonatomic, assign) NSUInteger allPages;
//阅读到这本书的第几页
@property (nonatomic, assign) NSUInteger readingPage;

//是否是读后感页面
@property (nonatomic, assign) BOOL isReadFinished;
@property (nonatomic, copy) NSString *readTimeString;


- (void)seeMoreReviews;
@end
