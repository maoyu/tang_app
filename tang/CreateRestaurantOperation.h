//
//  CreateRestaurantOperation.h
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "BaseOperation.h"
#import "Restaurant.h"

@interface CreateRestaurantOperation : BaseOperation

- (id)initWithRestaurant:(Restaurant *)restaurant;

@end
