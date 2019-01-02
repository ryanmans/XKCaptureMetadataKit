//
//  XKCaptureAreaAnimationView.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKCaptureAreaAnimationView.h"

@interface XKCaptureAreaAnimationView ()
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)BOOL isBottom;
@property(nonatomic,strong)UIImageView * lineView;
@end

@implementation XKCaptureAreaAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * cor1 = [self imageName:@"icon_scan_qrcode_ul_001"];
        UIImageView * cor2 = [self imageName:@"icon_scan_qrcode_ul_002"];
        UIImageView * cor3 = [self imageName:@"icon_scan_qrcode_ul_003"];
        UIImageView * cor4 = [self imageName:@"icon_scan_qrcode_ul_004"];
        [self addSubview:cor1];
        [self addSubview:cor2];
        [self addSubview:cor3];
        [self addSubview:cor4];
        [self addSubview:self.lineView];
        
        WeakSelf(ws);
        [cor1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws);
            make.top.equalTo(ws);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [cor2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws);
            make.top.equalTo(ws);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [cor3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws);
            make.bottom.equalTo(ws);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [cor4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws);
            make.bottom.equalTo(ws);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws);
            make.left.equalTo(ws);
            make.right.equalTo(ws);
            make.height.mas_equalTo(3);
        }];
        
        [self layoutIfNeeded];
        
    }
    return self;
}

//动画
- (void)setIsAnimate:(BOOL)isAnimate{
    _isAnimate = isAnimate;
    _lineView.hidden = !_isAnimate;
    if (_isAnimate) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineAnimateEvent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }else{
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        self.isBottom = NO;
        self.lineView.y = 10;
    }
}

//动画
- (void)lineAnimateEvent{
    if (!self.isBottom) {
        self.lineView.y += 3;
        if (self.lineView.y >= self.height - 10) {
            self.isBottom = YES;
        }
    }
    else if (self.isBottom){
        self.lineView.y -= 3;
        if (self.lineView.y <= 10) {
            self.isBottom = NO;
        }
    }
}
#pragma mark -- 懒加载
- (UIImageView*)imageName:(NSString*)name{
    UIImageView * imageview = [UIImageView new];
    imageview.image = [UIImage imageNamed:name];
    return imageview;
}

- (UIImageView*)lineView{
    if (!_lineView) {
        _lineView = [UIImageView new];
        _lineView.hidden = YES;
        _lineView.image = [UIImage imageNamed:@"icon_scan_qrcode_line"];
    }
    return _lineView;
}
@end
