//
//  DZMAnimatedTransitioning.m
//  DZMAnimatedTransitioning
//
//  Created by 邓泽淼 on 2017/12/20.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#define DZM_TAG_COVER 888

#import "DZMAnimatedTransitioning.h"

@interface DZMAnimatedTransitioning()

@property (nonatomic, assign) UINavigationControllerOperation operation;

@property (nonatomic, assign, readonly) float duration;

@end

@implementation DZMAnimatedTransitioning

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation {
    
    return [self initWithOperation:operation duration:1.0];
}

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation duration:(float)duration{
    
    self = [super init];
    
    if (self) {
        
        _duration = duration;
        
        _operation = operation;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.operation == UINavigationControllerOperationPush) {
        
        [self push:transitionContext];
        
    }else if (self.operation == UINavigationControllerOperationPop) {
        
        [self pop:transitionContext];
        
    }else{}
}

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    UIView *fromView = (from.ATTarget != nil ? from.ATTarget : from.view);
    
    CGRect rect = [fromView convertRect:fromView.bounds toView:containerView];
    
    
    UIView *contentView = [self GetImageView:[self screenCapture:to.view]];
    
    contentView.frame = rect;
    
    if (fromView.layer.cornerRadius > 0.0) {
        
        contentView.layer.cornerRadius = fromView.layer.cornerRadius;
        
        contentView.layer.masksToBounds = YES;
    }
    
    [containerView addSubview:contentView];
    
    
    UIImageView *coverView = [self GetImageView: [self screenCapture:fromView]];
    
    coverView.tag = DZM_TAG_COVER;
    
    coverView.frame = CGRectMake(rect.origin.x - (rect.size.width / 2), rect.origin.y, rect.size.width, rect.size.height);
    
    [containerView addSubview:coverView];
    
    
    coverView.layer.anchorPoint = CGPointMake(0, 0.5);
    
    coverView.opaque = YES;
    
    
    CATransform3D transform = CATransform3DMakeRotation(-M_PI_2 , 0.0, 1.0, 0.0);
    
    transform.m34 = 1.0f / 500.0f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        coverView.frame = to.view.bounds;
        
        contentView.frame = to.view.bounds;
        
        coverView.layer.transform = transform;
        
    } completion:^(BOOL finished) {
        
        coverView.image = nil;
        
        coverView.hidden = YES;
        
        [contentView removeFromSuperview];
        
        [containerView addSubview:to.view];
        
        [transitionContext completeTransition:YES];
    }];
    
}

- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext {
    //还是要执行安全拦截
//    QMUICMI.preventConcurrentNavigationControllerTransitions = true;
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:to.view];
    
    UIView *toView = (to.ATTarget != nil ? to.ATTarget : to.view);
    CGRect rect = [toView convertRect:toView.bounds toView:containerView];
    
    UIView *contentView = [self GetImageView:[self screenCapture:from.view]];
    
    contentView.frame = from.view.bounds;
    
    if (toView.layer.cornerRadius > 0.0) {
        
        contentView.layer.cornerRadius = toView.layer.cornerRadius;
        
        contentView.layer.masksToBounds = YES;
    }
    
    [containerView addSubview:contentView];
    
    
    UIImageView *coverView = [containerView viewWithTag:DZM_TAG_COVER];
    
    coverView.image = [self screenCapture:toView];
    
    coverView.hidden = NO;
    
    [containerView addSubview:coverView];
    
    
    CATransform3D transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
    
    transform.m34 = 1.0f / 500.0f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]  delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        contentView.frame = rect;
        
        coverView.frame = rect;
        
        coverView.layer.transform = transform;
        
    } completion:^(BOOL finished) {
        
        [coverView removeFromSuperview];
        
        [contentView removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
    
}

- (UIImageView *)GetImageView:(UIImage *)image {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.image = image;
    
    return imageView;
}

- (nullable UIImage *)screenCapture:(nullable UIView *)target {
    
    if (!target) { return nil; }
    
    UIGraphicsBeginImageContextWithOptions(target.frame.size, NO, 0.0);
    
    [target.layer renderInContext: UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

