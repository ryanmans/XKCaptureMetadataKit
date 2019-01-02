//
//  XKCaptureMetadataViewController.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKCaptureMetadataViewController.h"
#import "XKCaptureMetadataResultsViewController.h"
#import "XKTabBarMenu.h"
#import "XKPagerController.h"
#import "XKCaptureMetadataController.h"
#import "XKCaptureMetadataContentView.h"
#import "Reachability/Reachability.h"
@interface XKCaptureMetadataViewController ()<XKPagerControllerDataSource>
@property(nonatomic,assign)BOOL isDisappear;
@property(nonatomic,strong)UIButton * torchModeButton;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIView * navigationView;
@property(nonatomic,strong)XKTabBarMenu * tabBarMenu;
@property(nonatomic,strong)XKPagerController * pagerController;
@property(nonatomic,strong)XKCaptureMetadataController * captureMetadataController;
@end

@implementation XKCaptureMetadataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNavBarHiden = YES;
    self.view.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.titleLabel];
    [self.navigationView addSubview:self.torchModeButton];
    [self.view addSubview:self.tabBarMenu];
    [self.view addSubview:self.captureMetadataController];
    [self.view addSubview:self.pagerController];
    
    WeakSelf(ws);
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view);
        make.top.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.height.mas_equalTo(INVALID_VIEW_HEIGHT);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.navigationView);
        make.bottom.equalTo(ws.navigationView.mas_bottom).offset(-8);
    }];
    
    [self.torchModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.navigationView).offset(-16);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.bottom.equalTo(ws.navigationView.mas_bottom).offset(-8);
    }];
    
    [self.tabBarMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view);
        make.top.equalTo(ws.navigationView.mas_bottom);
        make.right.equalTo(ws.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.pagerController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view);
        make.top.equalTo(ws.tabBarMenu.mas_bottom);
        make.right.equalTo(ws.view);
        make.height.mas_equalTo(ws.captureMetadataController.height);
    }];
    
    [self.view layoutIfNeeded];

    [self.pagerController reloadData];
    
    //网络监听
    // 监听网络状态改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReachabilityChangedNotification:) name:kReachabilityChangedNotification object:nil];
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
}

//网络监听
- (void)onReachabilityChangedNotification:(NSNotification*)noti{
    if (([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) || ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)) {
        [self.captureMetadataController startRunning];
        [self isCaptureMetadataContentAnimate:YES];
    }
    else{
        NSLog(@"网络错误");
        [self.captureMetadataController stopRunning];
        [self isCaptureMetadataContentAnimate:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isDisappear = YES;
    [self isCaptureMetadataContentAnimate:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //延迟几秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        if (![UIDevice isCameraAuthorizationStatus]) {
            [UIDevice cameraAuthorizationAlert]; //相机未授权
            [self.captureMetadataController stopRunning];
            
        }else{
            [self.captureMetadataController startRunning];
        }
        [self isCaptureMetadataContentAnimate:YES];
    });
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureMetadataController stopRunning];
}

//是否动画
- (void)isCaptureMetadataContentAnimate:(BOOL)isRunning{
    [self.pagerController.visibleContentViews.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XKCaptureMetadataContentView * indexView = (XKCaptureMetadataContentView*)self.pagerController.visibleContentViews[obj];
        if (indexView.captureMode != XKCaptureMetadataModePhoto){
            isRunning ? [indexView startRunning]: [indexView stopRunning];
        };
    }];
}

#pragma mark - PNPagerControllerDataSource
- (NSInteger)numberOfContentViewsInPagerController{
    return 3;
}

- (UIView*)pagerController:(XKPagerController *)pagerController contentViewForIndex:(NSInteger)index{
    XKCaptureMetadataContentView * contentView =  [[XKCaptureMetadataContentView alloc] initWithFrame:pagerController.displayScrollView.bounds];
    if (index == 0) contentView.captureMode = XKCaptureMetadataModeCode;
    else if (index == 1) contentView.captureMode = XKCaptureMetadataModePhoto;
    else if (index == 2) contentView.captureMode = XKCaptureMetadataModeContinuous;
    WeakSelf(ws);
    contentView.onCapturePhotoBlock = ^{
        [ws.captureMetadataController takingPictures]; //拍照
    };
    return contentView;
}

- (void)pagerController:(XKPagerController *)pagerController currentView:(UIView *)currentView scrollToContentViewAtIndex:(NSInteger)index{
    XKCaptureMetadataContentView * contentView = (XKCaptureMetadataContentView*)currentView;
    self.captureMetadataController.captureMode = contentView.captureMode;
    self.tabBarMenu.selectIndex = index;
}

#pragma mark -懒加载
- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView = [UIView new];
        _navigationView.backgroundColor = [UIColor blackColor];
    }
    return _navigationView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"媒体捕捉";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}

- (UIButton *)torchModeButton{
    if (!_torchModeButton) {
        _torchModeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_torchModeButton setImage:[UIImage imageNamed:@"pn_icon_capture_lightoff"] forState:(UIControlStateNormal)];
        [_torchModeButton setImage:[UIImage imageNamed:@"pn_icon_capture_lighton"] forState:(UIControlStateSelected)];
        [_torchModeButton addTarget:self action:@selector(onTouchModeButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _torchModeButton;
}

//打开/关闭手电筒
- (void)onTouchModeButtonEvent:(UIButton*)sender{
    sender.selected = !sender.selected;
    [self.captureMetadataController openTorch:sender.selected];
}

- (XKTabBarMenu *)tabBarMenu{
    if (!_tabBarMenu) {
        WeakSelf(ws);
        _tabBarMenu = [XKTabBarMenu tabBarMenu:@[@"二维码",@"拍照",@"连拍"] tabBarIndexBlock:^(NSInteger index) {
            [ws.pagerController scrollToContentViewAtIndex:index animate:NO];
        }];
        _tabBarMenu.selectColor = [UIColor whiteColor];
        _tabBarMenu.backgroundColor = [UIColor blackColor];
    }
    return _tabBarMenu;
}

- (XKPagerController*)pagerController{
    if (!_pagerController) {
        _pagerController = [XKPagerController new];
        _pagerController.dataSource = self;
        _pagerController.backgroundColor = [UIColor clearColor];
        _pagerController.displayScrollView.backgroundColor = [UIColor clearColor];
    }
    return _pagerController;
}

- (XKCaptureMetadataController*)captureMetadataController{
    if (!_captureMetadataController) {
        WeakSelf(ws);
        _captureMetadataController = [[XKCaptureMetadataController alloc] initWithFrame:CGRectMake(0, INVALID_VIEW_HEIGHT + 50, SCREEN_WIDTH, SCREEN_HEIGHT - INVALID_VIEW_HEIGHT - 50)];
        _captureMetadataController.isAllowSaveAlbum = YES;
        _captureMetadataController.onCaptureMetadataResultBlock = ^(XKCaptureMetadataMode captureMode, id  _Nonnull resultData) {
            if (ws.isDisappear) return; //防止多次Push
            XKCaptureMetadataResultsViewController * vc = [XKCaptureMetadataResultsViewController new];
            vc.resultDatas = resultData;
            [ws.navigationController pushViewController:vc animated:YES];
        };
    }
    return _captureMetadataController;
}

- (void)setIsDisappear:(BOOL)isDisappear{
    _isDisappear = isDisappear;
    if (!_isDisappear) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.captureMetadataController.isCaptureLock = _isDisappear;
        });
    }
    else{
        self.captureMetadataController.isCaptureLock = _isDisappear;
    }
}
@end
