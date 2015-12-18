//
//  WSAvatar.m
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSAvatar.h"

@implementation WSAvatar

- (instancetype) init {
    if (self = [super init]) {
        self.imageName = @"none";
        self.image = nil;
    }
    return self;
}

- (instancetype)initWithImageName:(NSString *)imageName {
    if ( self = [super init])
    {
        self.imageName = imageName;
        //self.image = [UIImage imageNamed:imageName];
    }
    
    return self;
}

@end
