//
//  WSVerticalScrollMenuLayout.m
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSVerticalScrollMenuLayout.h"


static NSString * const WSMenuItemCellLayout = @"WSMenuItemCellLayout";
static NSString * const WSMenuItemTitleLayout = @"WSMenuItemTitleLayout";

@interface WSVerticalScrollMenuLayout ()

@property (strong, nonatomic) NSMutableDictionary * layoutInfo;

@end


@implementation WSVerticalScrollMenuLayout


#pragma mark - Initializers

- (instancetype) init {
    if (self = [super init]) {
        [self setupDefaults];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupDefaults];
    }
    
    return self;
}

#pragma mark - Overrides

- (void)prepareLayout {
    
    NSMutableDictionary * cellViewLayouts = [NSMutableDictionary dictionary];
    NSMutableDictionary * titleViewLayouts = [NSMutableDictionary dictionary];
    
    NSIndexPath * indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    
    for (NSInteger i = 0; i < numSections; ++i) {
        
        NSInteger numItems = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numItems; ++j) {
            
            indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes * cellLayoutAttributes = [UICollectionViewLayoutAttributes
                                                                       layoutAttributesForCellWithIndexPath:indexPath];
            
            UICollectionViewLayoutAttributes * titleViewLayoutAttributes = [UICollectionViewLayoutAttributes
                                                                            layoutAttributesForSupplementaryViewOfKind:@"title" withIndexPath:indexPath];
            cellLayoutAttributes.frame = [self frameForCellWithIndexPath:indexPath];
            titleViewLayoutAttributes.frame = [self frameForTitleWithIndexPath:indexPath];
            
            cellViewLayouts[indexPath] = cellLayoutAttributes;
            titleViewLayouts[indexPath] = titleViewLayoutAttributes;
        }
    }
    
    self.layoutInfo[WSMenuItemCellLayout] = cellViewLayouts;
    self.layoutInfo[WSMenuItemTitleLayout] = titleViewLayouts;
}

- (NSArray *)layoutAttributesForElementInRect:(CGRect)rect {
    NSMutableArray * resultLayoutAttributes = [NSMutableArray array];
    
    for (NSString * key in self.layoutInfo) {
        NSDictionary * typeLayoutInfo = self.layoutInfo[key];
        
        for (NSIndexPath * indexPath in typeLayoutInfo) {
            UICollectionViewLayoutAttributes * layoutAttributes = typeLayoutInfo[indexPath];
            if (CGRectIntersectsRect(rect, layoutAttributes.frame)) {
                [resultLayoutAttributes addObject:layoutAttributes];
            }
        }
    }
    
    return resultLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInfo[WSMenuItemCellLayout][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInfo[WSMenuItemTitleLayout][indexPath];
}

#pragma Accessors

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self invalidateLayout];
}


- (void)setInterItemSpacingX:(CGFloat)interItemSpacingX {
    _interItemSpacingX = interItemSpacingX;
    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight {
    _titleHeight = titleHeight;
    [self invalidateLayout];
}

- (CGSize)collectionViewContentSize {
    NSInteger numItems = [self.collectionView numberOfItemsInSection:0];
    //CGFloat width = self.edgeInsets.left + (self.itemSize.width + self.interItemSpacingX) * numItems - self.interItemSpacingX + self.edgeInsets.right;
    //CGFloat height = self.edgeInsets.top + self.itemSize.height + self.titleHeight + self.edgeInsets.bottom;
    
    CGFloat width = self.edgeInsets.left + self.itemSize.width + self.edgeInsets.right;
    
    CGFloat height = self.edgeInsets.top + (self.itemSize.height + self.interItemSpacingX) * numItems - self.interItemSpacingX + self.edgeInsets.bottom;
    
    return CGSizeMake(width, height);
}

#pragma mark - Helper methods

- (CGRect)frameForCellWithIndexPath:(NSIndexPath *)indexPath {
    //CGRect frame = CGRectMake(self.edgeInsets.left + (self.itemSize.width + self.interItemSpacingX) * indexPath.row, self.edgeInsets.top, self.itemSize.width, self.itemSize.height);
    CGRect frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top + (self.itemSize.height + self.interItemSpacingX) * indexPath.row, self.itemSize.width, self.itemSize.height);
    return frame;
}

- (CGRect)frameForTitleWithIndexPath:(NSIndexPath *)indexPath {
    CGRect frame = [self frameForCellWithIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    return frame;
}

- (void)setupDefaults {
    self.layoutInfo = [NSMutableDictionary dictionary];
    self.edgeInsets = UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f);
    self.sectionInset = UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f);
    self.itemSize = CGSizeMake(50.0f, 50.0f);
    self.interItemSpacingX = 20.0f;
    self.titleHeight = 20.0f;
}

@end
