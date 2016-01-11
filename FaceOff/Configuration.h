//
//  Configuration.h
//  CoreAlgorithmTest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Configuration : NSObject

@property (nonatomic, readonly) NSString * machineType;
@property (nonatomic, readonly) CGRect leftRect;
@property (nonatomic, readonly) CGRect rightRect;
@property (nonatomic, readonly) CGRect topRect;
@property (nonatomic, readonly) NSInteger backgroundColorThresh;
@property (nonatomic, readonly) CGSize minAvatarSize;
@property (nonatomic, readonly) CGSize maxAvatarSize;
@property (nonatomic, readonly) NSInteger fontSize;
@property (nonatomic, readonly) CGFloat scale;

+(id)sharedConfiguration;

@end
