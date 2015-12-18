//
//  WSAvatarManager.m
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSAvatarManager.h"
#import "WSAvatar.h"
#import "FileUtils.h"

@interface WSAvatarManager ()

@property (copy, nonatomic, readwrite) NSMutableArray * mutableAvatars;
//@property (copy, nonatomic) NSArray * imageNames;
@end

@implementation WSAvatarManager

- (id)init {
    if (self = [super init]) {
        [self loadAvatars];
    }
    
    return self;
}

- (void) loadAvatars {
    _mutableAvatars = [NSMutableArray array];
    
    NSEnumerator * enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[FileUtils WSDocumentsDirectory]];
    NSString * avatarPath;
    
    while ((avatarPath = [enumerator nextObject]) != nil) {
        NSString * extension = [[avatarPath pathExtension] lowercaseString];
        
        if ([extension isEqualToString:@"jpg"]
            || [extension isEqualToString:@"jpeg"]) {
            UIImage * image = [UIImage imageWithContentsOfFile:[[FileUtils WSDocumentsDirectory] stringByAppendingPathComponent:avatarPath]];
            if (fabs(image.size.width - image.size.height) < 0.01) {
                WSAvatar * avatar = [[WSAvatar alloc] init];
                avatar.imageName = [[FileUtils WSDocumentsDirectory] stringByAppendingPathComponent:avatarPath];
                [_mutableAvatars addObject:avatar];
            }
        }
    }
    
    /*_mutableAvatars = (NSMutableArray *)[_mutableAvatars sortedArrayUsingComparator:^NSComparisonResult(WSAvatar * avt1, WSAvatar * avt2) {
        return [[avt1.imageName lastPathComponent] compare:[avt2.imageName lastPathComponent]];
    }];*/
}

- (NSArray *)avatars {
    return [NSArray arrayWithArray:self.mutableAvatars];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    if (index < _mutableAvatars.count) {
        WSAvatar * avatar = _mutableAvatars[index];
        if ([FileUtils deleteFileAtDocumentsDirectoryWithName:[avatar.imageName lastPathComponent]])
        {
            [_mutableAvatars removeObjectAtIndex:index];
        } else {
            NSLog(@"delete avatar %@ failed", avatar.imageName);
        }
    }
}

- (void)addAvatar:(NSData *)avatar {
    
    NSString * fileName = [[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] stringByAppendingString:@".jpg"];
    
    if ([FileUtils writeFileAtDocumentsDirectoryWithName:fileName withData:avatar]) {
        WSAvatar * avatar = [[WSAvatar alloc] init];
        avatar.imageName = [[FileUtils WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
        [_mutableAvatars addObject:avatar];
        /*_mutableAvatars = (NSMutableArray *)[_mutableAvatars sortedArrayUsingComparator:^NSComparisonResult(WSAvatar* avt1, WSAvatar * avt2) {
            return [[avt1.imageName lastPathComponent] compare:[avt2.imageName lastPathComponent]];
        }];*/
        NSLog(@"add avatar %@ successed", fileName);

    }
}

@end
