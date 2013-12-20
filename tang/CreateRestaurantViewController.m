//
//  FirstViewController.m
//  tang
//
//  Created by maoyu on 13-12-16.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "CreateRestaurantViewController.h"
#import "Restaurant.h"
#import "User.h"
#import "EditUserController.h"
#import "MBProgressManager.h"

@interface CreateRestaurantViewController () {
    Restaurant * _restaurant;
    CreateRestaurantOperation *_createRestaurantOp;
}

@end

@implementation CreateRestaurantViewController

#pragma 私有函数
- (void)initView {
    UITapGestureRecognizer *singleTap;
    singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCamera)];
    [singleTap setNumberOfTapsRequired:1];
    [self.mImage setUserInteractionEnabled:YES];
    [self.mImage addGestureRecognizer:singleTap];
    
    self.mImage.image = [UIImage imageNamed:@"camera_shutter"];
    self.mLabelAddress.text = @"";
}

- (void)showCamera {
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}

- (void)initRestaurant {
    _restaurant = [[Restaurant alloc] init];
}

- (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertView *viewAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [viewAlert show];
}

- (void)showEditUserController {
    [self performSegueWithIdentifier:@"EditUser" sender:self];
}

- (void)initUser {
    NSString * userName = [User currentUserName];
    if (nil != userName && ![userName isEqualToString:@""]) {
        User * user = [[User alloc] initWithUserName:userName];
        [User setCurrentUser:user];
    }else {
        [self showEditUserController];
    }
}
#pragma 事件函数
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initView];
    [self initRestaurant];
    [self initUser];
    
    [LocationManager defaultManager].delegate = self;
    [[LocationManager defaultManager] startStandardLocationServcie];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createRestaurant:(id)sender {
    if (nil == _restaurant.image) {
        [self showAlertViewWithTitle:@"提示" withMessage:@"请进行拍照"];
    }else {
        _createRestaurantOp = [[CreateRestaurantOperation alloc] initWithRestaurant:_restaurant];
        [_createRestaurantOp startRequest:self];
        [[MBProgressManager defaultManager] showHUD:@"上传中"];
    }
}

#pragma mark - ImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.mImage.image = [info valueForKey:UIImagePickerControllerEditedImage];
    _restaurant.image = UIImageJPEGRepresentation(self.mImage.image,0.3);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma LocationManager delete
- (void)receivedLocation:(NSDictionary *) locations {
    CLLocation *location = [locations objectForKey:@"location"];
    NSArray *placemarks = [locations objectForKey:@"placemarks"];
    CLPlacemark *placemark = [placemarks objectAtIndex:0];
    NSNumber *latitude = [NSNumber numberWithDouble:([location coordinate].latitude)];
    NSNumber *longitude = [NSNumber numberWithDouble:([location coordinate].longitude)];
    
    _restaurant.coordinate = [latitude stringValue];
    _restaurant.coordinate = [_restaurant.coordinate stringByAppendingString:@","];
    _restaurant.coordinate = [_restaurant.coordinate stringByAppendingString:[longitude stringValue]];

    NSString * address = @"";
    if (placemark.subLocality != nil && [placemark.subLocality length] > 0) {
        address = [address stringByAppendingString:placemark.subLocality];
    }
    
    if (placemark.thoroughfare != nil && [placemark.thoroughfare length] > 0) {
        address = [address stringByAppendingString:placemark.thoroughfare];
    }
    
    if (placemark.subThoroughfare != nil && [placemark.subThoroughfare length] > 0) {
        address = [address stringByAppendingString:placemark.subThoroughfare];
    }
    
    _restaurant.address = address;
    
    self.mLabelAddress.text =  address;
}

- (void)didSuceeded:(BaseOperation *)operation {
    [self initRestaurant];
    [self initView];
    [[MBProgressManager defaultManager] removeHUD];
}

- (void)didFailed:(BaseOperation *)operation {
    [[MBProgressManager defaultManager] showToast:@"上传失败"];
}

@end
