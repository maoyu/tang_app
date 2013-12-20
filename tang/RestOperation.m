//
//  RestOperation.m
//
//
//  Created by maoyu on 1/19/13.
//
//

#import "RestOperation.h"
#import "User.h"

@interface RestOperation ()


@end

@implementation RestOperation

@synthesize delegate, responseData;

-(BOOL)startRequest:(id <RestOperationDelegate>) aDelegate
{
    responseData = [[NSMutableData alloc] init];
    self.delegate = aDelegate;
    
    NSMutableURLRequest *request = [self createRequest];
    NSURLConnection *connection =[NSURLConnection connectionWithRequest:request delegate:self];
    return connection != nil;
}

- (id)initWithUserName:(NSString *)aUserName
              password:(NSString*) aPasswrod
{
    self = [super init];
    if (self) {
        self.userName = aUserName;
        self.password = aPasswrod;
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

-(NSMutableURLRequest *)createRequest
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

-(void)addAuthorizationHeader:(NSMutableURLRequest *)request
{
    NSString *authStr = [NSString stringWithFormat:@"%@,%@", self.userName, self.password];
    [request setValue:authStr forHTTPHeaderField:@"USER_AUTH_DATA"];
}

-(NSMutableURLRequest *)createGetRequest:(NSString*)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self addAuthorizationHeader:request];
    [request setHTTPMethod:@"GET"];
    return request;
}

-(NSMutableURLRequest *)createDeleteRequest:(NSString*)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self addAuthorizationHeader:request];
    [request setHTTPMethod:@"DELETE"];
    return request;
}

-(NSMutableURLRequest *)createPostRequest:(NSString*)urlStr
                              requestData:(NSData *) requestData  
{
    return [self createRequest:urlStr requestData:requestData method:@"POST"];
}

-(NSMutableURLRequest *)createPutRequest:(NSString*)urlStr
                              requestData:(NSData *) requestData
{
    return [self createRequest:urlStr requestData:requestData method:@"PUT"];
}

-(NSMutableURLRequest *)createRequest:(NSString*)urlStr
                             requestData:(NSData *) requestData
                               method:(NSString*) aMethod
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self addAuthorizationHeader:request];
    [request setHTTPBody: requestData];
    [request setHTTPMethod:aMethod];
    [request setTimeoutInterval:6.0f];
//    [request setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    return request;
}


#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount]) {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    else {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.httpStatusCode = [httpResponse statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Received error: url: %@; message: %@", connection.originalRequest.URL, error);
}

@end

