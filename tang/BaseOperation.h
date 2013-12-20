//
//  BaseOperation.h
//  tang
//
//  Created by maoyu on 13-12-18.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

#define ROOT_URL @"http://www.laotangguan.com/"

@protocol BaseOperationDelegate;

@interface BaseOperation : NSObject

@property (nonatomic, retain) id <BaseOperationDelegate> delegate;

- (BOOL)startRequest:(id <BaseOperationDelegate>)delegate;

- (ASIHTTPRequest *)createRequest;
- (void)requestDidFinish:(ASIHTTPRequest *)request;

- (id)initWithCurrentLoggedInUser;

@end

@protocol BaseOperationDelegate

- (void)didSuceeded:(BaseOperation *)operation;
- (void)didFailed:(BaseOperation *)operation;

@end