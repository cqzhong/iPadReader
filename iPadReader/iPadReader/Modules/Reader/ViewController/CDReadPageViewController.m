//
//  CDReadPageViewController.m
//  CDProgramme
//
//  Created by cqz on 2018/8/28.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDReadPageViewController.h"

#import "CDReaderView.h"


@interface CDReadPageViewController ()

@property (nonatomic, strong) CDReaderView *readerView;

@property (nonatomic, strong) UILabel *numLabel;

//@property (nonatomic, strong) MASConstraint *leftConstraint;

@end

@implementation CDReadPageViewController

- (void)dealloc {
//    DLog(@"阅读page释放");
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.isReadFinished) {

        [self.view setBackgroundColor:UIColorMakeWithHex(@"#F8F9F8")];
        [self.view addSubview:self.readerView];
        [self.view addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).offset(__CDLANDSCAPE_WIDTH(10.0));
            make.right.equalTo(self.view).offset(__CDLANDSCAPE_WIDTH(-10.0));
            make.bottom.equalTo(self.view).offset(__CDLANDSCAPE_HEIGHT(-5.0));
            make.height.mas_offset(__CDLANDSCAPE_HEIGHT(30.0));
        }];
        
    } else {
        
        //阅读完毕
        
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isReadFinished) {
        if (self.readingPage %2 == 0) {
            
            _numLabel.textAlignment = NSTextAlignmentRight;
            [self.view setBackgroundColor:UIColorMakeWithHex(@"#F8F9F8")];
        } else {
            _numLabel.textAlignment = NSTextAlignmentLeft;
            [self.view setBackgroundColor:UIColorMakeWithHex(@"#FFFFFF")];
        }
        _numLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.readingPage),@(self.allPages)];
        if ([_numLabel.text isEqualToString:@"0/0"]) {
            _numLabel.text = @"";
        }
        _readerView.pageContent = _pageContent;
    }
}
#pragma mark - Public Methods
- (void)seeMoreReviews {
    
}

#pragma mark - Setter Getter Methods
- (CDReaderView *)readerView {
    if (!_readerView) {
        _readerView = [[CDReaderView alloc] initWithFrame:CGRectMake(__CDLANDSCAPE_WIDTH(20.0), __CDLANDSCAPE_HEIGHT(20.0), CGRectGetWidth(READ_BOUNDS), CGRectGetHeight(READ_BOUNDS))];
        _readerView.backgroundColor = [UIColor clearColor];
    }
    return _readerView;
}
- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLabel.textColor = UIColorMakeWithHex(@"#999999");
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.font = CDUIFontMake(16.0);
    }
    return _numLabel;
}
@end
