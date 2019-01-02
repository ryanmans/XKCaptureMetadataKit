//
//  XKCaptureMetadataController.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKCaptureMetadataController.h"
#import <AVFoundation/AVFoundation.h>

@interface XKCaptureMetadataController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic,strong)AVCaptureDevice * captureDevice;
@property (nonatomic,strong)AVCaptureDeviceInput * captureDeviceInput;
@property (nonatomic,strong)AVCaptureSession * captureSession;
//预览层
@property (nonatomic,strong)AVCaptureVideoPreviewLayer * previewLayer;

//实例化拍摄元数据输出(二维码)
@property (nonatomic,strong)AVCaptureMetadataOutput * captureMetadataOutput;

//输出流  //用于捕捉静态图片
@property (nonatomic,strong)AVCaptureStillImageOutput * stillImageOutput;
//原始视频帧，用于获取实时图像以及视频录制
@property (nonatomic, strong) AVCaptureVideoDataOutput * videoDataOutput;
@end

@implementation XKCaptureMetadataController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if ([self.captureSession canAddInput:self.captureDeviceInput])[self.captureSession addInput:self.captureDeviceInput];

        //二维码
        if ([self.captureSession canAddOutput:self.captureMetadataOutput])[self.captureSession addOutput:self.captureMetadataOutput];
        
        self.captureMetadataOutput.metadataObjectTypes = [self.captureMetadataOutput availableMetadataObjectTypes];

        //拍照
        if ([self.captureSession canAddOutput:self.stillImageOutput])[self.captureSession addOutput:self.stillImageOutput];

        //连拍
        if ([self.captureSession canAddOutput:self.videoDataOutput])[self.captureSession addOutput:self.videoDataOutput];

        [self.layer insertSublayer:self.previewLayer atIndex:0];
        
    }
    return self;
}

//设置模式
- (void)setCaptureMode:(XKCaptureMetadataMode)captureMode{
    _captureMode = captureMode;
    
    [_captureMetadataOutput setMetadataObjectsDelegate:_captureMode == XKCaptureMetadataModeCode ? self : nil queue:dispatch_get_main_queue()];

    [_videoDataOutput setSampleBufferDelegate:_captureMode == XKCaptureMetadataModeContinuous ? self : nil queue:dispatch_get_main_queue()];
}

//避免阻塞线程,异步开启
- (void)startRunning{
    if (self.captureSession.isRunning) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self.captureSession isRunning]) {
            [self.captureSession startRunning];
        }
    });
}

//避免阻塞线程,异步关闭
- (void)stopRunning{
    if (!self.captureSession.isRunning) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self.captureSession isRunning]) {
            [self.captureSession stopRunning];
        }
    });
}

//拍照
- (void)takingPictures{
    if (self.captureMode != XKCaptureMetadataModePhoto) return;
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    WeakSelf(ws);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        
        //单拍
        if (image && ws.onCaptureMetadataResultBlock){
             ws.onCaptureMetadataResultBlock(XKCaptureMetadataModePhoto, image);
            if (ws.isAllowSaveAlbum) {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
        }
    }];
}

//保存图片结果
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    XK_MakeToast(error ? @"保存图片失败" : @"保存图片成功", nil);
}

//打开/关闭 手电筒
- (void)openTorch:(BOOL)isopen{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        if ([self.captureDevice hasTorch] && [self.captureDevice hasFlash]){
            [self.captureDevice lockForConfiguration:nil];
            if (isopen) {
                [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
            } else {
                [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
            }
            [self.captureDevice unlockForConfiguration];
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate (二维码)
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count && self.captureMode == XKCaptureMetadataModeCode) {
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            if (self.onCaptureMetadataResultBlock) self.onCaptureMetadataResultBlock(XKCaptureMetadataModeCode, metadataObject.stringValue);
        }
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (!_isCaptureLock) {
        if (_captureMode == XKCaptureMetadataModeContinuous) { //连拍
            UIImage * image  = [self imageFromSampleBuffer:sampleBuffer];
            if (image && self.captureMode == XKCaptureMetadataModeContinuous)self.onCaptureMetadataResultBlock(XKCaptureMetadataModeContinuous, image);
        }
    }
}

//CMSampleBufferRef转NSImage
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    // 释放context和颜色空间
    CGContextRelease(context); CGColorSpaceRelease(colorSpace);
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    return (image);
}

#pragma mark --懒加载
- (AVCaptureDevice *)captureDevice{
    if (!_captureDevice) {
        _captureDevice =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}

- (AVCaptureDeviceInput *)captureDeviceInput{
    if (!_captureDeviceInput) {
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
    }
    return _captureDeviceInput;
}

//会话
- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [AVCaptureSession new];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _captureSession;
}

//预览层
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.layer.bounds;
    }
    return _previewLayer;
}

//元数据输出
- (AVCaptureMetadataOutput *)captureMetadataOutput{
    if (!_captureMetadataOutput) {
        _captureMetadataOutput = [AVCaptureMetadataOutput new];
        [_captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _captureMetadataOutput;
}

//捕捉静态图片
- (AVCaptureStillImageOutput *)stillImageOutput{
    if (!_stillImageOutput) {
        _stillImageOutput = [AVCaptureStillImageOutput new];
    }
    return _stillImageOutput;
}

//实时预览图片
- (AVCaptureVideoDataOutput *)videoDataOutput{
    if (!_videoDataOutput) {
        _videoDataOutput = [AVCaptureVideoDataOutput new];
        [_videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    return _videoDataOutput;
}
@end
