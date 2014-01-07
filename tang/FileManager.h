//
//  FileManager.h
//  tang
//
//  Created by maoyu on 13-12-30.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultImageExtension               @"jpg"

@interface FileManager : NSObject

+ (FileManager *)defaultManager;

- (NSString *)documentDirectory;

- (NSString *)addImage:(UIImage *)image;
- (UIImage *)getImageWithFilename:(NSString *)filename;
- (NSData *)getImageDataWithFilename:(NSString *)filename;

- (BOOL)addData:(NSArray *)data withFilename:(NSString *)filename;
- (NSArray *)getDataWithFilename:(NSString *)filename;

@end
