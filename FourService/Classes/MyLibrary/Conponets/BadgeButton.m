//
//  BadgeButton.m
//  FourService
//
//  Created by Joe.Pen on 12/12/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "BadgeButton.h"
@interface BadgeButton()
@property (strong, nonatomic)UILabel* badgeLabel;

@end

@implementation BadgeButton

- (void)setBadgeNum:(NSInteger)badgeNum
{
    if (0 == badgeNum)
    {
        _badgeLabel.hidden = YES;
        [_badgeLabel removeFromSuperview];
        _badgeLabel = nil;
        return;
    }
    else
    {
        if (!VIEWWITHTAG(self, 99))
        {
            _badgeLabel = [[UILabel alloc]init];
            _badgeLabel.hidden = YES;
            _badgeLabel.layer.backgroundColor = CZJREDCOLOR.CGColor;
            [_badgeLabel setTag:99];
            [self addSubview:_badgeLabel];
        }
            
        CGRect labelRect;
        if (-1 == badgeNum)
        {
            [_badgeLabel setSize:CGSizeMake(8, 8)];
            _badgeLabel.layer.cornerRadius = 4;
        }
        else
        {
            NSString* badgeStr = [NSString stringWithFormat:@"%ld", badgeNum];
            CGSize labelSize = [PUtils calculateTitleSizeWithString:badgeStr AndFontSize:10];
            [_badgeLabel setSize:CGSizeMake(labelSize.width < 15 ? 15 : labelSize.width, 15)];
            _badgeLabel.text = badgeStr;
            _badgeLabel.textColor = [UIColor whiteColor];
            _badgeLabel.textAlignment = NSTextAlignmentCenter;
            _badgeLabel.font = SYSTEMFONT(10);
            _badgeLabel.layer.cornerRadius = 7.5;
        }
        [self setBadgeLabelPosition:CGPointMake(self.bounds.size.width, 0)];
        _badgeLabel.hidden = NO;
    }

}

- (void)setBadgeLabelPosition:(CGPoint)pt
{
    [_badgeLabel setPosition:pt atAnchorPoint:CGPointTopRight];
}

@end
