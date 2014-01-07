//
//  EditImagesCell.h
//  tang
//
//  Created by maoyu on 13-12-30.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditImagesCellDelegate <NSObject>

- (void)clickAddImage;

@end

@interface EditImagesCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton * btnAddImage;
@property (nonatomic, weak) IBOutlet UIImageView * imageViewEdit;

@property (nonatomic, strong) id<EditImagesCellDelegate> delegate;

- (void)addImage:(NSString *)filename;
- (void)initView;

- (IBAction)clickAddImage:(id)sender;

@end
