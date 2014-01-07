//
//  EditRestaurantNameController.h
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditRestaurantNameDelegate <NSObject>

- (void)editedName:(NSString *)name;

@end

@interface EditRestaurantNameController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField * txtName;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) id<EditRestaurantNameDelegate> delegate;

@end
