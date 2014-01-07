//
//  BaseOperation.m
//  tang
//
//  Created by maoyu on 13-12-18.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "BaseOperation.h"
#import "User.h"

@interface BaseOperation() {
    NSString * _userName;
    NSString * _password;
    ASINetworkQueue * _networkQueue;
}

@end

@implementation BaseOperation

#pragma 私有函数
- (id)initWithUserName:(NSString *)userName
              password:(NSString*) passwrod {
    self = [super init];
    if (self) {
        _userName = userName;
        _password = passwrod;
    }
    return self;
}

- (id)initWithCurrentLoggedInUser{
    User * currentUser = [User currentUser];
    if (currentUser != nil &&
        currentUser.userName != nil) {
        return [self initWithUserName:currentUser.userName password:@"tang"];
    }else{
        return nil;
    }
}

- (void)addRequestHeader:(ASIHTTPRequest *) request {
    NSString * value = _userName;
    value = [value stringByAppendingString:@","];
    value = [value stringByAppendingString:_password];
    
    [request addRequestHeader:@"USER_AUTH_DATA" value:value];
    [request setTimeOutSeconds:5.0f];
}

- (void)initNetWorkQueue {
    _networkQueue = [[ASINetworkQueue alloc] init];
    _networkQueue.shouldCancelAllRequestsOnFailure = NO;
    _networkQueue.maxConcurrentOperationCount = 1;
    _networkQueue.delegate = self;
    [_networkQueue setRequestDidFinishSelector:@selector(requestDidFinish:)];
    [_networkQueue setRequestDidFailSelector:@selector(requestDidFail:)];
}

#pragma 类成员函数
- (BOOL)startRequest:(id <BaseOperationDelegate>) delegate
{
    ASIHTTPRequest *request = [self createRequest];
    
    self.delegate = delegate;
    
    [self initNetWorkQueue];
    [self addRequestHeader:request];
    
    [_networkQueue addOperation:request];
    [_networkQueue go];
    
    return true;
}

- (ASIHTTPRequest *)createRequest {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    
    return nil;
}

#pragma AsiNetWorkQueue delegate
- (void)requestDidFinish:(ASIHTTPRequest *)request {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    
}

- (void)requestDidFail:(ASIHTTPRequest *)request {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
