//
//  UIDevice+XK.h
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (XK)

//相机授权状态
+ (BOOL)isCameraAuthorizationStatus;

//相机弹窗授权
+ (void)cameraAuthorizationAlert;

//相册弹窗授权
+ (void)albumAuthorizationAlert;

//检查 App 是否有相机操作授权
+ (void)pn_HandleCameraValidEvent:(void(^)(void))block;

//检查 App 是否有相册操作授权
+ (void)pn_HandlePhotosAlbumValidEvent:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
