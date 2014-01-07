//
//  EditRestaurantCountyController.h
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCountyOperation.h"
#import "County.h"

@protocol EditRestaurantCountyDelegate <NSObject>

- (void)editedCounty:(County *) county;

@end

@interface EditRestaurantCountyController : UITableViewController<BaseOperationDelegate>

@property (nonatomic) NSInteger countyId;
@property (nonatomic, strong) id<EditRestaurantCountyDelegate> delegate;

@end
