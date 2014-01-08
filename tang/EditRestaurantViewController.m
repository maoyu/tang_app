    //
//  FirstViewController.m
//  tang
//
//  Created by maoyu on 13-12-16.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "EditRestaurantViewController.h"
#import "User.h"
#import "EditUserController.h"
#import "MBProgressManager.h"
#import "RestaurantType.h"
#import "County.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define RGBRatio(x)             ((CGFloat)x / 255)
#define RGBColor(r, g, b)       [UIColor colorWithRed:RGBRatio(r) green:RGBRatio(g) blue:RGBRatio(b) alpha:1.0]

@interface EditRestaurantViewController () {
    NSDictionary * _sectionOfSecondTitles; // key存储标题对应的行号，value存储标题

    EditImagesCell * _editImageCell;
}

@end

@implementation EditRestaurantViewController

#pragma 私有函数
- (void)initTableFooter {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 54)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    button.layer.frame = CGRectMake(10, 0, 300, 44);
    [button setTitle:@"保 存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize: 20.0];
    [button setBackgroundColor:RGBColor(233,228,223)];
    [button addTarget:self action:@selector(addRestaurant) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    self.tableView.tableFooterView = view;
}

- (void)showActionSheet {
    UIActionSheet * menu = [[UIActionSheet alloc]
                            initWithTitle:nil delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"用户相册", @"相机", nil];
    
    [menu showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showCamera {
    [LocationManager defaultManager].delegate = self;
    [[LocationManager defaultManager] startStandardLocationServcie];
    [self refreshSectionOfSecondWithKey:kUpdateRestaurantAddress withValue:@"定位中"];

    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}

- (void)showPhotoAlbum {
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertView *viewAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [viewAlert show];
}

- (BOOL)validateData {
    BOOL result = YES;
    if (0 == [self.restaurnt.images count]
        || [self.restaurnt.address isEqualToString:@""]
        || [self.restaurnt.name isEqualToString:@""]) {
        result = NO;
    }
    return result;
}

- (void)showEditUserController {
    [self performSegueWithIdentifier:@"EditUser" sender:self];
}

- (void)initUser {
    NSString * userName = [User currentUserName];
    if (nil != userName && ![userName isEqualToString:@""]) {
        User * user = [[User alloc] initWithUserName:userName];
        [User setCurrentUser:user];
    }else {
        [self showEditUserController];
    }
}

- (void)initData {
    if (EditModeAdd == self.editMode) {
        self.restaurnt = [[Restaurant alloc] init];
    }
    
    if (nil == _sectionOfSecondTitles) {
        NSArray * keys = [[NSArray alloc] initWithObjects:kUpdateRestaurantAddress,kUpdateRestaurantName,kUpdateRestaurantType,kUpdateRestaurantCounty, nil];
        NSArray * values = [[NSArray alloc] initWithObjects:@"位置",@"店名",@"类型",@"县区", nil];
        _sectionOfSecondTitles = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    }
}

- (void)refreshSectionOfSecondWithKey:(NSString *)key withValue:(NSString *)value {
    NSInteger row = [key integerValue];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:1];
    
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = value;
    
    //TODO 不知道为什么，位置row必须要这样再刷下才显示数据
    NSArray *indexArray=[NSArray  arrayWithObject:indexPath];
    [self.tableView  reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showEditRestaurantTypeController {
    EditRestaurantTypeController * controller = [[EditRestaurantTypeController alloc] initWithNibName:@"EditRestaurantTypeController" bundle:nil];
    controller.typeId = self.restaurnt.typeId;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showEditRestaurantAddressController {
    EditRestaurantAddressController * controller = [[EditRestaurantAddressController alloc] initWithNibName:@"EditRestaurantAddressController" bundle:nil];
    controller.address = self.restaurnt.address;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showEditRestaurantNameController {
    EditRestaurantNameController * controller = [[EditRestaurantNameController alloc] initWithNibName:@"EditRestaurantNameController" bundle:nil];
    controller.name = self.restaurnt.name;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showEditRestaurantCountyController {
    EditRestaurantCountyController * controller = [[EditRestaurantCountyController alloc] initWithNibName:@"EditRestaurantCountyController" bundle:nil];
    controller.countyId = self.restaurnt.countyId;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addRestaurant {
    if (NO == [self validateData]) {
        [self showAlertViewWithTitle:@"提示" withMessage:@"请拍照、填写店名、位置信息"];
        return;
    }
    BOOL result = NO;
    if (EditModeAdd == self.editMode) {
        result = [self.restaurnt addRestaurant];
        [self initData];
        [self.tableView reloadData];
        if (YES == result) {
            [self showAlertViewWithTitle:@"保存成功" withMessage:@"请到上传界面，上传服务器"];
        }
    }else {
        result = [Restaurant updateRestaurants];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma 事件函数
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (EditModeAdd == self.editMode) {
        self.title = @"添加餐馆";
    }else {
        self.title = @"修改餐馆";
    }
    [self initData];
    [self initUser];
    [self initTableFooter];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ImagePicker delegate
/*
 数据源来自相册时，读出照片的位置信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString * filename = [[FileManager defaultManager] addImage:[info valueForKey:UIImagePickerControllerEditedImage]];
    
    if (UIImagePickerControllerSourceTypePhotoLibrary == picker.sourceType) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        [library assetForURL:url resultBlock:^(ALAsset *asset) {
            CLLocation * location = [asset valueForProperty:ALAssetPropertyLocation];
            if (nil != location) {
                [LocationManager defaultManager].delegate = self;
                [[LocationManager defaultManager] getPlacemarks:location];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
    if (nil != filename) {
        [self.restaurnt addImage:filename];
        [_editImageCell addImage:filename];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma LocationManager delete
- (void)receivedLocation:(NSDictionary *) locations {
    CLLocation *location = [locations objectForKey:@"location"];
    NSArray *placemarks = [locations objectForKey:@"placemarks"];
    CLPlacemark *placemark = [placemarks objectAtIndex:0];
    NSNumber *latitude = [NSNumber numberWithDouble:([location coordinate].latitude)];
    NSNumber *longitude = [NSNumber numberWithDouble:([location coordinate].longitude)];
    
    self.restaurnt.coordinate = [latitude stringValue];
    self.restaurnt.coordinate = [self.restaurnt.coordinate stringByAppendingString:@","];
    self.restaurnt.coordinate = [self.restaurnt.coordinate stringByAppendingString:[longitude stringValue]];

    NSString * address = @"";
    if (placemark.subLocality != nil && [placemark.subLocality length] > 0) {
        address = [address stringByAppendingString:placemark.subLocality];
    }
    
    if (placemark.thoroughfare != nil && [placemark.thoroughfare length] > 0) {
        address = [address stringByAppendingString:placemark.thoroughfare];
    }
    
    if (placemark.subThoroughfare != nil && [placemark.subThoroughfare length] > 0) {
        address = [address stringByAppendingString:placemark.subThoroughfare];
    }
    
    self.restaurnt.address = address;
    [self refreshSectionOfSecondWithKey:kUpdateRestaurantAddress withValue:address];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return [_sectionOfSecondTitles count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 88;
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier;
    UITableViewCell * cell;
    if (0 == indexPath.section) {
        CellIdentifier = @"EditImagesCell";
        _editImageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (_editImageCell == nil) {
            _editImageCell = [[EditImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (EditModeAdd == self.editMode) {
            [_editImageCell initView];
        }else {
            [_editImageCell addImage:[self.restaurnt.images objectAtIndex:0]];
        }
        _editImageCell.delegate = self;
        
        cell = _editImageCell;

    }else {
        CellIdentifier = @"DefaultCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [_sectionOfSecondTitles objectForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
        
        NSString * detailText = @"";
        if (0 == indexPath.row) {
            detailText = self.restaurnt.address;
        }else if (1 == indexPath.row) {
            detailText = self.restaurnt.name;
        }else if (2 == indexPath.row) {
            RestaurantType * type = [RestaurantType getTypeWithTypeId:self.restaurnt.typeId];
            if (nil != type) {
                detailText = type.name;
            }
        }else if (3 == indexPath.row) {
            County * county = [County getCountyWithId:self.restaurnt.countyId];
            if (nil != county) {
                detailText = county.name;
            }
        }
        
        cell.detailTextLabel.text = detailText;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 1 && [indexPath row] == 2) {
        [self showEditRestaurantTypeController];
    }else if ([indexPath section] == 1 && [indexPath row] == 0) {
        [self showEditRestaurantAddressController];
    }else if ([indexPath section] == 1 && [indexPath row] == 1) {
        [self showEditRestaurantNameController];
    }else if ([indexPath section] == 1 && [indexPath row] == 3) {
        [self showEditRestaurantCountyController];
    }
}

#pragma mark - ActionSheet view delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self showPhotoAlbum];
    }else if(buttonIndex == 1){
        [self showCamera];
    }
}

#pragma EditImagesCellDelegate
- (void)clickAddImage {
    if (EditModeAdd == self.editMode) {
        [self showActionSheet];
    }
}

#pragma EditRestaurantNameDelegate
- (void)editedName:(NSString *)name {
    self.restaurnt.name = name;
    [self refreshSectionOfSecondWithKey:kUpdateRestaurantName withValue:self.restaurnt.name];
}

#pragma EditRestaurantTypeDelegate
- (void)editedType:(RestaurantType *) type {
    self.restaurnt.typeId = type.typeId;
    [self refreshSectionOfSecondWithKey:kUpdateRestaurantType withValue:type.name];
}

#pragma EditRestaurantAddressDelegate
- (void)editedAddress:(NSString *)address {
    self.restaurnt.address = address;
    [self refreshSectionOfSecondWithKey:kUpdateRestaurantAddress withValue:self.restaurnt.address];
}

#pragma EditRestaurantCountyDelegate
- (void)editedCounty:(County *)county {
    self.restaurnt.countyId = county.countyId;
    [self refreshSectionOfSecondWithKey:kUpdateRestaurantCounty withValue:county.name];
}
@end
