//
//  CDUIView.m
//  CDProgramme
//
//  Created by cqz on 2018/8/6.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDUIView.h"

@interface CDUIView ()


@end

@implementation CDUIView

#pragma mark - Intial Methods

#pragma mark - Target Methods

#pragma mark - Public Methods

#pragma mark - Private Method

#pragma mark - Setter Getter Methods
-(UIViewController *)cd_viewController {
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}
@end
