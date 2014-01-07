//
//  EditRestaurantCountyController.m
//  tang
//
//  Created by maoyu on 14-1-3.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "EditRestaurantCountyController.h"
#import "MBProgressManager.h"

@interface EditRestaurantCountyController () {
    NSArray * _counties;
    GetCountyOperation * _op;
}

@end

@implementation EditRestaurantCountyController

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
    _counties = [County getCounties];
    if (nil == _counties || 0 == [_counties count]) {
        [[MBProgressManager defaultManager] showHUD:@"请稍后" withView:self.tableView];
        _op = [[GetCountyOperation alloc] initWithCurrentLoggedInUser];
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
    if (nil != _counties) {
        return [_counties count];
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
    County * county = [_counties objectAtIndex:indexPath.row];
    if (county.countyId == self.countyId) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = county.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    County * county = [_counties objectAtIndex:indexPath.row];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(editedCounty:)]) {
        [_delegate performSelector:@selector(editedCounty:) withObject:county];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma BaseOperationDelegate
- (void)didSuceeded:(BaseOperation *)operation {
    [[MBProgressManager defaultManager] removeHUD];
    _counties = _op.counties;
    [self.tableView reloadData];
}

- (void)didFailed:(BaseOperation *)operation {
    [[MBProgressManager defaultManager] showToast:@"查询失败"];
}

@end

