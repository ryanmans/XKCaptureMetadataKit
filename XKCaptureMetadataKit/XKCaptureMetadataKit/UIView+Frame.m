//
//  UIView+Frame.m
//  XKTrackNetWork
//
//  Created by Allen、 LAS on 2018/11/17.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x{
    CGRect r = self.frame;
    r.origin.x = x;
    self.frame = r;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y ;
    self.frame = rect;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width;{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect  rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)left{
    return self.x;
}

- (void)setLeft:(CGFloat)left{
    self.x = left;
}

- (CGFloat)right{
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right{
    self.x = right - self.width;
}

- (CGFloat)top{
    return self.y;
}

- (void)setTop:(CGFloat)top{
    self.y = top;
}

- (CGFloat)bottom{
    return self.y + self.height;
}

- (void)setBottom:(CGFloat)bottom{
    self.y = bottom - self.height;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin;{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

@end
