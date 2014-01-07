//
//  EditImagesCell.m
//  tang
//
//  Created by maoyu on 13-12-30.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import "EditImagesCell.h"
#import "FileManager.h"

@implementation EditImagesCell

#pragma 事件函数
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] ;
        self = [nib objectAtIndex:0];
        self.imageView.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickAddImage:(id)sender {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(clickAddImage)]) {
        [_delegate performSelector:@selector(clickAddImage) withObject:nil];
    }
}

#pragma 类成员函数
- (void)initView {
    self.imageViewEdit.image = nil;
    self.imageView.hidden = YES;
    self.btnAddImage.hidden = NO;
}

- (void)addImage:(NSString *)filename {
    UIImage * image = [[FileManager defaultManager] getImageWithFilename:filename];
    if (nil != image) {
        self.imageViewEdit.image = image;
        self.imageView.hidden = NO;
    }
}

@end
