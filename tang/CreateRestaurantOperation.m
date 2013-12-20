//
//  CreateRestaurantOperation.m
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "CreateRestaurantOperation.h"

@interface CreateRestaurantOperation () {
    Restaurant * _restaurant;
}

@end

@implementation CreateRestaurantOperation

- (id)initWithRestaurant:(Restaurant *)restaurant {
    if (self = [super initWithCurrentLoggedInUser]) {
        _restaurant = restaurant;
    }
    
    return self;
}

- (ASIHTTPRequest *)createRequest {
    NSString * strUrl = [NSString stringWithFormat:@"%@%@", ROOT_URL, @"restaurant/create"];
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setPostValue:_restaurant.name forKey:@"Restaurant[name]"];
    [request setPostValue:_restaurant.phone forKey:@"Restaurant[phone]"];
    [request setPostValue:_restaurant.address forKey:@"Restaurant[address]"];
    [request setPostValue:_restaurant.coordinate forKey:@"Restaurant[coordinate]"];
    [request setPostValue:_restaurant.description forKey:@"Restaurant[description]"];
    [request setPostValue:@"1" forKey:@"Json"];
    [request setData:_restaurant.image withFileName:@"maoyu.jpg" andContentType:nil forKey:@"Restaurant[image_url]"];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"createRestaurant" forKey:@"request"]];
    
    return request;
}

- (void)requestDidFinish:(ASIHTTPRequest *)request {
    NSString * requestType = [request.userInfo objectForKey:@"request"];
    if ([requestType isEqualToString:@"createRestaurant"]) {
        NSString *responseData = [[NSString alloc] initWithData:[request responseData] encoding: NSASCIIStringEncoding];
        NSLog(@"%@", responseData);
        NSDictionary * result = [[request responseData] objectFromJSONData];
        if (nil == result) {
            [self.delegate didFailed:self];
        }else {
            if ([[result objectForKey:@"code"] integerValue] == 0) {
                [self.delegate didSuceeded:self];
            }
        }
    }
}
@end
