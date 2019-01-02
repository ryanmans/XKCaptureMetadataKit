//
//  UIView+Toast.m
//  XKPharmacy
//
//  Created by Allen、 LAS on 2018/11/7.
//  Copyright © 2018年 P.S. All rights reserved.
//

#import "UIView+Toast.h"

@interface XKToastView : UIView

@property (nonatomic,strong)UILabel * toastLabel;

+ (XKToastView*)xk_ToastView:(NSString*)toast;

@end

@implementation XKToastView

+ (XKToastView*)xk_ToastView:(NSString*)toast{
    
    XKToastView * toastView = [XKToastView new];
    toastView.toastLabel.text = toast;
    
    [toastView.toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toastView);
    }];
    [toastView.toastLabel layoutIfNeeded];
    
    toastView.width = toastView.toastLabel.width + 60;
    toastView.height = toastView.toastLabel.height + 30;
    
    return toastView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha = 0;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self addSubview:self.toastLabel];
    }
    return self;
}

- (UILabel*)toastLabel{
    if (!_toastLabel) {
        _toastLabel = [UILabel new];
        _toastLabel.numberOfLines = 0;
        _toastLabel.font = [UIFont systemFontOfSize:16];
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 80;
    }
    return _toastLabel;
}
@end

//时长
const double XK_TOAST_DURATION = 2;

//toast数组
static NSMutableArray * _toastQuerryArr;

@implementation UIView (Toast)

- (NSMutableArray*)toastQuerryArr{
    if (!_toastQuerryArr) {
        _toastQuerryArr = [NSMutableArray array];
    }
    return _toastQuerryArr;
}

//确保字符串为安全字符串
NSString * IsSafeString(NSString * str){
    return (str != nil && str.length != 0) ? str : @"";
}

//全局网络错误提示
void XK_MakeToast_NetError(){
    XK_MakeToast(@"您的网络开小差了，", @"请稍后重试！");
}

//全局toast使用
void XK_MakeToast(NSString * toast,NSString * detailText){
    [[UIApplication sharedApplication].keyWindow xk_MakeToast:toast detailText:detailText];
}

- (void)xk_MakeToast:(NSString *)toast detailText:(NSString * _Nullable)detailText{
    [self xk_MakeToast:(!detailText || detailText.length == 0) ? toast:[NSString stringWithFormat:@"%@\n%@",toast,IsSafeString(detailText)]];
}

- (void)xk_MakeToast:(NSString *)toast{
    [self xk_MakeToast:toast duration:XK_TOAST_DURATION];
}

- (void)xk_MakeToast:(NSString *)toast duration:(NSTimeInterval)duration{
    [self xk_MakeToast:toast duration:duration position:XKToastPositionMiddle];
}

- (void)xk_MakeToast:(NSString *)toast duration:(NSTimeInterval)duration position:(XKToastPosition) position{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self toastQuerryArr].count) { //防止多toast重叠
            [[self toastQuerryArr] enumerateObjectsUsingBlock:^(XKToastView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 0;
                [obj removeFromSuperview];
            }];
        }
        XKToastView * toastView = [XKToastView xk_ToastView:toast];
        [self addSubview:toastView];
        [[self toastQuerryArr] addObject:toastView];
        toastView.center = [self xk_centerByPosition:position];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toastView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 delay:duration options:0 animations:^{
                
                toastView.alpha = 0.0f;
                
            } completion:^(BOOL finished) {
                
                [toastView removeFromSuperview];
                
                [[self toastQuerryArr] removeObject:toastView];
                
            }];
        }];
    });
}

#pragma mark - private methods
/**
 *  根据给定的position找中心点
 *
 *  @param position 枚举类型，SUPToastPosition 上中下
 *
 *  @return 中心点
 */
-(CGPoint)xk_centerByPosition:(XKToastPosition)position{
    CGPoint center = CGPointZero;
    switch (position) {
        case XKToastPositionTop:
            center = CGPointMake(self.width / 2, 100);
            break;
            
        case XKToastPositionMiddle:
            center = CGPointMake(self.width / 2, self.height / 2);
            break;
            
        case XKToastPositionBottom:
            center = CGPointMake(self.width / 2, self.height - 100);
            break;
        default:
            break;
    }
    return center;
}

@end
