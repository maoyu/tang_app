//
//  UploadRestaurantCell.m
//  tang
//
//  Created by maoyu on 14-1-6.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "UploadRestaurantCell.h"
#import "MBProgressManager.h"

@interface UploadRestaurantCell() {
}

@end

@implementation UploadRestaurantCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil];
        self = [nib objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    self.labelName.text = restaurant.name;
    self.labelAddress.text = restaurant.address;
    if (YES == restaurant.upload) {
        self.btnUpload.hidden = YES;
    }else {
        self.btnUpload.hidden = NO;
    }
}

- (IBAction)upload:(id)sender {
    [[MBProgressManager defaultManager] showHUD:@"上传中" withView:self.parentView];
    NSMutableArray * restaurants = [[NSMutableArray alloc] initWithCapacity:1];
    [restaurants addObject:self.restaurant];
    [UploadRestaurantManager defaultManager].restaurants = restaurants;
    [UploadRestaurantManager defaultManager].delegate = self;
    [[UploadRestaurantManager defaultManager] startUpload];
}

#pragma UploadRestaurantManagerDelegate
- (void)uploadSuceeded:(Restaurant *)restaurant {
    
}

- (void)uploadFailed:(Restaurant *)restaurant {
    [[MBProgressManager defaultManager] showToast:@"上传失败" withView:self.parentView];
}

- (void)uploadFinished {
    self.btnUpload.hidden = YES;
    [[MBProgressManager defaultManager] removeHUD];
}


@end
