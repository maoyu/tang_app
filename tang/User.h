//
//  User.h
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, copy) NSString * userName;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (NSString *)userArchivePath:(NSString*)userName;

+ (NSString *)currentUserName;

- (id)initWithUserName:(NSString *)userName;

- (void)save;

- (void)deleteCache;

@end
