//
//  CDPageViewController.m
//  CDProgramme
//
//  Created by cqz on 2018/8/28.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDPageViewController.h"
#import "CDReadPageViewController.h"

#import "CDBookSQLiteManager.h"

#import "CDBookEpubModel.h"
//阅读记录
#import "CDRecordModel.h"

@interface CDPageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, assign) NSUInteger chapterInteger;
//@property (nonatomic, assign) NSUInteger pageInteger;

@property (nonatomic, strong) CDRecordModel *recordModel;
@end

@implementation CDPageViewController

#pragma mark - Life Cycle Methods
- (void)dealloc {

    [[CDBookSQLiteManager manager] updateReadingRecordModel:self.recordModel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chapterInteger = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPageViewController];
}
#pragma mark - Intial Methods

#pragma mark - Target Methods

#pragma mark - Public Methods
- (void)reloadReaderPageViewControllerWith:(NSUInteger)chapter {
    
    if ([self.bookModel.chapters count] == 0) return;
        
    if (chapter >= [self.bookModel.chapters count]) {
        chapter = [self.bookModel.chapters count] - 1;
    }
    
    _chapterInteger = chapter;
    CDChapterModel *chapterModel = _bookModel.chapters[_chapterInteger];
    
    NSUInteger index = 0;
    NSArray *arrayM = @[[self viewControllerAtIndex:index chapterModel:chapterModel], [self viewControllerAtIndex:index + 1 chapterModel:chapterModel]];
    
    @weakify(self);
    [_pageViewController setViewControllers:arrayM direction:UIPageViewControllerNavigationDirectionForward animated:false completion:^(BOOL finished) {
        
        if (finished) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.pageViewController setViewControllers:arrayM direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
            });
        }
    }];
}
#pragma mark - Private Method
- (void)setupPageViewController {
    
    //取出阅读记录
    CDRecordModel *recordModel = [[CDBookSQLiteManager manager] accessToReadRecordModel:self.bookModel.bookToken];
    if (!recordModel) {
        recordModel = [[CDRecordModel alloc] initWithBookToken:self.bookModel.bookToken withAllChapters:[self.bookModel.chapters count]];
        
        [[CDBookSQLiteManager manager] updateReadingRecordModel:recordModel];
    }
    
    //和服务器校对阅读时间
    if (self.bookModel.finished) {
        
        recordModel.isFinished = true;
        recordModel.readTime = (self.bookModel.finish_time > 0) ? self.bookModel.finish_time : recordModel.readTime;
    }
    
    self.recordModel = recordModel;
    if (!self.recordModel.isFinished) {
        
        [self.readTimer fire];
    }
    
    _chapterInteger = self.recordModel.readingChapter;
    CDChapterModel *chapterModel = nil;
    if (self.recordModel.readingChapter >= [_bookModel.chapters count]) {
        
        chapterModel = [_bookModel.chapters firstObject];
    } else {
        chapterModel = _bookModel.chapters[_chapterInteger];
    }
    
    NSUInteger index = self.recordModel.readingChapterPage;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    NSArray *arrayM = nil;
    if (self.recordModel.isFinished &&
        ((self.recordModel.readingChapterPage + chapterModel.startBookPage) == self.bookModel.pages) &&
        (self.bookModel.pages % 2 ==0)) {
        //明确下章节，防止出错
        self.chapterInteger = [self.bookModel.chapters count] - 1;
        arrayM = @[[self configBlankViewController:true], [self configBlankViewController:false]];
    } else {
        
        if ((index + chapterModel.startBookPage) %2 == 0) {

            if (_chapterInteger > 0) {
                
                if (index == 0) {
                    _chapterInteger --;
                    chapterModel = self.bookModel.chapters[_chapterInteger];
                    index = [self.bookModel.chapters[_chapterInteger] pageCount] - 1;
                } else {
                     index--;
                }
            } else {
                if (index > 0) index--;
            }
        }
        
        arrayM = @[[self viewControllerAtIndex:index chapterModel:chapterModel], [self viewControllerAtIndex:index + 1 chapterModel:chapterModel]];
    }
    
    @weakify(self);
    [_pageViewController setViewControllers:arrayM direction:UIPageViewControllerNavigationDirectionForward animated:false completion:^(BOOL finished) {
        
        if (finished) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.pageViewController setViewControllers:arrayM direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
            });
        }
    }];
}
- (void)invalidateTimer {
    
    CD_INVALIDATE_TIMER(_readTimer);
}
- (void)updateReadTime {
    
    self.recordModel.readTime += 1;
}
#pragma mark - External Delegate

