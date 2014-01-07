//
//  FileManager.m
//  tang
//
//  Created by maoyu on 13-12-30.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (FileManager *)defaultManager {
    static FileManager * fileManager = nil;
    if (nil == fileManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            fileManager = [[FileManager alloc] init];
        });
    }
    
    return fileManager;
}

#pragma 私有函数
- (NSString *)documentDirectory{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)imagePath{
    NSString * rootDirectory = [self documentDirectory];
    return [rootDirectory stringByAppendingPathComponent:@"image"];
}

- (NSString *)dataPath:(NSString *)filename {
    NSString * rootDirectory = [self documentDirectory];
    return [rootDirectory stringByAppendingPathComponent:filename];
}

- (NSString *)timeStringWithSuffix:(NSString *)suffix{

    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSString * now = [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@.%@", now, suffix];
}

#pragma 类成员函数
- (NSString *)addImage:(UIImage *)image {
    if (nil == image) {
        return nil;
    }
    NSString * fileName = [self timeStringWithSuffix:DefaultImageExtension];
    NSData * data = UIImageJPEGRepresentation(image,0.3);
    [data writeToFile:[[self imagePath] stringByAppendingString:fileName] atomically:YES];
    
    return fileName;
}

- (UIImage *)getImageWithFilename:(NSString *)filename {
    if (nil == filename) {
        return nil;
    }
    NSString * url = [[self imagePath] stringByAppendingString:filename];
    NSData * data = [NSData dataWithContentsOfFile:url];
    
    if (nil == data) {
        return nil;
    }
    
    return [UIImage imageWithData:data];
}

- (NSData *)getImageDataWithFilename:(NSString *)filename {
    if (nil == filename) {
        return nil;
    }
    NSString * url = [[self imagePath] stringByAppendingString:filename];
    NSData * data = [NSData dataWithContentsOfFile:url];
    
    return data;
}

- (BOOL)addData:(NSArray *)data withFilename:(NSString *)filename {
    if (nil == data || nil == filename) {
        return NO;
    }
    
    return [NSKeyedArchiver archiveRootObject:data toFile:[self dataPath:filename]];
}

- (NSArray *)getDataWithFilename:(NSString *)filename {
    if (nil == filename) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile: [self dataPath:filename]];
}

@end
