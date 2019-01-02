//
//  XKCaptureMetadataResultsViewController.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKCaptureMetadataResultsViewController.h"

@interface XKCaptureMetadataResultsViewController ()
@property (nonatomic,strong)UILabel * qrcodeLabel;
@property (nonatomic,strong)UIImageView * imageView;

@end

@implementation XKCaptureMetadataResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"扫描结果";
    
    [self.view addSubview:self.qrcodeLabel];
    [self.view addSubview:self.imageView];

    WeakSelf(ws);
    [self.qrcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(80);
        make.left.equalTo(ws.view).offset(20);
        make.right.equalTo(ws.view).offset(-20);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.qrcodeLabel.mas_bottom).offset(20);
        make.left.equalTo(ws.view).offset(20);
        make.right.equalTo(ws.view).offset(-20);
        make.height.mas_equalTo(250);
    }];

    [self.view layoutIfNeeded];
    
    if ([self.resultDatas isKindOfClass:[NSString class]]) {
        self.qrcodeLabel.text = [NSString stringWithFormat:@"二维码链接: %@",(NSString*)_resultDatas];
        [self QRCodeMethod:self.qrcodeLabel.text];
    }
    
    if ([self.resultDatas isKindOfClass:[UIImage class]]) {
        self.imageView.image = (UIImage*)_resultDatas;
    }
}

#pragma mark - 生成二维码的方法
- (void)QRCodeMethod:(NSString *)qrCodeString {
    
    UIImage * qrcodeImg = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:qrCodeString] withSize:250.0f];
    // ** 将生成的
    self.imageView.image = qrcodeImg;
}

#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

#pragma mark -懒加载
- (UILabel *)qrcodeLabel{
    if (!_qrcodeLabel) {
        _qrcodeLabel = [UILabel new];
        _qrcodeLabel.numberOfLines = 0;
        _qrcodeLabel.font = [UIFont systemFontOfSize:16];
        _qrcodeLabel.textColor = [UIColor blackColor];
        _qrcodeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _qrcodeLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}
@end
