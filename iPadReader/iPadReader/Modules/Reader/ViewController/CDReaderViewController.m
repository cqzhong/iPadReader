//
//  CDReaderViewController.m
//  CDProgramme
//
//  Created by cqz on 2018/8/20.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDReaderViewController.h"
#import "CDPageViewController.h"

//view
#import "HMSegmentedControl.h"
#import "UIView+Shadow.h"

//model
#import "CDBookEpubModel.h"

@interface CDReaderViewController ()

@property (nonatomic, strong) QMUIButton *closeButton;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
//@property (nonatomic, strong) QMUIButton *directoryButton;

@property (nonatomic, strong) UIView *readBottomView;


@end

@implementation CDReaderViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.readBottomView shadowCornerRadius:15.0];
}
#pragma mark - Intial Methods
- (void)initSubviews {
    [super initSubviews];
    
    CDDLog(@"路径： %@", self.bookModel.resource);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.closeButton];
    [self.view  addSubview:self.segmentedControl];
//    [self.view addSubview:self.directoryButton];

    [self.view addSubview:self.readBottomView];
    
    CDPageViewController *pageVC = [CDPageViewController new];
    pageVC.bookModel = self.bookModel;
    [self addChildViewController:pageVC];

    [self.readBottomView addSubview:pageVC.view];
    [self masLayoutSubViews];
    
    [self loadData];
}

- (void)masLayoutSubViews {
    
    [self.readBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(__CDLANDSCAPE_WIDTH(60.0));
        make.right.equalTo(self.view).offset(__CDLANDSCAPE_WIDTH(-60.0));
        make.top.equalTo(self.view).offset(__CDLANDSCAPE_HEIGHT(86.0));
        make.bottom.equalTo(self.view).offset(__CDLANDSCAPE_HEIGHT(-60.0));
    }];
    CDPageViewController *vc = [self.childViewControllers firstObject];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.readBottomView);
    }];
}
#pragma mark - Network Methods
- (void)loadData {
    
}

#pragma mark - Target Methods
- (void)leftButtonDidClickAction {
    
    CDPageViewController *vc = [self.childViewControllers firstObject];
    [vc invalidateTimer];
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)seg {
    
    if (seg.selectedSegmentIndex == 0) {
        //白天
        if ([UIScreen mainScreen].brightness < kReadDay)
             [[UIScreen mainScreen] setBrightness:kReadDay];
    } else {
        //黑夜
        if ([UIScreen mainScreen].brightness > kReadNight)
            [[UIScreen mainScreen] setBrightness:kReadNight];
    }
}
#pragma mark - Public Methods
- (void)configNavigationBar:(UINavigationBar *)navigationBar {
    [super configNavigationBar:navigationBar];
}
- (BOOL)preferredNavigationBarHidden {
    return true;
}
- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return false;
}
- (BOOL)shouldAutorotate {
    return true;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - Private Method

#pragma mark - External Delegate

#pragma mark - Setter Getter Methods
- (QMUIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"read_close") title:nil];
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton addTarget:self action:@selector(leftButtonDidClickAction) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.frame = CGRectMake(__CDLANDSCAPE_WIDTH(10.0), __CDLANDSCAPE_HEIGHT(25.0), __CDLANDSCAPE_WIDTH(38.5), __CDLANDSCAPE_HEIGHT(48.5));
    }
    return _closeButton;
}
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - __CDLANDSCAPE_WIDTH(180.0), __CDLANDSCAPE_HEIGHT(36.0), __CDLANDSCAPE_WIDTH(120.0), __CDLANDSCAPE_HEIGHT(30.0))];
        _segmentedControl.sectionTitles = @[@"白天",@"夜晚"];
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName : CDUIFontMake(16), NSForegroundColorAttributeName : CDTHEME_COLOR};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName : CDUIFontMake(16),NSForegroundColorAttributeName : UIColorMakeWithHex(@"#FFFFFF")};
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.verticalDividerEnabled = false;
        _segmentedControl.selectionIndicatorBoxColor = CDTHEME_COLOR;
        _segmentedControl.selectionIndicatorBoxOpacity = 1.0;
        _segmentedControl.layer.cornerRadius = __CDLANDSCAPE_WIDTH(30.0)/2.0;
        _segmentedControl.layer.masksToBounds = true;
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        //白天
        if ([UIScreen mainScreen].brightness < kReadDay) {
            
            _segmentedControl.selectedSegmentIndex = 1;
        }
    }
    return _segmentedControl;
}
- (UIView *)readBottomView {
    if (!_readBottomView) {
        _readBottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _readBottomView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
    }
    return _readBottomView;
}
@end
