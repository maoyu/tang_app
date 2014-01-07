//
//  GetRestaurantTypeOperation.m
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "GetRestaurantTypeOperation.h"
#import "RestaurantType.h"

@implementation GetRestaurantTypeOperation

- (ASIHTTPRequest *)createRequest {
    NSString * strUrl = [NSString stringWithFormat:@"%@%@", ROOT_URL, @"restaurantType/index"];
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setPostValue:@"1" forKey:@"Json"];
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"getRestaurantType" forKey:@"request"]];
    
    return request;
}

- (void)requestDidFinish:(ASIHTTPRequest *)request {
    NSString * requestType = [request.userInfo objectForKey:@"request"];
    if ([requestType isEqualToString:@"getRestaurantType"]) {
        NSDictionary * result = [[request responseData] objectFromJSONData];
        if (nil == result) {
            [self.delegate didFailed:self];
        }else {
            if ([[result objectForKey:@"code"] integerValue] == 0) {
                NSArray * tmpTypes = [result objectForKey:@"data"];
                self.types = [[NSMutableArray alloc] initWithCapacity:1];
                for (NSDictionary* dictType in tmpTypes) {
                    [self.types addObject:[RestaurantType fromDictionary:dictType]];
                }
                
                [RestaurantType saveTypes:self.types];
                
                [self.delegate didSuceeded:self];
            }
        }
    }
}

- (void)requestDidFail:(ASIHTTPRequest *)request {
    [self.delegate didFailed:self];
}


@end
