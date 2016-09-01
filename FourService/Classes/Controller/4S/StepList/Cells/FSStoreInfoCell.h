//
//  FSStoreInfoCell.h
//  FourService
//
//  Created by Joe.Pen on 8/30/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSStoreInfoCell : CZJTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *scoreOneImage;
@property (weak, nonatomic) IBOutlet UIImageView *scoreTwoImage;
@property (weak, nonatomic) IBOutlet UIImageView *scoreThreeImage;
@property (weak, nonatomic) IBOutlet UIImageView *scoreFourImage;
@property (weak, nonatomic) IBOutlet UIImageView *scoreFiveImage;

- (void)setStoreScore:(int)num;
@end
