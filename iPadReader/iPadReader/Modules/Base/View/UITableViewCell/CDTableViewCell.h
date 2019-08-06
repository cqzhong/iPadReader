//
//  CDTableViewCell.h
//  CDProgramme
//
//  Created by cqz on 2018/8/5.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "QMUITableViewCell.h"

@interface CDTableViewCell : QMUITableViewCell


-(UIViewController *)cd_viewController;

-(void)cellSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadDataWithDic:(NSDictionary *)msgDic;

@end
