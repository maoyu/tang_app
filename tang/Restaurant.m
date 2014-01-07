//
//  Restaurant.m
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "Restaurant.h"
#import "FileManager.h"

#define FilenameOfRestaurant @"Restaurant.list"
static NSArray * sRestaurant = nil;

@interface Restaurant() {

}
@end

@implementation Restaurant

#pragma 静态函数
+ (NSArray *)getAllRestaurants {
    if (nil == sRestaurant) {
        sRestaurant = [[FileManager defaultManager] getDataWithFilename:FilenameOfRestaurant];
    }
    
    return sRestaurant;
}

+ (NSArray *)getUploadRestaurants {
    NSArray * allRestaurants = [self getAllRestaurants];
    
    NSMutableArray * uploadRestaurants = [[NSMutableArray alloc] initWithCapacity:1];
    for (Restaurant * restaurant in allRestaurants) {
        if (NO == restaurant.upload) {
            [uploadRestaurants addObject:restaurant];
        }
    }
    
    if (0 != [uploadRestaurants count]) {
        return uploadRestaurants;
    }
    
    return nil;
}

+ (BOOL)updateRestaurants {
    NSArray * restaurants = [Restaurant getAllRestaurants];
    return [[FileManager defaultManager] addData:restaurants withFilename:FilenameOfRestaurant];
}

#pragma 类成员函数
- (id)init {
    self = [super init];
    if (self) {
        self.restauntId = [[[NSDate alloc] init] timeIntervalSince1970];
        self.name = @"空店名";
        self.phone = @"";
        self.address = @"";
        self.coordinate = @"";
        self.description = @"";
        self.upload = NO;
        self.typeId = 1;    //默认牛肉汤
        self.countyId = 1;  //默认涧西区
        self.images = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (BOOL)addRestaurant {
    NSMutableArray * restaurants = (NSMutableArray *)[Restaurant getAllRestaurants];
    if (nil == restaurants) {
        restaurants = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    [restaurants addObject:self];
    return [[FileManager defaultManager] addData:restaurants withFilename:FilenameOfRestaurant];
}

- (BOOL)deleteRestaurant {
    NSMutableArray * restaurants = (NSMutableArray *)[Restaurant getAllRestaurants];
    if (nil != restaurants) {
        for (Restaurant * restaurant in restaurants) {
            if (restaurant.restauntId == self.restauntId) {
                [restaurants removeObject:self];
                break;
            }
        }
    }
    
    return [[FileManager defaultManager] addData:restaurants withFilename:FilenameOfRestaurant];

}

- (void)addImage:(NSString *)filename {
    if (nil == filename) {
        return;
    }
    [self.images removeAllObjects]; //暂时先这样写，以后添加多张时就删除掉
    [self.images addObject:filename];
}

#pragma NSCoding delegate
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithLongLong:self.restauntId] forKey:@"restauntId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.images forKey:@"images"];
    [encoder encodeObject:self.coordinate forKey:@"coordinate"];
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.typeId] forKey:@"typeId"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.countyId] forKey:@"countyId"];
    [encoder encodeObject:[NSNumber numberWithBool:self.upload] forKey:@"upload"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.restauntId = [[decoder decodeObjectForKey:@"restauntId"] longLongValue];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.images = [decoder decodeObjectForKey:@"images"];
        self.coordinate = [decoder decodeObjectForKey:@"coordinate"];
        self.description = [decoder decodeObjectForKey:@"description"];
        self.typeId = [[decoder decodeObjectForKey:@"typeId"] integerValue];
        self.countyId = [[decoder decodeObjectForKey:@"countyId"] integerValue];
        self.upload = [[decoder decodeObjectForKey:@"upload"] boolValue];
    }
    return self;
}

@end
