//
//  CDCollectionViewCell.h
//  CDProgramme
//
//  Created by cqz on 2018/8/5.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDCollectionViewCell : UICollectionViewCell

-(UIViewController *)cd_viewController;
-(void)cellSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//-(void)cellSelectRowWithObj:(id)obj;

@end
