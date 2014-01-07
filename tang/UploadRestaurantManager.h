//
//  UploadRestaurantManager.h
//  tang
//
//  Created by maoyu on 14-1-4.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateRestaurantOperation.h"

@protocol UploadRestaurantManagerDelegate <NSObject>

- (void)uploadSuceeded:(Restaurant *)restaurant;
- (void)uploadFailed:(Restaurant *)restaurant;
- (void)uploadFinished;

@end

@interface UploadRestaurantManager : NSObject<BaseOperationDelegate>

@property (nonatomic, strong) NSMutableArray * restaurants;
@property (nonatomic, strong) id<UploadRestaurantManagerDelegate> delegate;

+ (UploadRestaurantManager *)defaultManager;

- (BOOL)startUpload;

@end
