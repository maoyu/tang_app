//
//  County.m
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "County.h"
#import "FileManager.h"

#define FilenameOfRestaurantType @"County.plist"
#define KeyCountyId       @"id"
#define KeyCountyName     @"name"
#define keyCountyType     @"type"

@implementation County

+ (NSArray *)getCounties {
    return [[FileManager defaultManager] getDataWithFilename:FilenameOfRestaurantType];
}

+ (BOOL)saveCounties:(NSArray *)counties {
    return [[FileManager defaultManager] addData:counties withFilename:FilenameOfRestaurantType];
}

+ (County *)getCountyWithId:(NSInteger)countyId {
    NSArray * counties = [County getCounties];
    County * county = nil;
    if (nil != counties) {
        for (County * tmpCounty in counties) {
            if (tmpCounty.countyId == countyId) {
                county = tmpCounty;
                break;
            }
        }
    }
    
    return county;
}

+ (County *)fromDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        County * county = [[County alloc] init];
        county.countyId = [[dictionary objectForKey:KeyCountyId] integerValue];
        county.name = [dictionary objectForKey:KeyCountyName];
        county.type = [[dictionary objectForKey:keyCountyType] integerValue];
        return county;
    }else{
        return nil;
    }
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.countyId] forKey:KeyCountyId];
    [encoder encodeObject:self.name forKey:KeyCountyName];
    [encoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:keyCountyType];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.countyId = [[decoder decodeObjectForKey:KeyCountyId] integerValue];
        self.name = [decoder decodeObjectForKey:KeyCountyName];
        self.type = [[decoder decodeObjectForKey:keyCountyType] integerValue];
    }
    return self;
}


@end
