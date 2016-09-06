//
//  FSPageCell.m
//  FourService
//
//  Created by Joe.Pen on 9/6/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSPageCell.h"

@implementation FSPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)segmentChoose:(UISegmentedControl*)seg
{

}
- (IBAction)segmentChooseAction:(id)sender {
    UISegmentedControl* seg = (UISegmentedControl*)sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
            DLog(@"套餐A");
            break;
            
        case 1:
            DLog(@"套餐B");
            break;
            
        case 2:
            DLog(@"套餐C");
            break;
            
        default:
            break;
    }
}
@end
