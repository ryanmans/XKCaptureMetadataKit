//
//  XKPagerController.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKPagerController.h"

//分页视图
@interface XKPagerController()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * displayScrollView;
@end

@implementation XKPagerController
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _visibleContentViews = [NSMutableDictionary dictionary];
        [self addSubview:self.displayScrollView];
        
        WeakSelf(ws);
        [self.displayScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws);
        }];
        
        [self layoutIfNeeded];
    }
    return self;
}

//数据刷新(最好是一次性操作,重载)
- (void)reloadData{
    //页面数据总数
    NSInteger totalCount = [self.dataSource numberOfContentViewsInPagerController];
    //更新contentSize
    _displayScrollView.contentSize = CGSizeMake(_displayScrollView.width * totalCount, _displayScrollView.height);
    
    if (_visibleContentViews.count) { //如果有页面视图，先delete
        [_visibleContentViews enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UIView *  _Nonnull obj, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_visibleContentViews removeAllObjects];
    }
    
    for (NSInteger index = 0;index < totalCount ; index ++) {
        [self layoutSubViewsWithSuperView:_displayScrollView index:index];
    }
    
    [self scrollViewDidScroll:self.displayScrollView];
}

//更新数据(适合统一的子页面)
- (void)updateData{
    //页面数据总数
    NSInteger totalCount = [self.dataSource numberOfContentViewsInPagerController];
    
    //更新contentSize
    _displayScrollView.contentSize = CGSizeMake(_displayScrollView.width * totalCount, _displayScrollView.height);
    
    if (_visibleContentViews.count > totalCount) { //如果有页面视图较多,则隐藏
        
        [_visibleContentViews enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, UIView *  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSInteger index = key.integerValue;
            
            obj.hidden = index >= totalCount;
        }];
    }
    [self scrollViewDidScroll:self.displayScrollView];
}

//页面布局
- (UIView *)layoutSubViewsWithSuperView:(UIView*)superView index:(NSInteger)index{
    
    //获取视图
    NSString * key = [NSString stringWithFormat:@"%ld",index];
    
    UIView * visibleItem = _visibleContentViews[key];
    
    if (!visibleItem) {
        
        //获取视图
        visibleItem = [self.dataSource pagerController:self contentViewForIndex:index];
        
        visibleItem.frame = CGRectMake(superView.width * index, 0, superView.width, superView.height);
        
        _visibleContentViews[key] = visibleItem;
        
        [superView addSubview:visibleItem];
    }
    return visibleItem;
}

//MARK:滚动切换
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = (NSInteger) scrollView.contentOffset.x / scrollView.width;
    
    //当前页面
    UIView * visibleItem = [self layoutSubViewsWithSuperView:scrollView index:_currentIndex];
    if ([self.dataSource respondsToSelector: @selector(pagerController:currentView:scrollToContentViewAtIndex:)]) {
        [self.dataSource pagerController:self currentView:visibleItem scrollToContentViewAtIndex:_currentIndex];
    }
}

//获取下标位置的内容页面
- (UIView*)contentViewOfIndex:(NSInteger)index{
    
    //获取视图
    NSString * key = [NSString stringWithFormat:@"%ld",index];
    
    UIView * visibleItem = _visibleContentViews[key];
    
    return visibleItem;
}

//设置滚动事件
- (void)scrollToContentViewAtIndex:(NSInteger)index animate:(BOOL)animate{
    
    [self.displayScrollView setContentOffset:CGPointMake(self.displayScrollView.width * index, 0) animated:animate];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.displayScrollView.frame = self.bounds;
    if (_visibleContentViews.count) {
        [_visibleContentViews enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIView * _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSInteger index = key.integerValue;
            obj.frame = CGRectMake(self.displayScrollView.width * index, 0, self.displayScrollView.width, self.displayScrollView.height);
        }];
    }
}

#pragma mark - 懒加载 -
- (UIScrollView*)displayScrollView
{
    if (!_displayScrollView) {
        _displayScrollView = [UIScrollView new];
        _displayScrollView.delegate = self;
        _displayScrollView.bounces = NO;
        _displayScrollView.pagingEnabled = YES;
        _displayScrollView.showsVerticalScrollIndicator = NO;
        _displayScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _displayScrollView;
}

- (void)dealloc{
    _displayScrollView = nil;
}
@end
