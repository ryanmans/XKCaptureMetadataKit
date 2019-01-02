//
//  XKPagerController.h
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKPagerController;
@protocol XKPagerControllerDataSource <NSObject>

@required

//多少个内容视图
- (NSInteger)numberOfContentViewsInPagerController;

//下标对应返回视图(不可nil)
- (UIView *)pagerController:(XKPagerController *)pagerController contentViewForIndex:(NSInteger)index;

@optional

//滚动视图回调
- (void)pagerController:(XKPagerController *)pagerController currentView:(UIView*)currentView scrollToContentViewAtIndex:(NSInteger)index;

@end


//分页视图（最好是分页页面布局一致，可不一致，但不提倡，本类没有设置不同布局的重用机制）
@interface XKPagerController : UIView
@property (nonatomic, weak, nullable) id<XKPagerControllerDataSource> dataSource;
@property (nonatomic, strong, readonly) UIScrollView * displayScrollView;
@property (nonatomic, assign, readonly) NSInteger currentIndex;// default 0
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *,UIView*> *visibleContentViews;//key: currentIndex->string

//数据刷新（重载）
- (void)reloadData;

//数据更新（重载）
- (void)updateData;

//获取下标位置的内容页面
- (nullable UIView*)contentViewOfIndex:(NSInteger)index;

//页面滚动
- (void)scrollToContentViewAtIndex:(NSInteger)index animate:(BOOL)animate;
@end

NS_ASSUME_NONNULL_END
