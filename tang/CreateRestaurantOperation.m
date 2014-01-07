//
//  CreateRestaurantOperation.m
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "CreateRestaurantOperation.h"

@interface CreateRestaurantOperation () {

}

@end

@implementation CreateRestaurantOperation

- (id)initWithRestaurant:(Restaurant *)restaurant {
    if (self = [super initWithCurrentLoggedInUser]) {
        self.restaurant = restaurant;
    }
    
    return self;
}

- (ASIHTTPRequest *)createRequest {
    NSString * strUrl = [NSString stringWithFormat:@"%@%@", ROOT_URL, @"restaurant/create"];
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setPostValue:self.restaurant.name forKey:@"Restaurant[name]"];
    [request setPostValue:self.restaurant.phone forKey:@"Restaurant[phone]"];
    [request setPostValue:self.restaurant.address forKey:@"Restaurant[address]"];
    [request setPostValue:[NSNumber numberWithInteger:self.restaurant.typeId] forKey:@"Restaurant[type_id]"];
    [request setPostValue:[NSNumber numberWithInteger:self.restaurant.countyId] forKey:@"Restaurant[county_id]"];
    [request setPostValue:self.restaurant.coordinate forKey:@"Restaurant[coordinate]"];
    [request setPostValue:self.restaurant.description forKey:@"Restaurant[description]"];
    [request setPostValue:@"1" forKey:@"Json"];
    if (nil != self.restaurant.images && [self.restaurant.images count] > 0) {
        NSInteger size = [self.restaurant.images count];
        NSString * filename;
        for (NSInteger index = 0; index < size; index++) {
            filename = [self.restaurant.images objectAtIndex:index];
            [request setData:[[FileManager defaultManager] getImageDataWithFilename:filename] withFileName:filename andContentType:nil forKey:@"Restaurant[image_url]"];
        }
    }
    
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

- (void)requestDidFail:(ASIHTTPRequest *)request {
    [self.delegate didFailed:self];
}
@end
