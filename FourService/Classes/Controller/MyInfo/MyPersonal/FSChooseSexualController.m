//
//  FSChooseSexualController.m
//  FourService
//
//  Created by Joe.Pen on 7/31/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSChooseSexualController.h"
#import "CZJGeneralCell.h"
#import "FSMyPersonalInfoController.h"

@interface FSChooseSexualController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSArray* sexualAry;
    NSIndexPath* currentIndexPath;
    NSInteger _indext;
}
@property (strong, nonatomic)UITableView* myTableView;
@property(assign,nonatomic) NSInteger selectIndex;
@end

@implementation FSChooseSexualController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
}

- (void)initDatas
{
    sexualAry = @[@"女",@"男",@"保密"];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"选择性别";
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.tintColor = CZJREDCOLOR;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = NO;
    self.myTableView.clipsToBounds = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];

    self.selectIndex = [_myinfor.customer_sex integerValue];
    currentIndexPath = [NSIndexPath indexPathForRow:_indext inSection:0];
    
    [self tableView:self.myTableView didSelectRowAtIndexPath:currentIndexPath];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == _indext)
    {
        [self tableView:tableView didDeselectRowAtIndexPath:currentIndexPath];
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"sexualCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sexualCell"];
    }
    
    cell.textLabel.text = sexualAry[indexPath.row];
    if (self.selectIndex == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == _indext)
    {
        [self tableView:tableView didDeselectRowAtIndexPath:currentIndexPath];
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectIndex = indexPath.row;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray* vcArrays = [self.navigationController viewControllers];
    for (UIViewController* vc in vcArrays)
    {
        if ([vc isKindOfClass:[FSMyPersonalInfoController class]])
        {
            FSMyPersonalInfoController* perVC = (FSMyPersonalInfoController*)vc;
            perVC.myinfor.customer_sex = [NSString stringWithFormat:@"%ld",indexPath.row];
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    DLog(@"section:%ld, row:%ld",indexPath.section,indexPath.row);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
