//
//  RestOperation.h
//
//  Created by maoyu on 12/17/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

//#define ROOT_URL @"http://192.168.10.112/"

typedef enum{
    HttpStatusCodeSuccess = 200,
    HttpStatusCodeBadRequest = 400,
    HttpStatusCodeUnauthorized = 401,
    HttpStatusCodeNotFound = 404,
    HttpStatusCodeConflict = 409,
    HttpStatusCodeInternalError = 500
}HttpStatusCode;

@protocol RestOperationDelegate;

@interface RestOperation : NSObject <NSURLConnectionDelegate>

-(BOOL)startRequest:(id <RestOperationDelegate>)  delegate;

- (id)initWithCurrentLoggedInUser;

-(NSMutableURLRequest *)createRequest;

-(NSMutableURLRequest *)createGetRequest:(NSString*)urlStr;
-(NSMutableURLRequest *)createPutRequest:(NSString*)urlStr
                              requestData:(NSData *) requestData;
-(NSMutableURLRequest *)createPostRequest:(NSString*)urlStr
                              requestData:(NSData *) requestData;
-(NSMutableURLRequest *)createDeleteRequest:(NSString*)urlStr;

@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, retain) id<RestOperationDelegate> delegate;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLResponse * response;
@property (nonatomic, assign) NSInteger httpStatusCode;

@end

@protocol RestOperationDelegate

- (void)didSuceeded:(RestOperation *)sender;
- (void)didFailed:(RestOperation *)sender;

@end
