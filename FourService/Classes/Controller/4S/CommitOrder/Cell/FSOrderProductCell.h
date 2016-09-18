//
//  FSOrderProductCell.h
//  FourService
//
//  Created by Joe.Pen on 9/16/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSOrderProductCell : PBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNamesLabel;
@property (weak, nonatomic) IBOutlet UILabel *LabelOne;
@property (weak, nonatomic) IBOutlet UILabel *LabelTwo;

@end