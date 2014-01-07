//
//  County.h
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface County : NSObject<NSCoding>

@property (nonatomic) NSInteger countyId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic) NSInteger type;


+ (NSArray *)getCounties;
+ (BOOL)saveCounties:(NSArray *)counties;

+ (County *)getCountyWithId:(NSInteger)countyId;

+ (County *)fromDictionary:(NSDictionary *)dictionary;
@end
