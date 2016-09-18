//
//  CZJMyInfoHeadCell.m
//  CZJShop
//
//  Created by Joe.Pen on 1/11/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "CZJMyInfoHeadCell.h"

@interface CZJMyInfoHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;


- (IBAction)messageAction:(id)sender;

@end

@implementation CZJMyInfoHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgImage.layer.cornerRadius = 10;
    self.userPhoneLabel.layer.borderWidth = 1.0;
    self.userPhoneLabel.layer.borderColor = WHITECOLOR.CGColor;
    self.userPhoneLabel.layer.cornerRadius = 11;
    [self.userPhoneLabel.layer setMasksToBounds:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserPersonalInfo:(UserBaseForm*)userinfo andDefaultCar:(FSCarListForm*)car
{
    self.userNameLabel.text = [PUtils isBlankString:userinfo.chinese_name] ? @"昵称" : userinfo.chinese_name;
    self.userPhoneLabel.text = userinfo.customer_pho;
    [self.userHeadImg sd_setImageWithURL:[NSURL URLWithString:userinfo.customer_photo] placeholderImage:IMAGENAMED(@"my_icon_head")];
    self.userHeadImg.clipsToBounds = YES;
}

- (IBAction)messageAction:(id)sender
{
    //消息中心
    [self.delegate clickMyInfoHeadCell:sender];
}

@end
