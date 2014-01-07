//
//  UploadRestaurantManager.m
//  tang
//
//  Created by maoyu on 14-1-4.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "UploadRestaurantManager.h"

@interface UploadRestaurantManager () {
    CreateRestaurantOperation * _op;
}

@end

@implementation UploadRestaurantManager

+ (UploadRestaurantManager *)defaultManager {
    static UploadRestaurantManager * uploadRestaurantManager = nil;
    if (nil == uploadRestaurantManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            uploadRestaurantManager = [[UploadRestaurantManager alloc] init];
        });
    }
    
    return uploadRestaurantManager;
}

- (BOOL)startUpload {
    if (nil != self.restaurants && 0 != [self.restaurants count]) {
        Restaurant * restaurant  = [self.restaurants objectAtIndex:0];
        _op = [[CreateRestaurantOperation alloc] initWithRestaurant:restaurant];
        [_op startRequest:self];
        return YES;
    }
    
    return NO;
}

#pragma BaseOperationDelegate
- (void)didSuceeded:(CreateRestaurantOperation *)operation {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(uploadSuceeded:)]) {
        operation.restaurant.upload = YES;
        [_delegate performSelector:@selector(uploadSuceeded:) withObject:operation.restaurant];
    }
    
    [_restaurants removeObjectAtIndex:0];
    
    if (NO == [self startUpload]) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(uploadFinished)]) {
            [_delegate performSelector:@selector(uploadFinished)];
        }
        
        [Restaurant updateRestaurants];
    }
}

- (void)didFailed:(CreateRestaurantOperation *)operation {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(uploadFailed:)]) {
        [_delegate performSelector:@selector(uploadFailed:) withObject:operation.restaurant];
    }
    
//    [_restaurants removeObjectAtIndex:0];
//    
//    //继续上传
//    if (NO == [self startUpload]) {
//        if (_delegate != nil && [_delegate respondsToSelector:@selector(uploadFinished)]) {
//            [_delegate performSelector:@selector(uploadFinished)];
//        }
//    }
}


@end
