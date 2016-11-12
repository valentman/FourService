//
//  FSConfirmInfoController.m
//  FourService
//
//  Created by Joe.Pen on 05/11/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSConfirmInfoController.h"
#import "CZJGeneralCell.h"
#import "FSConfirmInfoCell.h"
#import "FSDiscountCell.h"
#import "FSPayMentController.h"
#import "FSBaseDataManager.h"


@interface FSConfirmInfoController ()
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL isPart;
    BOOL isDiscount;
    float discountNum;
    float realPaymentPrice;
    NSString *originPrice;
    NSString *notPartPrice;
}
@property (strong, nonatomic)UITableView* myTableView;
@property (strong, nonatomic)UIButton *confirmBtn;
@end

@implementation FSConfirmInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    if (self.payMentUrl)
    {
        [self getDataFromServer];
    }
    else
    {
        [self.myTableView reloadData];
    }
}

- (void)initDatas
{
    isPart = NO;
    isDiscount = NO;
    discountNum = [self.scanQRForm.discount floatValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)initViews
{
    self.view.backgroundColor = WHITECOLOR;
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, 64);
    self.naviBarView.mainTitleLabel.text = self.scanQRForm.storeName;
    self.naviBarView.mainTitleLabel.textColor = WHITECOLOR;
    self.naviBarView.mainTitleLabel.font = SYSTEMFONT(17);
    self.naviBarView.mainTitleLabel.numberOfLines = 2;
    self.naviBarView.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:@"确认买单" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:CZJGRAYCOLOR];
    self.confirmBtn.layer.cornerRadius = 8;
    self.confirmBtn.clipsToBounds = YES;
    [self.confirmBtn addTarget:self action:@selector(actionConfirmPay:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.enabled = NO;
}

- (void)getDataFromServer
{
    [MBProgressHUD showHUDAddedTo: self.view animated:YES];
    [FSBaseDataInstance directPost:nil success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.myTableView reloadData];
    } failure:^{
        
    } andServerAPI:self.payMentUrl];
}

- (UITableView*)myTableView
{
    if (!_myTableView)
    {
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
        self.myTableView.tableFooterView = [[UIView alloc]init];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.clipsToBounds = YES;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.backgroundColor = CLEARCOLOR;
        [self.view addSubview:self.myTableView];
        
        NSArray* nibArys = @[@"CZJGeneralCell",
                             @"FSConfirmInfoCell",
                             @"FSDiscountCell"
                             ];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PJ_SCREEN_WIDTH, 60)];
        [footerView addSubview:self.confirmBtn];
        
        
    }
    return _myTableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section ||
        1 == section ||
        3 == section) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            FSConfirmInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSConfirmInfoCell" forIndexPath:indexPath];
            cell.backgroundColor = CLEARCOLOR;
            UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 85, 50)];
            totalLabel.font = SYSTEMFONT(14);
            totalLabel.textAlignment = NSTextAlignmentRight;
            totalLabel.textColor = RGB(30, 30, 30);
            totalLabel.text = @"应付总额：";
            cell.totalPriceLabel.leftViewMode = UITextFieldViewModeAlways;
            cell.totalPriceLabel.leftView = totalLabel;
            cell.totalPriceLabel.tag = 1001;
            if ([originPrice floatValue] > 0.1)
            {
                cell.totalPriceLabel.font = BOLDSYSTEMFONT(20);
                cell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%@",originPrice];
            }
            else
            {
                cell.totalPriceLabel.font = SYSTEMFONT(14);
                cell.totalPriceLabel.text = @"";
            }
            
            UILabel *notPartLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 127, 50)];
            notPartLabel.font = SYSTEMFONT(14);
            notPartLabel.textAlignment = NSTextAlignmentRight;
            notPartLabel.textColor = RGB(30, 30, 30);
            notPartLabel.text = @"不参与优惠金额：";
            cell.notPartPriceLabel.hidden = !isPart;
            cell.notPartPriceLabel.leftViewMode = UITextFieldViewModeAlways;
            cell.notPartPriceLabel.leftView = notPartLabel;
            cell.notPartPriceLabel.tag = 1002;
            if ([notPartPrice floatValue] > 0.1)
            {
                cell.notPartPriceLabel.font = BOLDSYSTEMFONT(20);
                cell.notPartPriceLabel.text = [NSString stringWithFormat:@"￥%@",notPartPrice];
            }
            else
            {
                cell.notPartPriceLabel.font = SYSTEMFONT(14);
                cell.notPartPriceLabel.text = @"";
            }
            
            [cell.buttonNotPart setSelected:isPart];
            [cell.promptLabel setTextColor:isPart ? FSBLUECOLOR : CZJGRAYCOLOR];
            [cell.buttonNotPart addTarget:self action:@selector(partAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
            
        case 1:
        {
            FSDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSDiscountCell" forIndexPath:indexPath];
            cell.discountLabel.text = [NSString stringWithFormat:@"%@折",self.scanQRForm.discount];
            [cell.choosebutton setSelected:([self.scanQRForm.discount floatValue] > 0.001 && originPrice > 0)] ;
            return cell;
        }
            break;
            
        case 2:
        {
            CZJGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabelLeading.constant = 15;
            if (0 == indexPath.row)
            {
                cell.nameLabel.text = @"抵用券";
                cell.arrowImg.hidden = NO;
                cell.detailLabel.text = @"暂无可用";
            }
            else
            {
                cell.nameLabel.text = @"实付金额";
                
                cell.arrowImg.hidden = YES;
                cell.detailLabel.text = [NSString stringWithFormat:@"￥%.2f", realPaymentPrice];
                cell.detailLabel.textColor = FSBLUECOLOR;
                cell.detailLabel.font = BOLDSYSTEMFONT(17);
            }
            return cell;
        }
            break;
            
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"confirmCell"];
                [cell addSubview:self.confirmBtn];
                [self.confirmBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
                cell.backgroundColor = CLEARCOLOR;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.separatorInset = HiddenCellSeparator;
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return isPart ? 140 : 90;
    }
    if (1 == indexPath.section) {
        return 44;
    }
    if (2 == indexPath.section)
    {
        return 44;
    }
    if (3 == indexPath.section) {
        return 70;
    }
    return 0;
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
    if (0 == indexPath.row && 2 == indexPath.section) {
        [PUtils tipWithText:@"暂无可用" andView:nil];
    }
}

