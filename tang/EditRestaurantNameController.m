//
//  EditRestaurantNameController.m
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "EditRestaurantNameController.h"

@interface EditRestaurantNameController ()

@end

@implementation EditRestaurantNameController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"餐馆名字";
    self.txtName.text = self.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.txtName becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(editedName:)]) {
        [_delegate performSelector:@selector(editedName:) withObject:self.txtName.text];
    }
}


@end
