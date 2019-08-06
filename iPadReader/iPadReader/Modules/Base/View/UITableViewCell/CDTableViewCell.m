//
//  CDTableViewCell.m
//  CDProgramme
//
//  Created by cqz on 2018/8/5.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDTableViewCell.h"

@implementation CDTableViewCell


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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)cellSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)reloadDataWithDic:(NSDictionary *)msgDic {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
