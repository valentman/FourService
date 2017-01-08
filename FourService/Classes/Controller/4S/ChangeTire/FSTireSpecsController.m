//
//  FSTireSpecsController.m
//  FourService
//
//  Created by Joe.Pen on 08/01/2017.
//  Copyright © 2017 Joe.Pen. All rights reserved.
//

#import "FSTireSpecsController.h"
#import "FSMyCarListController.h"

@interface FSTireSpecsController ()<FSMyCarListControllerDelegate>

@end

@implementation FSTireSpecsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    self.view.backgroundColor = WHITECOLOR;
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, 64);
    self.naviBarView.mainTitleLabel.text = @"默认车辆车型名称";
    
    [self.naviBarView.btnMore setBackgroundImage:nil forState:UIControlStateNormal];
    self.naviBarView.btnMore.frame = CGRectMake(PJ_SCREEN_WIDTH - 80, 22, 80, 40);
    self.naviBarView.btnMore.titleLabel.font = SYSTEMFONT(14);
    [self.naviBarView.btnMore setTitle:@"换车" forState:UIControlStateNormal];
    self.naviBarView.btnMore.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickEventCallBack:(nullable id)sender
{
    UIButton* barButton = (UIButton*)sender;
    switch (barButton.tag) {
        case CZJButtonTypeNaviBarMore:
        {
            FSMyCarListController *carlist = (FSMyCarListController *)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"carListSBID"];
            carlist.delegate = self;
            carlist.carFromType = FSCarListFromTypeTireSpecs;
            [self presentViewController:carlist animated:YES completion:nil];
        }
            break;
            
        case CZJButtonTypeNaviBarBack:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

- (void)selectOneCar:(FSCarListForm *)carForm
{
    self.naviBarView.mainTitleLabel.text = [NSString stringWithFormat:@"%@-%@",carForm.car_brand_name, carForm.car_model_name];
}

@end
