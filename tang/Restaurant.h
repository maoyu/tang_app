//
//  Restaurant.h
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject<NSCoding>

@property (nonatomic) long long int restauntId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSMutableArray * images;
@property (nonatomic, strong) NSString * coordinate;
@property (nonatomic, strong) NSString * description;
@property (nonatomic) NSInteger typeId;
@property (nonatomic) NSInteger countyId;
@property (nonatomic) BOOL upload;

+ (NSArray *)getAllRestaurants;
+ (NSArray *)getUploadRestaurants;
+ (BOOL)updateRestaurants;

- (id)init;
- (void)addImage:(NSString *)filename;

- (BOOL)addRestaurant;
- (BOOL)deleteRestaurant;

@end
