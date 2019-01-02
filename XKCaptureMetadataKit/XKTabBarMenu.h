//
//  XKTabBarMenu.h
//  XKCaptureMetadataKit
//
//  Created by ALLen、 LAS on 2019/1/2.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^onTabBarIndexBlock)(NSInteger index);

@interface XKTabBarMenu : UIView
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)UIColor * selectColor;
@property (nonatomic,strong)UIFont * font;
+ (XKTabBarMenu*)tabBarMenu:(NSArray<NSString*>*)items tabBarIndexBlock:(onTabBarIndexBlock)tabBarIndexBlock;
@end

NS_ASSUME_NONNULL_END
