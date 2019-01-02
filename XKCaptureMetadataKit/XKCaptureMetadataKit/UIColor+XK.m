//
//  UIColor+XK.m
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "UIColor+XK.h"

@implementation UIColor (XK)

//获取rgba颜色
UIColor * RGBA(CGFloat r , CGFloat g,CGFloat b ,CGFloat a){
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

//获取rgb颜色
UIColor * RGB(CGFloat r , CGFloat g,CGFloat b){
    return RGBA(r, g, b, 1.0);
}

//获取随机色
UIColor * Arc4randomColor(){
    return RGBA(arc4random() % 256,arc4random() % 256,arc4random() % 256,1.0f);
}

// 获取十六进制颜色
UIColor * Hex_colorA(uint32_t rgbValue,CGFloat a){
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)];
}

// 获取十六进制颜色
UIColor * Hex_color(uint32_t rgbValue){
    return Hex_colorA(rgbValue, 1.0);
}

@end
