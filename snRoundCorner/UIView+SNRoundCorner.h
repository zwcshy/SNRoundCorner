//
//  UIView+SNRoundCorner.h
//  SnobMass
//
//  Created by 绝影 on 16/8/2.
//  Copyright © 2016年 卷瓜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SNRoundCorner)
/**
 *  圆角的颜色-这个颜色需要和背景颜色设置一致
 */
@property (nonatomic, strong)  UIColor *sn_roundCornerColor;

/**
 *  圆角的半径
 */
@property (nonatomic, assign)  CGFloat sn_roundCornerRadius;

@end
