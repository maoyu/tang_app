//
//  EditUserController.h
//  tang
//
//  Created by maoyu on 13-12-16.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField * mTextUserName;

- (IBAction)editUserName:(id)sender;

@end
