//
//  CreateRestaurantViewController.h
//  tang
//
//  Created by maoyu on 13-12-16.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "CreateRestaurantOperation.h"

@interface CreateRestaurantViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LocationManagerDelegate,BaseOperationDelegate>

@property (nonatomic, weak) IBOutlet UIImageView * mImage;
@property (nonatomic, weak) IBOutlet UILabel * mLabelAddress;

- (IBAction)createRestaurant:(id)sender;

@end
