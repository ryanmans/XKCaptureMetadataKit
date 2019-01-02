//
//  XKCaptureMetadataContentView.h
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKCaptureMetadataController.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKCaptureMetadataContentView : UIView
@property (nonatomic,assign)XKCaptureMetadataMode captureMode; //模式
@property (nonatomic,copy)void(^onCapturePhotoBlock)(void); //点击拍照

//扫描中
- (BOOL)isRunning;

//开始
- (void)startRunning;

//结束
- (void)stopRunning;

@end

NS_ASSUME_NONNULL_END
