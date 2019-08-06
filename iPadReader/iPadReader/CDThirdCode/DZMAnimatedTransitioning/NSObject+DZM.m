//
//  NSObject+DZM.m
//  DZMAnimatedTransitioning
//
//  Created by 邓泽淼 on 2017/12/22.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#import "NSObject+DZM.h"
#import <objc/runtime.h>

static const NSString *isATTarget = @"isATTarget";

@implementation NSObject (DZM)

- (void)setATTarget:(UIView *)ATTarget {
    
    objc_setAssociatedObject(self, &isATTarget, ATTarget, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)ATTarget {
    
    return objc_getAssociatedObject(self, &isATTarget);
}

@end
