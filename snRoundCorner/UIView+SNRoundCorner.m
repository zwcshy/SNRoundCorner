//
//  UIView+SNRoundCorner.m
//  SnobMass
//
//  Created by 绝影 on 16/8/2.
//  Copyright © 2016年 卷瓜. All rights reserved.
//

#import "UIView+SNRoundCorner.h"
#import <objc/runtime.h>
#import <SDWebImage/SDImageCache.h>

@interface UIView()

@property (nonatomic, strong) CALayer *sn_maskLayer;

@end

@implementation UIView (SNRoundCorner)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL selectors[] = {
            @selector(layoutSubviews),
            @selector(setFrame:),
        };
        
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"sn_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            
            BOOL addedSuccess = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
            if (addedSuccess)
            {
                class_replaceMethod(self, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            }
            else
            {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

- (void)sn_layoutSubviews
{
    if (self.sn_roundCornerColor && self.sn_roundCornerRadius > 0 && !self.sn_maskLayer)
    {
        [self addRoundCorner];
    }
    [self sn_layoutSubviews];
}

- (void)sn_setFrame:(CGRect)frame
{
    [self sn_setFrame:frame];
    if (self.sn_maskLayer)
    {
        if (!CGSizeEqualToSize(frame.size, self.sn_maskLayer.frame.size))
        {
            [self.sn_maskLayer removeFromSuperlayer];
            self.sn_maskLayer = nil;
        }
    }
}

#pragma mark - 添加分类属性
- (UIColor *)sn_roundCornerColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSn_roundCornerColor:(UIColor *)sn_roundCornerColor
{
    objc_setAssociatedObject(self, @selector(sn_roundCornerColor), sn_roundCornerColor, OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)sn_roundCornerRadius
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSn_roundCornerRadius:(CGFloat)sn_roundCornerRadius
{
    objc_setAssociatedObject(self, @selector(sn_roundCornerRadius), @(sn_roundCornerRadius), OBJC_ASSOCIATION_RETAIN);
}

- (CALayer *)sn_maskLayer
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSn_maskLayer:(CALayer *)sn_maskLayer
{
    objc_setAssociatedObject(self, @selector(sn_maskLayer), sn_maskLayer, OBJC_ASSOCIATION_RETAIN);
}

/**
 *  根据当前图片当前返回一个经过处理之后的圆角图片
 */
- (void)addRoundCorner
{
    // 这段代码的作用是保证只添加一次
    if (self.sn_maskLayer)
    {
        NSString *reason = @"这个属性只允许设置一次，再次设置不会生效";
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
    }
    else
    {
        [self.layer addSublayer:[self createMaskImageView]];
    }
}

- (CALayer *)createMaskImageView
{

    NSString *imageCacheKey = [NSString stringWithFormat:@"%@%@%@",@"snob_mass_roundImage",NSStringFromCGSize(self.bounds.size),[self rgbStringWithColor:self.sn_roundCornerColor]];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageCacheKey];
    if (image)
    {
        self.sn_maskLayer = [CALayer layer];
        self.sn_maskLayer.shouldRasterize = YES;
        self.sn_maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
        self.sn_maskLayer.frame = self.bounds;
        self.sn_maskLayer.contents = (id)image.CGImage;
        return self.sn_maskLayer;
    }
    else
    {
        CALayer *roundLayer = [CALayer layer];
        roundLayer.frame = self.bounds;
        roundLayer.backgroundColor = self.sn_roundCornerColor.CGColor;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        
        // 画圆
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        maskLayer.fillRule =  kCAFillRuleEvenOdd;
        [path appendPath:[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.sn_roundCornerRadius]];
        maskLayer.path = path.CGPath;
        roundLayer.mask = maskLayer;
        
        CGSize size = roundLayer.bounds.size;
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        [roundLayer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 缓存图片
        [[SDImageCache sharedImageCache] storeImage:tempImage forKey:imageCacheKey toDisk:NO];
        self.sn_maskLayer = roundLayer;
        return self.sn_maskLayer;
    }
}

#pragma mark - 获取当前颜色的rgb值
- (NSString *)rgbStringWithColor:(UIColor *)color
{
    CGColorRef colorRef = color.CGColor;
    NSInteger numComponents = CGColorGetNumberOfComponents(colorRef);
    NSMutableString *stringM = [NSMutableString string];
    for (int i = 0; i < numComponents; i++)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        [stringM appendString:@(components[i]).stringValue];
    }
    return [stringM copy];
}

@end
