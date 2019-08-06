//
//  CDGestureTableView.m
//  CDProgramme
//
//  Created by cqz on 2018/10/19.
//  Copyright © 2018 ChangDao. All rights reserved.
//

#import "CDGestureTableView.h"

@implementation CDGestureTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
