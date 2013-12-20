//
//  User.m
//  tang
//
//  Created by maoyu on 13-12-17.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "User.h"

static User * single = nil;

@implementation User

#pragma mark NSCoding

#define KEY_USER_NAME       @"UserName"
#define KEY_USER_ARCHIVE_EXTENSION      @".dat"

- (id)initWithUserName:(NSString *)userName {
    self = [super init];
    if (self) {
        self.userName = userName;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userName forKey:KEY_USER_NAME];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:KEY_USER_NAME];
    }
    return self;
}


+ (User *)currentUser {
    @synchronized(self) {
        if(!single) {
            single = [[User alloc] initWithUserName:nil];
        }
    }
    return single;
}

+ (void)setCurrentUser: (User *) user {
    single = user;
}

+ (NSString *)userArchivePath: (NSString*) userName {
    // Somehow, the simulator Documents path is ~/Library/Application Support/iPhone Simulator/5.1/Documents
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName =  [userName stringByAppendingString:KEY_USER_ARCHIVE_EXTENSION];
    return [rootPath stringByAppendingPathComponent:fileName];
}

- (void)save {
    NSString *path = [User userArchivePath:self.userName];
    NSData* userData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userData writeToFile:path atomically:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName forKey:KEY_USER_NAME];
    [defaults synchronize];
}

- (void)deleteCache {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = [User userArchivePath:self.userName];
    NSError *error;
    if ([fileMgr removeItemAtPath:path error:&error] != YES) {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
}

+ (NSString *)currentUserName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* savedUserName = [defaults objectForKey:KEY_USER_NAME];
    return savedUserName;
}



@end
