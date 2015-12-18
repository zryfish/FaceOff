//
//  WSHorizontalScrollMenuLayout.h
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSHorizontalScrollMenuLayout : UICollectionViewLayout

@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) CGFloat interItemSpacingX;
@property (assign, nonatomic) CGFloat titleHeight;

@end
