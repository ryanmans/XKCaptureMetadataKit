//
//  XKCaptureMetadataController.h
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//扫描模式
typedef NS_ENUM(NSInteger, XKCaptureMetadataMode) {
    XKCaptureMetadataModeCode = 0, //二维码
    XKCaptureMetadataModePhoto= 1, //拍照
    XKCaptureMetadataModeContinuous, //连拍
};

//相机扫描器
@interface XKCaptureMetadataController : UIView
@property (nonatomic,assign)XKCaptureMetadataMode captureMode; //模式
@property (nonatomic,assign)BOOL isCaptureLock; //图像捕捉锁,yes, 则不返回图片(控制连拍频率)
@property (nonatomic,assign)BOOL isAllowSaveAlbum; //拍照的时候,是否允许保存相册
@property (nonatomic,copy)void(^onCaptureMetadataResultBlock)(XKCaptureMetadataMode captureMode, id resultData);

//开始
- (void)startRunning;

//结束
- (void)stopRunning;

//拍照
- (void)takingPictures;

//打开/关闭 手电筒
- (void)openTorch:(BOOL)isopen;

@end

NS_ASSUME_NONNULL_END
