//
//  CDReaderView.m
//  CDProgramme
//
//  Created by cqz on 2018/8/28.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDReaderView.h"
#import "CDChapterModel.h"
#import <DTCoreText.h>
#import "UIView+WhenTappedBlocks.h"

#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

@interface CDReaderView () <DTAttributedTextContentViewDelegate, QMUIImagePreviewViewDelegate>

@property (strong, nonatomic) DTAttributedTextContentView *readTextView;

@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CDReaderView

-(void)dealloc {
    
//    DLog(@"文章被释放");
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
#pragma mark - Intial Methods
- (void)setupView {
    
    
}
#pragma mark - Target Methods
- (void)handleImageTap:(UIImageView *)imageView {
    
    self.imageView = imageView;
    
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.backgroundColor = [UIColorMakeWithHex(@"#000000") colorWithAlphaComponent:0.7];
        self.imagePreviewViewController.presentingStyle = QMUIImagePreviewViewControllerTransitioningStyleZoom;// 将 present 动画改为 zoom，也即从某个位置放大到屏幕中央。默认样式为 fade。
        self.imagePreviewViewController.imagePreviewView.delegate = self;// 将内部的图片查看器 delegate 指向当前 viewController，以获取要查看的图片数据
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = 0;// 默认展示的图片 index
        
        @weakify(self);
        // 如果使用 zoom 动画，则需要在 sourceImageView 里返回一个 UIView，由这个 UIView 的布局位置决定动画的起点/终点，如果用 fade 则不需要使用 sourceImageView。
        // 另外当 sourceImageView 返回 nil 时会强制使用 fade 动画，常见的使用场景是 present 时 sourceImageView 还在屏幕内，但 dismiss 时 sourceImageView 已经不在可视区域，即可通过返回 nil 来改用 fade 动画。
        self.imagePreviewViewController.sourceImageView = ^UIView *{
            
            @strongify(self);
            return self.imageView;
        };
        
        // 当需要在退出大图预览时做一些事情的时候，可配合 UIViewController (QMUI) 的 qmui_visibleStateDidChangeBlock 来实现。
        self.imagePreviewViewController.qmui_visibleStateDidChangeBlock = ^(QMUIImagePreviewViewController *viewController, QMUIViewControllerVisibleState visibleState) {
            if (visibleState == QMUIViewControllerWillDisappear) {
                UIImage *currentImage = [viewController.imagePreviewView zoomImageViewAtIndex:viewController.imagePreviewView.currentImageIndex].image;
                if (currentImage) {
                    
                    @strongify(self);
                    self.imageView.image = currentImage;
                }
            }
        };
    }
    [kRootViewController presentViewController:self.imagePreviewViewController animated:true completion:nil];

}
#pragma mark - Public Methods

#pragma mark - Private Method
- (void)reloadView {
    CGRect frame = self.bounds;
    
    [self.readTextView removeFromSuperview];
    
//    NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithAttributedString:self.pageContent];
//    [txt addAttribute:NSForegroundColorAttributeName  value:[UIColor redColor] range:NSMakeRange(0, txt.length)];
    
    self.readTextView = [[DTAttributedTextContentView alloc] initWithFrame:frame];
    self.readTextView.shouldDrawImages = true;
    self.readTextView.shouldDrawLinks = true;
    self.readTextView.delegate = self; // delegate for custom sub views
    self.readTextView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.readTextView];
    self.readTextView.attributedString = self.pageContent;
}

//MARK: -DTAttributedTextContentViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
                    viewForAttachment:(DTTextAttachment *)attachment
                                frame:(CGRect)frame{
    
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        // if the attachment has a hyperlinkURL then this is currently ignored
        //        attachment.contentURL = [NSURL fileURLWithPath:[attachment.contentURL absoluteString]];
//        CGRect tmpFrame = frame;
//        tmpFrame.origin.y = __CDLANDSCAPE_HEIGHT(100.0);
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        //        imageView.delegate = self;
        imageView.userInteractionEnabled = true;
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        imageView.url = attachment.contentURL;
        if (attachment.contentURL || attachment.hyperLinkURL) {
            
            @weakify(self);
            [imageView whenTapped:^{
                
                @strongify(self);
                [self handleImageTap:imageView];
            }];
//            [imageView addGestureRecognizer:({
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
//                tap;
//            })];
        }
        
        //        if (attachment.hyperLinkURL) {
        //            imageView.hyperLinkURL = attachment.hyperLinkURL;// if there is a hyperlink
        //        }
        
        return imageView;
    }
    
    return nil;
}

//MARK: QMUIImagePreviewViewDelegate
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    
    zoomImageView.reusedIdentifier = @(index);
    
    
    [zoomImageView showLoading];

    if ([zoomImageView.reusedIdentifier isEqual:@(index)]) {
        zoomImageView.image = self.imageView.image;
        
        [zoomImageView hideEmptyView];
    }
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - <QMUIZoomImageViewDelegate>

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    // 退出图片预览
    [kRootViewController dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - Setter Getter Methods
- (void)setPageContent:(NSAttributedString *)pageContent {
    _pageContent = pageContent;
    
    [self reloadView];
}

@end
