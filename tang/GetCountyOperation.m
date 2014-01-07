//
//  GetCountyOperation.m
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "GetCountyOperation.h"
#import "County.h"

@implementation GetCountyOperation

- (ASIHTTPRequest *)createRequest {
    NSString * strUrl = [NSString stringWithFormat:@"%@%@", ROOT_URL, @"county/index"];
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setPostValue:@"1" forKey:@"Json"];
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"getCounty" forKey:@"request"]];
    
    return request;
}

- (void)requestDidFinish:(ASIHTTPRequest *)request {
    NSString * requestType = [request.userInfo objectForKey:@"request"];
    if ([requestType isEqualToString:@"getCounty"]) {
        NSDictionary * result = [[request responseData] objectFromJSONData];
        if (nil == result) {
            [self.delegate didFailed:self];
        }else {
            if ([[result objectForKey:@"code"] integerValue] == 0) {
                NSArray * tmpCounties = [result objectForKey:@"data"];
                self.counties = [[NSMutableArray alloc] initWithCapacity:1];
                for (NSDictionary* dictCounty in tmpCounties) {
                    [self.counties addObject:[County fromDictionary:dictCounty]];
                }
                
                [County saveCounties:self.counties];
                
                [self.delegate didSuceeded:self];
            }
        }
    }
}

- (void)requestDidFail:(ASIHTTPRequest *)request {
    [self.delegate didFailed:self];
}

@end
