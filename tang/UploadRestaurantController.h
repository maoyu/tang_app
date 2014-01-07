//
//  UploadRestaurantController.h
//  tang
//
//  Created by maoyu on 14-1-4.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadRestaurantManager.h"

@interface UploadRestaurantController : UITableViewController<UploadRestaurantManagerDelegate>

- (IBAction)cancel:(id)sender;
- (IBAction)uploadAllRestaurant:(id)sender;

@end
