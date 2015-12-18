//
//  FileUtils.h
//  FaceOff
//
//  Created by ZRY on 15/12/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+ (NSString *) WSHomeDirectory;
+ (NSString *) WSDocumentsDirectory;
+ (NSString *) WSTmpDirectory;
+ (NSString *) WSCacheDirectory;
+ (NSString *) WSLibraryDirectory;
+ (BOOL) createFileAtDocumentsDirectory:(NSString *)fileName;
+ (BOOL) createDirectoryAtDocumentsDirectory:(NSString *)directoryName;
+ (BOOL) isFileExistsAtDocumentsDirectory:(NSString *)fileName;
+ (BOOL) writeFileAtDocumentsDirectoryWithName:(NSString *)fileName withContent:(NSString *)content;
+ (NSString *) readFileContentAtDocumentsDirectoryWithName:(NSString *)fileName;
+ (BOOL) deleteFileAtDocumentsDirectoryWithName:(NSString *)fileName;
+ (BOOL) writeFileAtDocumentsDirectoryWithName:(NSString *)fileName withData:(NSData *)data;

@end
