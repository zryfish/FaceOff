//
//  WSAvatar.h
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WSAvatar : NSObject

@property (copy, nonatomic) NSString * imageName;
@property (assign, nonatomic) UIImage * image;

- (id)initWithImageName:(NSString *)imageName;

@end
