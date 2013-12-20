//
//  Restaurant.h
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (nonatomic, weak) NSString * name;
@property (nonatomic, weak) NSString * phone;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSData * image;
@property (nonatomic, copy) NSString * coordinate;
@property (nonatomic, weak) NSString * description;

- (id)init;

@end
