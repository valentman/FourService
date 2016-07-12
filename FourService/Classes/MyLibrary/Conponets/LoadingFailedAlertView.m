//
//  LoadingFailedAlertView.m
//  FourService
//
//  Created by Joe.Pen on 3/23/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "LoadingFailedAlertView.h"

@implementation LoadingFailedAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.reloadBtn addTarget:self action:@selector(reloadNetWork) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setRoloadHandle:(GeneralBlockHandler)reloadHandle
{
    self.reloadHandle = reloadHandle;
}

- (void)reloadNetWork
{
    if (self.reloadHandle)
    {
        self.reloadHandle();
    }
//    if (self.superview)
//    {
//        [self removeFromSuperview];
//    }
    
}

@end
