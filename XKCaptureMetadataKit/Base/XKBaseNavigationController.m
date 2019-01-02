//
//  XKBaseNavigationController.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKBaseNavigationController.h"

@interface XKBaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation XKBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:18]}];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

//拦截所有push的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) self.interactivePopGestureRecognizer.enabled = NO;
    
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0;
    
    if (self.viewControllers.count > 0) { //设置返回按钮 pn_icon_back
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pn_icon_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(onClickLeftBarButtonItem:)];
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:viewController animated:animated];
}

//返回
- (void)onClickLeftBarButtonItem:(UIBarButtonItem*)sender{
    [self popViewControllerAnimated:YES];
}

//导航将要展现控制器
- (void)navigationController:(UINavigationController*)navigationController didShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated{
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

//手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.viewControllers.count >= 2;
}

//允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//禁止响应手势的是否ViewController中scrollView跟着滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    return [gestureRecognizer isKindOfClass: UIScreenEdgePanGestureRecognizer.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
