//
//  UIView+Shadow.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/27.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "UIView+Shadow.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat shadowSize = 3;


@implementation UIView (Shadow)
// 普通阴影。会离屏渲染，适用简单图层，
- (void)addShadow
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.25;//阴影透明度，默认0
    self.layer.shadowRadius = 3;//阴影半径，默认3
}

- (void)addShadowWithPosition:(CDShadowEdge)edge {
    
    CGRect shadowRect = self.bounds;
    
    if(edge & CDShadowEdgeTop) {
        shadowRect.size.height = shadowSize;
    }
    
    if(edge & CDShadowEdgeLeft) {
        shadowRect.size.width = shadowSize;
    }
    
    if(edge & CDShadowEdgeBottom) {
        shadowRect.origin.y = shadowRect.size.height;
        shadowRect.size.height = shadowSize;
    }
    
    if(edge & CDShadowEdgeRight) {
        shadowRect.origin.x = shadowRect.size.width;
        shadowRect.size.width = shadowSize;
    }

    self.layer.masksToBounds = false;
    self.layer.shadowRadius = 5;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.25;
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色

    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowRect].CGPath;
}
- (void)removeShadowPath {
    
    self.layer.shadowColor = [[UIColor clearColor] CGColor];
    self.layer.shadowPath = nil;
}

- (void)addShadowWithPosition:(CDShadowEdge)edge shadowRadius: (CGFloat)shadowRadius cornerRadius: (CGFloat)cornerRadius
{
    [self addShadowWithPosition: edge];
    self.layer.shadowRadius = shadowRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)shadowCornerRadius:(CGFloat)cornerRadius {
    
    [self roundCornerShadowsWithCornerRadius:cornerRadius shadowRadius:6.0 shadowColor:nil shadowOpacity:0.8];
}

- (void)roundCornerShadowsWithCornerRadius:(CGFloat)cornerRadius shadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity {
    
    if (!shadowColor) {
        shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.12f];
    }

    for (CALayer *layer in self.superview.layer.sublayers) {
        
        if (CGColorEqualToColor(layer.shadowColor, shadowColor.CGColor) &&
            CGRectEqualToRect(layer.frame, self.layer.frame)) {
            
            return;
        }
    }
    
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = self.layer.frame;
    
    shadowLayer.shadowColor = shadowColor.CGColor;
    shadowLayer.shadowOffset = CGSizeZero;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    [shadowLayer setShadowPath:[path CGPath]];
    //////// cornerRadius /////////
    [CDAppUtils bezierPathWithRoundedRect:self.bounds rectCorner:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius,cornerRadius) dealView:self];

    [self.superview.layer insertSublayer:shadowLayer below:self.layer];
}

/*
 周边加圆形阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view shadowColor: (UIColor *)shadowColor
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    if (!shadowColor) {
        shadowColor = [UIColor blackColor];
    }
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = view.layer.frame;
    shadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0, 0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius ///////// //离屏渲染
//    view.layer.cornerRadius = cornerRadius;
//    view.layer.masksToBounds = YES;
//    view.layer.shouldRasterize = YES;
//    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}
@end
