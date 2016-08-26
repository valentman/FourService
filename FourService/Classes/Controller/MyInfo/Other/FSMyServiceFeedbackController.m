//
//  FSMyServiceFeedbackController.m
//  FourService
//
//  Created by Joe.Pen on 7/26/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyServiceFeedbackController.h"

@interface FSMyServiceFeedbackController ()

@end

@implementation FSMyServiceFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"反馈咨询";
}

- (void)initDatas
{
}

- (void)initViews
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
