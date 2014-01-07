//
//  SecondViewController.m
//  tang
//
//  Created by maoyu on 13-12-16.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "EditUserController.h"
#import "User.h"

@interface EditUserController () {
    User * mUser;
}


@end

@implementation EditUserController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString * userName = [User currentUserName];
    if (nil != userName && ![userName isEqualToString:@""]) {
        User * user = [[User alloc] initWithUserName:userName];
        [User setCurrentUser:user];
        [self.mTextUserName setText:userName];
    }
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mTextUserName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-  (IBAction)editUserName:(id)sender {
    NSString * userName = self.mTextUserName.text;
    User * user = [[User alloc] initWithUserName:userName];
    [user save];
    [User setCurrentUser:user];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
