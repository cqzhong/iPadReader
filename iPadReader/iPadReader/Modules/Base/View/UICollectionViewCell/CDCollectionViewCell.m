//
//  CDCollectionViewCell.m
//  CDProgramme
//
//  Created by cqz on 2018/8/5.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDCollectionViewCell.h"

@implementation CDCollectionViewCell

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
-(void)cellSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
