//
//  WSMenuItemTitleView.m
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSMenuItemTitleView.h"

@interface WSMenuItemTitleView ()

@property (strong, nonatomic) UILabel * label;

@end

@implementation WSMenuItemTitleView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"Palatino" size:11];
        self.label.textColor = [UIColor whiteColor];
        
        [self addSubview:self.label];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.label.text = nil;
}

@end
