//
//  DZMAnimatedTransitioning.h
//  DZMAnimatedTransitioning
//
//  Created by 邓泽淼 on 2017/12/20.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+DZM.h"

@interface DZMAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

/// 构造方法
- (instancetype _Nullable)initWithOperation:(UINavigationControllerOperation)operation;

/// 构造方法
- (instancetype _Nullable)initWithOperation:(UINavigationControllerOperation)operation duration:(float)duration;

@end
