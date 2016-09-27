
//
//  CPEvaluateSuccessController.m
//  CityPlus
//
//  Created by Joe.Pen on 9/12/16.
//  Copyright © 2016 JHQC. All rights reserved.
//

#import "CPEvaluateSuccessController.h"

@interface CPEvaluateSuccessController ()

- (IBAction)jumpAction:(id)sender;
@end

@implementation CPEvaluateSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"订单成功";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)jumpAction:(id)sender
{
    
}
@end