#pragma mark - UIPageViewControllerDelegate,UIPageViewControllerDataSource
//向前翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if ([self.bookModel.chapters count] == 0) return nil;
    
    CDReadPageViewController *pageVC = (CDReadPageViewController *)viewController;
    self.chapterInteger = pageVC.chapter;
    NSUInteger page = pageVC.page;
    if (page == 0 && self.chapterInteger == 0) {
        
        if ([viewController isEqual:[pageViewController.viewControllers firstObject]]) {
            
            [CDToastService showToast:@"已经是第一页"];
            return nil;
        } else {
            return [self configBlankViewController:false];
        }
    }
    
    CDChapterModel *chapterModel = self.bookModel.chapters[_chapterInteger];
    if (page <= 0) { //换章
        _chapterInteger --;
        chapterModel = self.bookModel.chapters[_chapterInteger];
        page = [self.bookModel.chapters[_chapterInteger] pageCount] - 1;
    } else {
        page --;
    }
    return [self viewControllerAtIndex:page chapterModel:chapterModel];
}
//向后翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if ([self.bookModel.chapters count] == 0) return nil;
    CDReadPageViewController *pageVC = (CDReadPageViewController *)viewController;
    self.chapterInteger = pageVC.chapter;
    NSUInteger page = pageVC.page;
    CDReadPageViewController *firstObjectVC = [pageViewController.viewControllers firstObject];
    if (firstObjectVC.isReadFinished) {
        page = [[self.bookModel.chapters lastObject] pageCount] -1;
    }

    if (_chapterInteger == [self.bookModel.chapters count] - 1 &&
        page >= [[self.bookModel.chapters lastObject] pageCount] -1) {
        
        if ([viewController isEqual:[pageViewController.viewControllers lastObject]]) {
            
            if (!pageVC.isReadFinished &&
                !firstObjectVC.isReadFinished) {
                return [self configBlankViewController:true];
            };
            [CDToastService showToast:@"已经是最后一页"];
            return nil;
        }
        BOOL isBlank = (pageVC.isReadFinished && !firstObjectVC.isReadFinished) ? false : true;
        return [self configBlankViewController:isBlank];
    }
    
    CDChapterModel *chapterModel = self.bookModel.chapters[_chapterInteger];
    if (page == [chapterModel pageCount] -1) {
        _chapterInteger++;
        if (_chapterInteger > [self.bookModel.chapters count] - 1) {
            
            return [self configBlankViewController:false];
        }
        chapterModel = self.bookModel.chapters[_chapterInteger];
        page = 0;
    } else {
        page ++;
    }
    return [self viewControllerAtIndex:page chapterModel:chapterModel];
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    //    NSLog(@"pendingViewControllers: %@",pendingViewControllers);
    
}
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if (completed) {
        CDReadPageViewController *previousViewController =  (CDReadPageViewController*)previousViewControllers.lastObject;
        previousViewController.view.hidden = true;
    }
}

