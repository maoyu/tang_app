//
//  EditRestaurantAddressController.m
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "EditRestaurantAddressController.h"

@interface EditRestaurantAddressController ()

@end

@implementation EditRestaurantAddressController

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
    self.title = @"餐馆位置";
    self.txtAddress.text = self.address;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.txtAddress becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(editedAddress:)]) {
        [_delegate performSelector:@selector(editedAddress:) withObject:self.txtAddress.text];
    }
}

@end
