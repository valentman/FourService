//
//  FSMyinfoButtomView.m
//  FourService
//
//  Created by Joe.Pen on 8/13/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyinfoButtomView.h"

@interface FSMyinfoButtomView ()

@end

@implementation FSMyinfoButtomView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(clickButtomBtnCallBack:)])
    {
        [_delegate clickButtomBtnCallBack:sender];
    }
}
@end