//MARK: - 自定义
- (void)reloadReaderPageViewControllerWith:(NSUInteger)chapter page:(NSUInteger)page {
    
    if (chapter >= [self.bookModel.chapters count]) return;
    
    _chapterInteger = chapter;
    CDChapterModel *contentModel = self.bookModel.chapters[_chapterInteger];
    
    NSArray *arrayM = @[[self viewControllerAtIndex:0 chapterModel:contentModel], [self viewControllerAtIndex:1 chapterModel:contentModel]];
    @weakify(self);
    [self.pageViewController setViewControllers:arrayM direction:UIPageViewControllerNavigationDirectionForward animated:false completion:^(BOOL finished) {
        
        @strongify(self);
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pageViewController setViewControllers:arrayM direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
            });
        }
    }];
}
- (CDReadPageViewController *)viewControllerAtIndex:(NSUInteger)index chapterModel:(CDChapterModel *)chapterModel{
    
    CDDLog(@"第%@章   第%@页", @(_chapterInteger), @(index));
    if (chapterModel.pageCount == 0)
        [chapterModel pageingEpubLayoutFrame];
    
    if (!chapterModel || chapterModel.pageCount == 0)
        return [self configBlankViewController:false];

    if (index >= [chapterModel pageCount]) {
        
        if (self.chapterInteger < [self.bookModel.chapters count] - 1) {
            
            self.chapterInteger ++;
            chapterModel = self.bookModel.chapters[self.chapterInteger];
            index = 0;
            CDDLog(@"纠正第%@章   第%@页", @(_chapterInteger), @(index));
        } else {
            return [self configBlankViewController:true];
        }
    }
    
    
    self.recordModel.readingChapter = _chapterInteger;
    self.recordModel.readingChapterPage = index;
    [[CDBookSQLiteManager manager] updateReadingRecordModel:self.recordModel];

    CDReadPageViewController *readViewController = [[CDReadPageViewController alloc]init];
    readViewController.page = index;
    readViewController.chapter = _chapterInteger;
    readViewController.readingPage = index + chapterModel.startBookPage;
    readViewController.allPages = self.bookModel.pages;
    readViewController.booktitle = chapterModel.title;
    readViewController.fileType = chapterModel.fileType;
    readViewController.bookToken = self.bookModel.bookToken;
    if (chapterModel.fileType == ReadFileTypeEpub) {
        
        readViewController.pageContent = [chapterModel getEpubAttributedString:index];
    } else {
        readViewController.pageContent = [chapterModel getStringWith:index];
    }
    return readViewController;
}
//空白页
- (CDReadPageViewController *)configBlankViewController:(BOOL)isReadFinished {
    
    if (_chapterInteger >= [self.bookModel.chapters count]) {
        _chapterInteger = [self.bookModel.chapters count] - 1;
    }
    CDChapterModel *chapterModel = self.bookModel.chapters[_chapterInteger];
    
    CDReadPageViewController *readViewController = [[CDReadPageViewController alloc]init];
    readViewController.chapter = _chapterInteger;
    readViewController.bookToken = self.bookModel.bookToken;
    readViewController.isReadFinished = isReadFinished;

    readViewController.page = isReadFinished ? [chapterModel pageCount] : 0;
    if (_chapterInteger == 0) {
        
    } else {
        //读后感页面 阅读完成
        [self invalidateTimer];
        self.recordModel.isFinished = true;
        [[CDBookSQLiteManager manager] updateReadingRecordModel:self.recordModel];

        readViewController.readTimeString = self.recordModel.readTimeString;
        
        if (!self.bookModel.finished) {

        }
    }
    readViewController.booktitle = @"";
    return readViewController;
}
#pragma mark - Setter Getter Methods
- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey: UIPageViewControllerOptionSpineLocationKey];
        UIPageViewControllerTransitionStyle style= UIPageViewControllerTransitionStylePageCurl;
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:style navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        //书脊必须设置
        _pageViewController.doubleSided = true;
        _pageViewController.view.frame = self.view.bounds;
    }
    return _pageViewController;
}
-(NSTimer *)readTimer {
    if (!_readTimer) {
        _readTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateReadTime) userInfo:nil repeats:true];
    }
    return _readTimer;
}
@end
