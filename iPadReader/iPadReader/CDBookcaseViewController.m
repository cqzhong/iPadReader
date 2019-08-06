//
//  CDBookcaseViewController.m
//  iPadReader
//
//  Created by cqz on 2019/4/22.
//  Copyright © 2019 ChangDao. All rights reserved.
//

#import "CDBookcaseViewController.h"

#import "CDReaderViewController.h"

@interface CDBookcaseViewController ()

@property (nonatomic, strong) QMUIFillButton *psychologyButton;
@property (nonatomic, strong) QMUIFillButton *inverseButton;

@end

@implementation CDBookcaseViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - Intial Methods
- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.psychologyButton];
    [self.view addSubview:self.inverseButton];

    [self makeConstraints];
}
- (void)makeConstraints {
    
    [self.psychologyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view).offset(CDREALVALUE_HEIGHT(80));
        make.centerX.equalTo(self.view);
        make.height.mas_offset(CDREALVALUE_HEIGHT(150));
        make.width.mas_offset(CDREALVALUE_WIDTH(150));
    }];
    
    [self.inverseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view).offset(CDREALVALUE_HEIGHT(-80));
        make.centerX.height.width.equalTo(self.psychologyButton);
    }];
}

#pragma mark - Target Methods
- (void)goToRead:(QMUIFillButton *)button {
    
    NSString *bookToken = (button.tag == 4001) ? @"psychology" : @"inverse";
    
    CDBookEpubModel *epubBookModel = [[CDBookSQLiteManager manager] accessToEpubBook:bookToken];
    
    if (epubBookModel) {
        
        self.ATTarget = button;
        CDReaderViewController *readVC = [CDReaderViewController new];
        readVC.bookModel = epubBookModel;
        [self.navigationController pushATViewController:readVC animated:true];
    } else {
        
        [MBProgressHUD showMBLoadingWithText:@"正在解析..."];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:bookToken ofType:@"epub"];

            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            CDBookEpubModel *epubBookModel = [CDBookEpubModel getLocalModelWithURL:fileURL];
            epubBookModel.bookToken = bookToken;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[CDBookSQLiteManager manager] setupStoreBooks:epubBookModel];
                
                [MBProgressHUD hideHUD];
                self.ATTarget = button;
                CDReaderViewController *readVC = [CDReaderViewController new];
                readVC.bookModel = epubBookModel;
                [self.navigationController pushATViewController:readVC animated:true];
            });
        });
    }
}
#pragma mark - Public Methods
- (void)configNavigationBar:(UINavigationBar *)navigationBar {
    [super configNavigationBar:navigationBar];
}
- (BOOL)shouldAutorotate {
    return true;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - Private Method

#pragma mark - External Delegate

#pragma mark - UITableViewDelegate,UITableViewDataSource

#pragma mark - Setter Getter Methods
- (QMUIFillButton *)psychologyButton {
    if (!_psychologyButton) {
        _psychologyButton = [[QMUIFillButton alloc] initWithFillColor:UIColorMakeWithHex(@"#000000") titleTextColor:UIColorMakeWithHex(@"#FFFFFF")];
        _psychologyButton.titleLabel.font = CDUIFontMake(20);
        [_psychologyButton setTitle:@"每天懂一点\n好玩心理学" forState:UIControlStateNormal];
        [_psychologyButton addTarget:self action:@selector(goToRead:) forControlEvents:UIControlEventTouchUpInside];
        _psychologyButton.tag = 4001;
        _psychologyButton.cornerRadius = 10;
        _psychologyButton.titleLabel.numberOfLines = 0;
    }
    return _psychologyButton;
}

- (QMUIFillButton *)inverseButton {
    if (!_inverseButton) {
        _inverseButton = [[QMUIFillButton alloc] initWithFillColor:UIColorMakeWithHex(@"#000000") titleTextColor:UIColorMakeWithHex(@"#FFFFFF")];
        _inverseButton.titleLabel.font = CDUIFontMake(24);
        [_inverseButton setTitle:@"山海经" forState:UIControlStateNormal];
        [_inverseButton addTarget:self action:@selector(goToRead:) forControlEvents:UIControlEventTouchUpInside];
        _inverseButton.tag = 4002;
        _inverseButton.cornerRadius = 10;
    }
    return _inverseButton;
}

@end
