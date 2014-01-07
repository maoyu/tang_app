//
//  UploadRestaurantCell.h
//  tang
//
//  Created by maoyu on 14-1-6.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "UploadRestaurantManager.h"

@interface UploadRestaurantCell : UITableViewCell<UploadRestaurantManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel * labelName;
@property (nonatomic, weak) IBOutlet UILabel * labelAddress;
@property (nonatomic, weak) IBOutlet UIButton * btnUpload;

@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, weak) UIView * parentView;

- (IBAction)upload:(id)sender;

@end
