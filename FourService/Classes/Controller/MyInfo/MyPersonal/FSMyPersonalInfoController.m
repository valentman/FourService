//
//  FSMyPersonalInfoController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyPersonalInfoController.h"
#import "FSBaseDataManager.h"
#import "CZJGeneralCell.h"
#import "PWUploadImageButton.h"
#import "FSChooseSexualController.h"

@interface FSMyPersonalInfoController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSArray* cellNameAry;
    
    UITextField* nameTextField;
    UITextField* phoneNumTextField;
}


@property (strong, nonatomic)UITableView* myTableView;
@end

@implementation FSMyPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
}

- (void)initDatas
{
    cellNameAry = @[@"头像",@"用户名",@"手机号",@"性别"];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"个人资料";
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
    
    //消息中心表格视图
    CGRect tableRect = CGRectMake(0, 64, PJ_SCREEN_WIDTH, 3 * 50 + 65);
    self.myTableView = [[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.clipsToBounds = YES;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    
    NSArray* nibArys = @[@"CZJGeneralCell"];
    
    for (id cells in nibArys)
    {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
    
    //保存按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [btn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    btn.layer.cornerRadius = 5.0;
    btn.backgroundColor = CZJREDCOLOR;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveMyInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(50, 64 + 4*50 + 50, PJ_SCREEN_WIDTH - 100, 50);
    [self.view addSubview:btn];
    
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 15, PJ_SCREEN_WIDTH - 100 - 15, 21)];
    nameTextField.placeholder = @"输入真是姓名便于更好的联系";
    nameTextField.textAlignment = NSTextAlignmentRight;
    nameTextField.font = SYSTEMFONT(14);
    nameTextField.textColor = [UIColor darkTextColor];
    [nameTextField setTag:255];
}

- (void)saveMyInfo:(id)sender
{
    [self.view endEditing:YES];
    NSString* name = nameTextField.text;
    NSString* sexual = ((CZJGeneralCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).detailLabel.text;
    NSString* sex;
    if ([sexual isEqualToString:@"保密"]) {
        sex = @"2";
    }
    if ([sexual isEqualToString:@"男"]) {
        sex = @"1";
    }
    if ([sexual isEqualToString:@"女"]) {
        sex = @"0";
    }
    NSDictionary* params = @{@"chinese_name": name,
                             @"customer_sex":sex,
                             @"customer_photo":self.myinfor.customer_photo};
    
    FSBaseDataInstance.userInfoForm.chinese_name = name;
    FSBaseDataInstance.userInfoForm.customer_sex = sexual;
    
    [FSBaseDataInstance updateUserInfo:params Success:^(id json)
     {
         [PUtils tipWithText:@"修改成功" andView:self.view];
         [self.navigationController popViewControllerAnimated:true];
     }fail:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* name = cellNameAry[indexPath.row];
    CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
    cell.nameLabel.text = name;
    cell.nameLabelLeading.constant = 20;
    if (3 == indexPath.row)
    {
        cell.separatorInset = HiddenCellSeparator;
    }
    switch (indexPath.row) {
        case 0:
        {
            __weak typeof(self) weakSelf = self;
            PWUploadImageButton* imagebutton = [[PWUploadImageButton alloc] initWithFrame:CGRectMake(PJ_SCREEN_WIDTH - 50 - 40, 5, 55, 55)];
            [imagebutton.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.myinfor.customer_photo] placeholderImage:nil];
            imagebutton.bgImageView.clipsToBounds = YES;
            imagebutton.bgImageView.layer.cornerRadius = 27.5;
            imagebutton.targetController = self;
            
            SuccessBlockHandler success = ^(id json)
            {
                UIImage* uploadHead = (UIImage*)json;
                [FSBaseDataInstance uploadUserHeadPic:nil Image:uploadHead Success:^(id json) {
                    DLog(@"%@",[json description]);
                    NSArray* urlAry = [json valueForKey:@"data"];
                    NSDictionary* dict = urlAry.firstObject;
                    NSArray* keys = [dict allKeys];
                    weakSelf.myinfor.customer_photo = ConnectString(kCZJServerAddr,[dict valueForKey:keys.firstObject]);
                    [weakSelf.myTableView reloadData];
                } fail:^{
                    
                }];
            };
            imagebutton.successBlock = success;
            [cell addSubview:imagebutton];
        }
            break;
            
        case 1:
            nameTextField.text = self.myinfor.chinese_name;
            [cell addSubview:nameTextField];
            break;
            
        case 2:
            cell.detailLabel.text = self.myinfor.customer_pho;
            break;
            
        case 3:
        {
            NSString* sexual;
            switch ([self.myinfor.customer_sex integerValue]) {
                case 0:
                    sexual = @"女";
                    break;
                case 1:
                    sexual = @"男";
                    break;
                case 2:
                    sexual = @"保密";
                    break;
                    
                default:
                    break;
            }
            cell.detailLabel.text = sexual;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return 65;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 == indexPath.row)
    {
        FSChooseSexualController* sexual = [[FSChooseSexualController alloc]init];
        sexual.myinfor = self.myinfor;
        [self.navigationController pushViewController:sexual animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
