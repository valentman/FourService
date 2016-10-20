//
//  FSProductNameCell.h
//  FourService
//
//  Created by Joe.Pen on 9/17/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSProductNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productNameHeight;

@end
