//
//  FSAboutUSController.m
//  FourService
//
//  Created by Joe.Pen on 9/27/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSAboutUSController.h"

@interface FSAboutUSController ()

@end

@implementation FSAboutUSController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"关于我们";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
