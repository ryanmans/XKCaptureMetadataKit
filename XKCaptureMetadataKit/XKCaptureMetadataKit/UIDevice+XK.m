//
//  UIDevice+XK.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "UIDevice+XK.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>

@implementation UIDevice (XK)

//应用名称
+ (NSString*)appName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

//相机授权状态
+ (BOOL)isCameraAuthorizationStatus{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied);
}

//相机弹窗授权
+ (void)cameraAuthorizationAlert{
    [UIDevice authorizationAlert:[NSString stringWithFormat:@"请在设备的\"设置-隐私-相机\"选项中，允许%@使用你的手机相机功能", [UIDevice appName]]];
}

//相册弹窗授权
+ (void)albumAuthorizationAlert{
    [UIDevice authorizationAlert:[NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", [UIDevice appName]]];
}

//授权弹窗
+ (void)authorizationAlert:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"知道了" style:0 handler:nil];
        [alertVC addAction:action];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"去设置" style:0 handler:^(UIAlertAction * _Nonnull action) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertVC addAction:action1];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    });
}

//检查 App 是否有相机操作授权
+ (void)pn_HandleCameraValidEvent:(void (^)(void))block{
    dispatch_async(dispatch_get_main_queue(), ^{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusAuthorized && block) block();
        else if (authStatus == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if (granted && block)block();
             }];
        }else{
            [UIDevice cameraAuthorizationAlert];
        }
    });
}

//检查 App 是否有相册操作授权
+ (void)pn_HandlePhotosAlbumValidEvent:(void (^)(void))block{
    dispatch_async(dispatch_get_main_queue(), ^{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
            if(block)block();
        }
        else {
            [UIDevice albumAuthorizationAlert];
        }
#else
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        if (authorizationStatus == ALAuthorizationStatusNotDetermined || authorizationStatus == ALAuthorizationStatusAuthorized) {
            if (block) block();
        }
        else {
            [UIDevice albumAuthorizationAlert];
        }
#endif
    });
}
@end
