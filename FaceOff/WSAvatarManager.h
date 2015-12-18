//
//  WSAvatarManager.h
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WSAvatarManager : NSObject

@property (copy, nonatomic, readonly) NSArray * avatars;

- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)addAvatar:(NSData *)avatar;

@end
