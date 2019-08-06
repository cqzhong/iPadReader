//
//  CDCollectionViewFlowLayout.h
//  CDProgramme
//
//  Created by cqz on 2018/9/12.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDCollectionViewFlowLayout : UICollectionViewFlowLayout

// 每行显示几个
@property (nonatomic) NSUInteger itemCountRow;
// 显示多少行
@property (nonatomic) NSUInteger rowCount;

@property (nonatomic, strong) NSMutableArray *allAttributes;


@end
