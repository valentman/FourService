//
//  FSProductEvaluateHeadCell.h
//  FourService
//
//  Created by Joe.Pen on 9/17/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSProductEvaluateHeadCell : UITableViewCell
{
    NSArray* stars;
}
@property (weak, nonatomic) IBOutlet UILabel *userEvaluateNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *starone;
@property (weak, nonatomic) IBOutlet UIImageView *starTwo;
@property (weak, nonatomic) IBOutlet UIImageView *starThr;
@property (weak, nonatomic) IBOutlet UIImageView *starFour;
@property (weak, nonatomic) IBOutlet UIImageView *starFive;
@property (weak, nonatomic) IBOutlet UILabel *evaluateStarLabel;

- (void)setStar:(int)star;
@end
