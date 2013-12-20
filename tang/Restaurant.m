//
//  Restaurant.m
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"拍照";
        self.phone = @"";
        self.address = @"";
        self.image = nil;
        self.coordinate = @"";
        self.description = @"";
    }
    return self;
}

@end
