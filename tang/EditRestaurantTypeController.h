//
//  EditRestaurantTypeController.h
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetRestaurantTypeOperation.h"
#import "RestaurantType.h"

@protocol EditRestaurantTypeDelegate <NSObject>

- (void)editedType:(RestaurantType *) type;

@end

@interface EditRestaurantTypeController : UITableViewController<BaseOperationDelegate>

@property (nonatomic) NSInteger typeId;
@property (nonatomic, strong) id<EditRestaurantTypeDelegate> delegate;

@end
