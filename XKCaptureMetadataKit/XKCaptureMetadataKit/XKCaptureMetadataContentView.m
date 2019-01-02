//
//  XKCaptureMetadataContentView.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKCaptureMetadataContentView.h"
#import "XKCaptureAreaAnimationView.h"

@interface XKCaptureMetadataContentView ()
@property(nonatomic,strong)UIView * backgroundView;
@property(nonatomic,strong)UIButton * photoButton;
@property(nonatomic,strong)XKCaptureAreaAnimationView * captureAreaAnimationView;
@end
@implementation XKCaptureMetadataContentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.photoButton];

        WeakSelf(ws);
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws);
        }];
        
        [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws);
            make.bottom.equalTo(ws.mas_bottom).offset(-44);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
        
        CGRect bezierPathRect = CGRectMake(20, 25, self.width - 40, self.height - 200);
        
        //绘制矩形
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [bezierPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:bezierPathRect cornerRadius:0] bezierPathByReversingPath]];
        CAShapeLayer * shapeLayer = [CAShapeLayer new];
        shapeLayer.path = bezierPath.CGPath;
        self.backgroundView.layer.mask = shapeLayer;
        
        _captureAreaAnimationView = [[XKCaptureAreaAnimationView alloc] initWithFrame:bezierPathRect];
        [self addSubview:_captureAreaAnimationView];
        
        [self layoutIfNeeded];
        
    }
    return self;
}

- (void)setCaptureMode:(XKCaptureMetadataMode)captureMode{
    _captureMode = captureMode;
    if (_captureMode == XKCaptureMetadataModePhoto) {  //拍照
        _photoButton.hidden = NO;
        if ([self isRunning]) [self stopRunning];
    }
    else{
        _photoButton.hidden = YES;
        if (![self isRunning]) [self startRunning];
    }
}

//扫描中
- (BOOL)isRunning{
    return _captureAreaAnimationView.isAnimate;
}

//开始
- (void)startRunning{
    if (self.captureMode != XKCaptureMetadataModePhoto) {
        _captureAreaAnimationView.isAnimate = YES;
    }
}

//结束
- (void)stopRunning{
    if (_captureMode == XKCaptureMetadataModePhoto) {
        _captureAreaAnimationView.isAnimate = NO;
    }
}

#pragma mark - 懒加载
- (UIView*)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = RGBA(0, 0, 0, 0.69);
    }
    return _backgroundView;
}

- (UIButton*)photoButton{
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.hidden = YES;
        [_photoButton setImage:[UIImage imageNamed:@"pn_icon_capture_camera"] forState:(UIControlStateNormal)];
        [_photoButton addTarget:self action:@selector(onClickPhotoButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _photoButton;
}

- (void)onClickPhotoButtonEvent:(UIButton*)sender{
    if (self.onCapturePhotoBlock) self.onCapturePhotoBlock();
}
@end
