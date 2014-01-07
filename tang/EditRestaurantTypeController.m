//
//  EditRestaurantTypeController.m
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "EditRestaurantTypeController.h"
#import "RestaurantType.h"
#import "MBProgressManager.h"

@interface EditRestaurantTypeController () {
    NSArray * _types;
    GetRestaurantTypeOperation * _op;
}

@end

@implementation EditRestaurantTypeController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"餐馆类型";
    _types = [RestaurantType getTypes];
    if (nil == _types || 0 == [_types count]) {
        [[MBProgressManager defaultManager] showHUD:@"请稍后" withView:self.tableView];
        _op = [[GetRestaurantTypeOperation alloc] initWithCurrentLoggedInUser];
        [_op startRequest:self];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (nil != _types) {
        return [_types count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    RestaurantType * type = [_types objectAtIndex:indexPath.row];
    if (type.typeId == self.typeId) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = type.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantType * type = [_types objectAtIndex:indexPath.row];
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(editedType:)]) {
        [_delegate performSelector:@selector(editedType:) withObject:type];
    }
    
//    NSNotification * notification = nil;
//    notification = [NSNotification notificationWithName:kMessageUpdateRestaurantData object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:kUpdateRestaurantType,kMessageUpdateRestaurantData,type,@"RestaurantType",nil]];
//    
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma BaseOperationDelegate
- (void)didSuceeded:(BaseOperation *)operation {
    [[MBProgressManager defaultManager] removeHUD];
    _types = _op.types;
    [self.tableView reloadData];
}

- (void)didFailed:(BaseOperation *)operation {
    [[MBProgressManager defaultManager] showToast:@"查询失败"];
}

@end
