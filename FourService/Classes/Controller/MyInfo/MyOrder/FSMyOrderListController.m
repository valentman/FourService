//
//  FSMyOrderListController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyOrderListController.h"

@interface FSMyOrderListController ()

@end

@implementation FSMyOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    NSString* title;
    switch (self.orderType) {
        case FSOrderListTypeAll:
            title = @"全部订单";
            break;
            
        case FSOrderListTypeNoPay:
            title = @"待支付";
            break;
            
        case FSOrderListTypeInService:
            title = @"服务中";
            break;
            
        case FSOrderListTypeNoComment:
            title = @"待评论";
            break;
            
        default:
            break;
    }
    self.naviBarView.mainTitleLabel.text = title;
    
    [PUtils tipWithAnimateAndText:@"" withCompeletHandler:^{
        [PUtils showNoDataAlertViewOnTarget:self.view withPromptString:@"暂未有相关订单"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
