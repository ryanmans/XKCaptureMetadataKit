//
//  UIView+Toast.h
//  XKPharmacy
//
//  Created by Allen、 LAS on 2018/11/7.
//  Copyright © 2018年 P.S. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XKToastPosition) {
    XKToastPositionTop = 0,
    XKToastPositionMiddle,
    XKToastPositionBottom,
};

@interface UIView (Toast)

/**
 *  网络错误提示消息(全局使用 window上的toast)
 *
 */
void XK_MakeToast_NetError();

/**
 *  提示消息(全局使用 window上的toast)
 *
 *  @param toast      提示文案
 *  @param detailText 提示文案
 */
void XK_MakeToast(NSString * toast,NSString * _Nullable detailText);

/**
 *  提示消息
 *
 *  @param toast      提示文案
 *  @param detailText 提示文案
 */
- (void)xk_MakeToast:(NSString *)toast detailText:(NSString * _Nullable)detailText;

/**
 *  提示消息
 *
 */
- (void)xk_MakeToast:(NSString *)toast;

/**
 *  提示消息
 *
 *  @param toast    提示文案
 *  @param duration 响应时长
 */
- (void)xk_MakeToast:(NSString *)toast duration:(NSTimeInterval)duration;

/**
 *  提示消息
 *
 *  @param toast    提示文案
 *  @param duration 响应时长
 *  @param position toast位置
 */
- (void)xk_MakeToast:(NSString *)toast duration:(NSTimeInterval)duration position:(XKToastPosition) position;

@end


NS_ASSUME_NONNULL_END
