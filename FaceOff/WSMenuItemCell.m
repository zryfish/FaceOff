//
//  WSMenuItemCell.m
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSMenuItemCell.h"

@implementation WSMenuItemCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma mark - Overrides

- (void) prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
