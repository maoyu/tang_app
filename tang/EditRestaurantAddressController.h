//
//  EditRestaurantAddressController.h
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditRestaurantAddressDelegate <NSObject>

- (void)editedAddress:(NSString *)address;

@end

@interface EditRestaurantAddressController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField * txtAddress;

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) id<EditRestaurantAddressDelegate> delegate;

@end
