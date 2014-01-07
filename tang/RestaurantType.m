//
//  RestaurantType.m
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "RestaurantType.h"
#import "FileManager.h"

#define FilenameOfRestaurantType @"RestaurantType.plist"
#define KeyTypeId       @"id"
#define KeyTypeName     @"name"

@implementation RestaurantType

#pragma 静态函数
+ (NSArray *)getTypes {
    return [[FileManager defaultManager] getDataWithFilename:FilenameOfRestaurantType];
}

+ (BOOL)saveTypes:(NSArray *)types {
    return [[FileManager defaultManager] addData:types withFilename:FilenameOfRestaurantType];
}

+ (RestaurantType *)getTypeWithTypeId:(NSInteger)typeId {
    NSArray * types = [RestaurantType getTypes];
    RestaurantType * type = nil;
    if (nil != types) {
        for (RestaurantType * tmpType in types) {
            if (tmpType.typeId == typeId) {
                type = tmpType;
                break;
            }
        }
    }
    
    return type;
}

+ (RestaurantType *)fromDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        RestaurantType * type = [[RestaurantType alloc] init];
        type.typeId = [[dictionary objectForKey:KeyTypeId] integerValue];
        type.name = [dictionary objectForKey:KeyTypeName];
        
        return type;
    }else{
        return nil;
    }
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.typeId] forKey:KeyTypeId];
    [encoder encodeObject:self.name forKey:KeyTypeName];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.typeId = [[aDecoder decodeObjectForKey:KeyTypeId] integerValue];
        self.name = [aDecoder decodeObjectForKey:KeyTypeName];
    }
    return self;
}

@end
