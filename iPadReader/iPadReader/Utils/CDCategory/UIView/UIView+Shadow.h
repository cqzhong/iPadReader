//
//  UIView+Shadow.h
//  CDProgramme
//
//  Created by 庆中 on 2018/7/27.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CDShadowEdge) {
    CDShadowEdgeNone   = 0,
    CDShadowEdgeTop    = 1 << 0,
    CDShadowEdgeLeft   = 1 << 1,
    CDShadowEdgeBottom = 1 << 2,
    CDShadowEdgeRight  = 1 << 3,
    CDShadowEdgeAll    = CDShadowEdgeTop | CDShadowEdgeLeft | CDShadowEdgeBottom | CDShadowEdgeRight
};

@interface UIView (Shadow)

- (void)addShadowWithPosition:(CDShadowEdge)edge;
- (void)removeShadowPath;
- (void)addShadowWithPosition:(CDShadowEdge)edge shadowRadius: (CGFloat)shadowRadius cornerRadius: (CGFloat)cornerRadius;

- (void)shadowCornerRadius:(CGFloat)cornerRadius;

- (void)addShadow;

/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view shadowColor: (UIColor *)shadowColor
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius;
@end
