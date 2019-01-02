//
//  XKBaseViewController.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKBaseViewController.h"

@interface XKBaseViewController ()

@end

@implementation XKBaseViewController
@synthesize isNavBarHiden  = _isNavBarHiden;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Hex_color(0xf5f4f8);
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden != _isNavBarHiden)[self.navigationController setNavigationBarHidden:_isNavBarHiden animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
