//
//  FSProductEvaluateHeadCell.m
//  FourService
//
//  Created by Joe.Pen on 9/17/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSProductEvaluateHeadCell.h"

@implementation FSProductEvaluateHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    stars = [NSArray array];
    stars = @[_starone,_starTwo,_starThr, _starFour,_starFive];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStar:(int)star
{
    for (int i = 0; i < stars.count; i++)
    {
        UIImageView* image = stars[i];
        [image setImage:IMAGENAMED(@"evaluate_icon_star_white")];
        if (i < star)
        {
            [image setImage:IMAGENAMED(@"evaluate_icon_star_red")];
        }
    }
}

@end
