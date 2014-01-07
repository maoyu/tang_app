//
//  RestaurantType.h
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantType : NSObject<NSCoding>

@property (nonatomic) NSInteger typeId;
@property (nonatomic, strong) NSString * name;

+ (NSArray *)getTypes;
+ (BOOL)saveTypes:(NSArray *)types;

+ (RestaurantType *)getTypeWithTypeId:(NSInteger)typeId;

+ (RestaurantType *)fromDictionary:(NSDictionary *)dictionary;

@end