- (void)partAction:(UIButton *)sender
{
    isPart = !isPart;
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)textFieldDidChange:(NSNotification *)notify
{
    UITextField * textField = notify.object;
    NSString* price = [NSString stringWithFormat:@"%@",textField.text];
    DLog(@"1000: %@",price);
    if (price.length > 0)
    {
        textField.font = BOLDSYSTEMFONT(20);
        if (price.length == 1 && ![price containsString:@"￥"])
        {
            textField.text = [NSString stringWithFormat:@"￥%@",price];
        }
        else if (price.length == 1 && [price containsString:@"￥"])
        {
            textField.text = @"";
            price = @"";
            textField.font = SYSTEMFONT(14);
        }
    }
    else
    {
       textField.font = SYSTEMFONT(14);
    }
    if ([price containsString:@"￥"] && price.length > 1)
    {
        price = [price substringFromIndex:1];
    }

    if (textField.tag == 1001)
    {
        originPrice = price;
    }
    else if (textField.tag == 1002)
    {
        notPartPrice = price;
    }
    [self updatePrice];
}

- (void)updatePrice
{
    if ([notPartPrice floatValue] > [originPrice floatValue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFSNotifiShowAlertView object:@"优惠金额超出应付金额，这显然不科学"];
    }
    float total = ([originPrice floatValue] - [notPartPrice floatValue]);
    realPaymentPrice = (total > 0 ? total : 0) * discountNum/10;
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2], [NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    self.confirmBtn.enabled = realPaymentPrice > 0.001;
    [self.confirmBtn setBackgroundColor:realPaymentPrice > 0.001 ? FSBLUECOLOR : CZJGRAYCOLOR];
    [self.confirmBtn setTitle:realPaymentPrice > 0.001 ? [NSString stringWithFormat:@"%.2f元 确认买单",realPaymentPrice] : @"确认买单" forState:UIControlStateNormal];
}

- (void)actionConfirmPay:(UIButton *)sender
{
    FSPayMentController *paymentVC = [[FSPayMentController alloc]init];
    [self.navigationController pushViewController:paymentVC animated:YES];
}
@end
