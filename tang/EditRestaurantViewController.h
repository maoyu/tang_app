//
//  CreateRestaurantViewController.h
//  tang
//
//  Created by maoyu on 13-12-16.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "EditImagesCell.h"
#import "Restaurant.h"
#import "EditRestaurantNameController.h"
#import "EditRestaurantTypeController.h"
#import "EditRestaurantAddressController.h"
#import "EditRestaurantCountyController.h"

typedef enum  {
    EditModeAdd = 0,
    EditModeUpdate = 1
}EditMode;

@interface EditRestaurantViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LocationManagerDelegate,EditImagesCellDelegate,EditRestaurantNameDelegate,EditRestaurantTypeDelegate,EditRestaurantAddressDelegate,EditRestaurantCountyDelegate>

@property (nonatomic, strong) Restaurant * restaurnt;
@property (nonatomic) EditMode editMode;

@end
