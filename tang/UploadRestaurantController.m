//
//  UploadRestaurantController.m
//  tang
//
//  Created by maoyu on 14-1-4.
//  Copyright (c) 2014年 diandi. All rights reserved.
//

#import "UploadRestaurantController.h"
#import "Restaurant.h"
#import "MBProgressManager.h"
#import "UploadRestaurantCell.h"
#import "EditRestaurantViewController.h"

@interface UploadRestaurantController () {
    NSArray * _restaurants;
}

@end

@implementation UploadRestaurantController

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
    _restaurants = [Restaurant getAllRestaurants];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadAllRestaurant:(id)sender {
    NSArray * uploadRestaurants = [Restaurant getUploadRestaurants];
    if (nil != uploadRestaurants) {
        [[MBProgressManager defaultManager] showHUD:@"上传中" withView:self.tableView];
        [UploadRestaurantManager defaultManager].restaurants = (NSMutableArray *)uploadRestaurants;
        [UploadRestaurantManager defaultManager].delegate = self;
        [[UploadRestaurantManager defaultManager] startUpload];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (nil != _restaurants) {
        return [_restaurants count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UploadRestaurantCell";
    UploadRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UploadRestaurantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Restaurant * restaurant = [_restaurants objectAtIndex:indexPath.row];
    cell.parentView = self.tableView;
    cell.restaurant = restaurant;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Restaurant * restaurant = [_restaurants objectAtIndex:indexPath.row];
        [restaurant deleteRestaurant];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditRestaurantViewController * controller = [[EditRestaurantViewController alloc] initWithNibName:@"EditRestaurantViewController" bundle:nil];
    controller.restaurnt = [_restaurants objectAtIndex:indexPath.row];
    controller.editMode = EditModeUpdate;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma UploadRestaurantManagerDelegate
- (void)uploadSuceeded:(Restaurant *)restaurant {
    
}

- (void)uploadFailed:(Restaurant *)restaurant {
    [self.tableView reloadData];
    [[MBProgressManager defaultManager] showToast:@"上传失败" withView:self.tableView];
}

- (void)uploadFinished {
    [self.tableView reloadData];
    [[MBProgressManager defaultManager] removeHUD];
}

@end
