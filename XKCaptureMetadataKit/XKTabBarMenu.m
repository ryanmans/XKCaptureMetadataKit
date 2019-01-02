//
//  XKTabBarMenu.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKTabBarMenu.h"

@interface XKTabBarMenu ()
@property (nonatomic,assign)NSInteger preIndex;
@property (nonatomic,strong)UIView * sliderView;
@property (nonatomic,strong)NSMutableArray * allItems;
@property (nonatomic,copy)onTabBarIndexBlock block;
@end

@implementation XKTabBarMenu
+ (XKTabBarMenu*)tabBarMenu:(NSArray<NSString*>*)items tabBarIndexBlock:(onTabBarIndexBlock)tabBarIndexBlock{
    XKTabBarMenu * tabBarMenu = [XKTabBarMenu new];
    tabBarMenu.block = tabBarIndexBlock;
    [tabBarMenu layoutSubItems:items];
    return tabBarMenu;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _preIndex = -1;
        _selectIndex = 0;
        _allItems = [NSMutableArray array];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//设置菜单
- (void)layoutSubItems:(NSArray*)items{
    
    WeakSelf(ws);
    [items enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * tabButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        tabButton.tag = idx;
        tabButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [tabButton setTitle:obj forState:(UIControlStateNormal)];
        [tabButton setTitleColor:Hex_color(0x999999) forState:UIControlStateNormal];
        [tabButton addTarget:self action:@selector(onTabButtonEvent:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:tabButton];
        [ws.allItems addObject:tabButton];
    }];
    
    // 实现masonry水平固定间隔方法
    [self.allItems mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    // 设置array的垂直方向的约束
    [self.allItems mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws);
        make.height.equalTo(ws);
    }];
    
    [self addSubview:self.sliderView];
    
    __block  UIButton * sender = (UIButton*)self.allItems.firstObject;
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 2));
        make.centerX.equalTo(sender.mas_centerX);
        make.bottom.equalTo(ws);
    }];
    
    [self layoutIfNeeded];
}

- (void)onTabButtonEvent:(UIButton*)sender{
    if (self.block) self.block(sender.tag);
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    if (_preIndex == _selectIndex) return;
    _preIndex = _selectIndex;
    WeakSelf(ws);
    [self.allItems enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == ws.selectIndex) {
            [obj setTitleColor:_selectColor ? _selectColor : Hex_color(0x0066FF) forState:(UIControlStateNormal)];
            [UIView animateWithDuration:0.20 animations:^{
                ws.sliderView.centerX =  obj.centerX;
            }];
        }
        else{
            [obj setTitleColor:Hex_color(0x999999) forState:(UIControlStateNormal)];
        }
    }];
}

- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
    _sliderView.backgroundColor = _selectColor;
    self.selectIndex = _selectIndex;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    [self.allItems enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleLabel.font = _font;
    }];
}

- (UIView*)sliderView{
    if (!_sliderView) {
        _sliderView = [UIView new];
        _sliderView.backgroundColor = Hex_color(0x0066FF);
    }
    return _sliderView;
}
@end
