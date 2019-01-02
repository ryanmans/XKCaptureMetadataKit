//
//  UIColor+XK.h
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (XK)

/**
 获取rgba颜色
 
 @param r Red
 @param g Green
 @param b Blue
 @param a alpha
 @return UIColor
 */
UIColor * RGBA(CGFloat r , CGFloat g,CGFloat b ,CGFloat a);

/**
 获取rgb颜色
 
 @param r Red
 @param g Green
 @param b Blue
 @return UIColor
 */
UIColor * RGB(CGFloat r , CGFloat g,CGFloat b);

/**
 获取随机色
 
 @return UIColor
 */
UIColor * Arc4randomColor();

/**
 获取十六进制颜色
 
 @param rgbValue 十六进制
 @param a alpha
 @return UIColor
 */
UIColor * Hex_colorA(uint32_t rgbValue,CGFloat a);

/**
 获取十六进制颜色
 
 @param rgbValue 十六进制
 @return UIColor
 */
UIColor * Hex_color(uint32_t rgbValue);


@end

NS_ASSUME_NONNULL_END
