//
//  FileUtils.m
//  FaceOff
//
//  Created by ZRY on 15/12/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

//- 获取应用沙盒根目录
+(NSString *)WSHomeDirectory {
    return NSHomeDirectory();
}

//获取Documents目录
+(NSString *)WSDocumentsDirectory{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//获取Tmp目录
+(NSString *)WSTmpDirectory{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSString *tmpDirectory = NSTemporaryDirectory();
    return tmpDirectory;
}

//获取Cache目录
+(NSString *)WSCacheDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    return cacheDirectory;
}

//获取Library目录
+(NSString *)WSLibraryDirectory{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}

#pragma mark --Documents下的文件操作
//得到Documents里的文件路径
+ (NSString *)getFilePathAtDocumentsDirectory:(NSString *)fileName{
    return [[self WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
}

//删除Documents里的文件
+ (BOOL)deleteFileAtDocumentsDirectoryWithName:(NSString *)fileName{
    NSString *filePath = [[self WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath])
    {
        return NO;
    }
    [fileManager removeItemAtPath:filePath error:nil];
    return YES;
}

//创建指定名字的文件
+ (BOOL)createFileAtDocumentsDirectory:(NSString *)fileName{
    NSString *filePath = [[self WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        return YES;
    }
    return NO;
}

//创建指定名字的文件夹
+ (BOOL)createDirectoryAtDocumentsDirectory:(NSString *)fileName{
    NSString *filePath = [[self WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        NSError *error = nil;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        return YES;
    }
    return NO;
}

//文件是否存在
+ (BOOL)isFileExistsAtDocumentsDirectory:(NSString *)fileName{
    NSString *filePath = [[self WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
    NSLog(@"check on path %@", filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        return NO;
    }
    return YES;
}

//写文件
+(BOOL)writeFileAtDocumentsDirectoryWithName:(NSString *) fileName withContent:(NSString *)content{
    
    NSString *iOSPath = [[self WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [content writeToFile:iOSPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isSuccess;
}

+ (BOOL) writeFileAtDocumentsDirectoryWithName:(NSString *)fileName withData:(NSData *)data {
    NSString * iOSPath = [[self WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [data writeToFile:iOSPath atomically:YES];
    NSLog(@"writed to %@", iOSPath);
    return isSuccess;
}

//读文件
+ (NSString*)readFileContentAtDocumentsDirectoryWithName:(NSString*)fileName{
    NSString *filePath = [[self WSDocumentsDirectory] stringByAppendingPathComponent:fileName];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

@end
