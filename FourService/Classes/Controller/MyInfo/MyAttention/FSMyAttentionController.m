//
//  FSMyAttentionController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyAttentionController.h"

@interface FSMyAttentionController ()
{
    BOOL _isEdit;
}
@property (strong, nonatomic) UITableView *myTableView;
@end

@implementation FSMyAttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];

}

- (void)initDatas
{
    _isEdit = NO;

}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.delegate = self;
    self.naviBarView.mainTitleLabel.text = @"收藏";
    
    //右按钮
    UIButton *rightBtn = [[ UIButton alloc ] initWithFrame : CGRectMake(PJ_SCREEN_WIDTH - 59 , 0 , 44 , 44 )];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn setSelected:NO];
    rightBtn.titleLabel.font = BOLDSYSTEMFONT(16);
    [rightBtn setTag:1999];
    [self.naviBarView addSubview:rightBtn];
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
