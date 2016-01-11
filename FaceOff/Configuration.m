//
//  Configuration.m
//  CoreAlgorithmTest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "Configuration.h"
#import <sys/utsname.h>

@interface Configuration()

@property (nonatomic, readwrite) NSString* machineType;
@property (nonatomic, readwrite) CGRect leftRect;
@property (nonatomic, readwrite) CGRect rightRect;
@property (nonatomic, readwrite) CGRect topRect;
@property (nonatomic, readwrite) NSInteger backgroundColorThresh;
@property (nonatomic, readwrite) CGSize minAvatarSize;
@property (nonatomic, readwrite) CGSize maxAvatarSize;
@property (nonatomic, readwrite) NSInteger fontSize;
@property (nonatomic, readwrite) CGFloat scale;

@end

@implementation Configuration

+ (id)sharedConfiguration {
    static Configuration * sharedConfiguration = nil;
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
        sharedConfiguration = [[self alloc] init];
    //});
    
    return sharedConfiguration;
}

- (id)init {
    if (self = [super init]) {
        struct utsname systemInfo;
        uname(&systemInfo);
        
        self.machineType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        NSString * errorDesc = nil;
        NSPropertyListFormat format;
        NSString * plistPath;
        NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"Rectangles.plist"];
        
        if (![[NSFileManager defaultManager] contentsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"Rectangles" ofType:@"plist"];
        }
        
        NSData * plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary * temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML
                                             mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                             format:&format
                                             errorDescription:&errorDesc];
        
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %lu\n", errorDesc, (unsigned long)format);
        }
        
        NSLog(@"Machine Type is %@", self.machineType);
        self.machineType = @"iPhone7,1";
        
        NSDictionary * typeData = (NSDictionary *)[temp objectForKey:self.machineType];
        
        self.leftRect = [self rectWithArray:[typeData objectForKey:@"LeftRectangle"]];
        
        NSLog(@"rect %f %f %f %f\n", self.leftRect.origin.x, self.leftRect.origin.y, self.leftRect.size.width, self.leftRect.size.height );
        
        self.rightRect = [self rectWithArray:[typeData objectForKey:@"RightRectangle"]];
        self.topRect = [self rectWithArray:[typeData objectForKey:@"TopRectangle"]];
        self.backgroundColorThresh = [[temp objectForKey:@"BackgroundThreshold"] integerValue];
        self.fontSize = 1;
        self.scale = [UIScreen mainScreen].scale;
        
        NSArray * minAvatarArray = [temp objectForKey:@"MinAvatarSize"];
        NSArray * maxAvatarArray = [temp objectForKey:@"MaxAvatarSize"];
        if ([self.machineType isEqualToString:@"iPhone8,2"]
            || [self.machineType isEqualToString:@"iPhone7,1"]) {
            minAvatarArray = [temp objectForKey:@"MinAvatarSize2"];
            maxAvatarArray = [temp objectForKey:@"MaxAvatarSize2"];
            self.fontSize = 2;
        }
        self.minAvatarSize = CGSizeMake( [minAvatarArray[0] floatValue], [minAvatarArray[1] floatValue]);
        self.maxAvatarSize = CGSizeMake( [maxAvatarArray[0] floatValue], [maxAvatarArray[1] floatValue]);
        
    }
    
    return self;
}

- (CGRect)rectWithArray:(NSArray *)array {
    if (!array) {
        return CGRectZero;
    }
    
    return CGRectMake([array[0] floatValue],
                      [array[1] floatValue],
                      [array[2] floatValue],
                      [array[3] floatValue]);

}

@end
