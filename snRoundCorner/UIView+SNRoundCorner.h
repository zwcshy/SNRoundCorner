//
//  UIView+SNRoundCorner.h
//  snRoundCorner
//
//  Created by 周文超 on 2017/8/29.
//  Copyright © 2017年 超超. All rights reserved.
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
