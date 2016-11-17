//
//  CZJAddMyCarController.m
//  CZJShop
//
//  Created by Joe.Pen on 1/25/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "CZJAddMyCarController.h"
#import "FSBaseDataManager.h"
#import "GKHpickerAddressView.h"
#import "FSCarForm.h"
#import "FSMyCarListController.h"
#import "LewPickerController.h"
#import "CCLocationManager.h"
#import "ZXLocationManager.h"

#import "FSAddCarOneCell.h"
#import "FSAddCarTwoCell.h"
#import "FSAddCarThreeCell.h"
#import "FSAddCarPromptCell.h"

typedef NS_ENUM(NSInteger, FSTextField)
{
    FSTextFieldCarNum       =1,    //
    FSTextFieldEngineCode   =2,    //
    FSTextFieldVinCode      =4     //
};

@interface CZJAddMyCarController ()
<
LewPickerControllerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource
>
{
    NSArray* provinceAry;
    NSArray* numberPlateAry;
    UIPickerView *_pickerView;
    UIDatePicker* _datePickerView;
    __block UIView* _backgroundView;
    UIButton* _currentSelectDateBtn;
    
    NSString* provinceStr;
    NSString* numverPlateStr;
    NSString *plateNumStr;
    NSString *numberPlate;
    
    NSInteger currentSelectPro;
    NSInteger currentSelectNum;
    
    NSArray *dateTitleAry;
    
    BOOL isAddCar;
}

- (void)setCarDefalutAction:(UIButton *)sender;
- (void)chooseCarPlateNumAction:(UIButton *)sender;
- (void)chooseDateAction:(UIButton *)sender;

- (IBAction)addMyCarAction:(id)sender;

@property (strong, nonatomic) UITableView *myTableView;

@end

@implementation CZJAddMyCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initDatas];
    [self addTouchObserver];
}

- (void)initViews
{
    [PUtils customizeNavigationBarForTarget:self];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = isAddCar ? @"添加车辆信息" : @"编辑车辆信息";
    self.view.backgroundColor = CZJTableViewBGColor;
    
    //背景触摸层
    _backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = RGBA(100, 240, 240, 0);
}

- (void)initDatas
{
    plateNumStr = @"";
    dateTitleAry = @[@"生产日期", @"上牌日期", @"最近保养日期"];
    provinceAry = [PUtils readArrayFromBundleDirectoryWithName:@"Province"];
    numberPlateAry = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",
                       @"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",
                       @"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"
                       ];
    if (!_carForm)
    {
        _carForm = [[FSCarListForm alloc] init];
        _carForm.car_brand_name = FSBaseDataInstance.carBrandForm.car_brand_name;
        _carForm.car_model_name = FSBaseDataInstance.carSerialForm.car_model_name;
        _carForm.car_type_name = FSBaseDataInstance.carModealForm.car_type_name;
        _carForm.icon = FSBaseDataInstance.carBrandForm.icon;
        numberPlate = @"川A";
        _carForm.is_default = YES;
        isAddCar = YES;
    }
    else
    {
        NSArray* carNumAry = [_carForm.car_num componentsSeparatedByString:@"-"];
        numberPlate = [PUtils isBlankString:carNumAry.firstObject] ? @"川A" : carNumAry.firstObject;;
        plateNumStr = carNumAry.lastObject;
        isAddCar = NO;
    }

    [self.myTableView reloadData];
}

- (UITableView *)myTableView
{
    if (!_myTableView)
    {
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT - 75) style:UITableViewStylePlain];
        self.myTableView.tableFooterView = [[UIView alloc]init];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.clipsToBounds = YES;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.backgroundColor = CLEARCOLOR;
        [self.view addSubview:self.myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        
        NSArray *nibArys = @[@"FSAddCarOneCell",
                             @"FSAddCarTwoCell",
                             @"FSAddCarThreeCell",
                             @"FSAddCarPromptCell"
                             ];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 3;
    }
    if (1 == section)
    {
        return 2;
    }
    if (2 == section)
    {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (0 == indexPath.row)
            {
                FSAddCarOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSAddCarOneCell" forIndexPath:indexPath];
                cell.infoTextField.hidden = YES;
                
                [cell setSeparatorViewHidden:NO];

                cell.infoLabel.text  = [NSString stringWithFormat:@"%@ %@ %@", _carForm.car_brand_name, _carForm.car_model_name, _carForm.car_type_name];
                [cell.logonImage sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr,_carForm.icon)] placeholderImage:DefaultPlaceHolderSquare];
                
                return cell;
            }
            if (1 == indexPath.row)
            {
                FSAddCarTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSAddCarTwoCell" forIndexPath:indexPath];
                [cell setSeparatorViewHidden:NO];
                cell.carNumberTextField.delegate = self;
                cell.carNumberTextField.tag = FSTextFieldCarNum;
                [cell.defaultButton addTarget:self action:@selector(setCarDefalutAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.carNumberButton addTarget:self action:@selector(chooseCarPlateNumAction:) forControlEvents:UIControlEventTouchUpInside];
                
                NSArray* carNumAry = [_carForm.car_num componentsSeparatedByString:@"-"];
                NSString *carNumStr = [PUtils isBlankString:carNumAry.firstObject] ? @"川A" : carNumAry.firstObject;
                [cell.carNumberButton setTitle:carNumStr forState:UIControlStateNormal];
                cell.carNumberTextField.text = carNumAry.lastObject ? carNumAry.lastObject : @"";
                cell.defaultButton.selected = _carForm.is_default;
                
                return cell;
            }
            if (2 == indexPath.row)
            {
                FSAddCarPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSAddCarPromptCell" forIndexPath:indexPath];
                cell.separatorInset = HiddenCellSeparator;
                return cell;
            }
        }
            break;
            
        case 1:
        {
            FSAddCarOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSAddCarOneCell" forIndexPath:indexPath];
            cell.logonImage.hidden = YES;
            cell.infoLabel.hidden = YES;
            cell.titleLabel.text = indexPath.row == 0 ? @"发动机编号" : @"VIN码";
            cell.infoTextField.tag = indexPath.row == 0 ? FSTextFieldEngineCode : FSTextFieldVinCode;
            cell.infoTextField.delegate = self;
            if (_carForm) {
                cell.infoTextField.text = indexPath.row == 0 ? _carForm.engine_code : _carForm.vin_code;
            }
            
            [cell setSeparatorViewHidden:NO];
            return cell;
        }
            break;
            
        case 2:
        {
            FSAddCarThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSAddCarThreeCell" forIndexPath:indexPath];
            cell.titleLabel.text = dateTitleAry[indexPath.row];
            [cell.dateButton addTarget:self action:@selector(chooseDateAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.dateButton.tag = indexPath.row;
            if (_carForm) {
                if (0 == indexPath.row)
                {
                    [cell.dateButton setTitle:_carForm.buy_date ? _carForm.buy_date : @"点击添加" forState:UIControlStateNormal];
                    [cell.dateButton setTitleColor:_carForm.buy_date ? FSBlackColor33 : FSGrayColor99 forState:UIControlStateNormal];
                }
                if (1 == indexPath.row)
                {
                    [cell.dateButton setTitle:_carForm.product_date ? _carForm.product_date : @"点击添加" forState:UIControlStateNormal];
                    [cell.dateButton setTitleColor:_carForm.product_date ? FSBlackColor33 : FSGrayColor99 forState:UIControlStateNormal];
                }
                if (2 == indexPath.row)
                {
                    [cell.dateButton setTitle:_carForm.maintain_date ? _carForm.maintain_date : @"点击添加" forState:UIControlStateNormal];
                    [cell.dateButton setTitleColor:_carForm.maintain_date ? FSBlackColor33 : FSGrayColor99 forState:UIControlStateNormal];
                }
            }
            
            if (2 == indexPath.row)
            {
                cell.separatorInset = HiddenCellSeparator;
            }
            else
            {
                [cell setSeparatorViewHidden:NO];
            }
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
    if (0 == indexPath.section)
    {
        if (2 == indexPath.row)
            return 50;
        return 90;
    }
    if (1 == indexPath.section)
    {
        return 90;
    }
    if (2 == indexPath.section)
    {
        return 46;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section || 1 == section)
    {
        return 0;
    }
    return 10;
}

- (void)setCarDefalutAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    _carForm.is_default = sender.selected;
}

- (IBAction)addMyCarAction:(id)sender
{
    if (![PUtils isLoginIn:self andNaviBar:nil])
        return;
    [self.view endEditing:YES];
    if ([PUtils isBlankString:plateNumStr])
    {
        [PUtils tipWithText:@"请输入车牌号" andView:nil];
        return;
    }
    else if (![PUtils isLicencePlate:plateNumStr]) {
        [PUtils tipWithText:@"请输入正确的车牌" andView:nil];
        return;
    }

    CarModelForm* _carModealForm = FSBaseDataInstance.carModealForm;
    NSString* modelId = _carModealForm ? _carModealForm.car_type_id: _carForm.car_type_id;

    NSMutableDictionary* carInfo =
    [@{@"car_id" : _carForm.car_id ? _carForm.car_id : @"",
       @"car_type_id": modelId,
       @"car_num" : [NSString stringWithFormat:@"%@-%@", numberPlate, plateNumStr],
       @"is_default" : _carForm.is_default ? @"true" : @"false",
       @"vin_code": _carForm.vin_code ? _carForm.vin_code : @"0",
       @"engine_code": _carForm.engine_code ? _carForm.engine_code : @"0",
       @"buy_date": _carForm.buy_date ? _carForm.buy_date : @"0",
       @"product_date": _carForm.product_date ? _carForm.product_date : @"0",
       @"maintain_date": _carForm.maintain_date ? _carForm.maintain_date : @"0"
       } mutableCopy];
    
    if (isAddCar)
    {
        weaky(self);
        [FSBaseDataInstance addMyCar:carInfo Success:^(id json) {
            [PUtils tipWithText:@"添加成功" withCompeletHandler:^{
                FSMyCarListController *carList = (FSMyCarListController *)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"carListSBID"];
                [weakSelf presentViewController:carList animated:YES completion:^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                }];
            }];
        } fail:^{
            
        }];
    }
    else
    {
        [FSBaseDataInstance editMyCar:carInfo Success:^(id json) {
            [PUtils tipWithText: @"更新成功" andView:nil];
            NSArray* vcs = self.navigationController.viewControllers;
            for (id controller in vcs)
            {
                if ([controller isKindOfClass:[FSMyCarListController class]])
                {
                    [((FSMyCarListController*)controller) getCarListFromServer];
                    [self.navigationController popToViewController:controller animated:true];
                    break;
                }
            }
        } fail:nil];
    }

}

- (void)chooseCarPlateNumAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    LewPickerController *pickerController = [[LewPickerController alloc]initWithDelegate:self];
    pickerController.pickerView = _pickerView;
    pickerController.titleLabel.text = @"选择省市代码";
    
    [self.view addSubview:_backgroundView];
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    }];
    
    [pickerController showInView:self.view];
    
    if (currentSelectPro > 0)
    {
        [_pickerView selectRow:currentSelectPro inComponent:0 animated:YES];
    }
    if (currentSelectNum > 0)
    {
        [_pickerView selectRow:currentSelectNum inComponent:1 animated:YES];
    }
}

- (void)chooseDateAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    _datePickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 350, 320, 216)];
    _datePickerView.datePickerMode = UIDatePickerModeDate;
    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_datePickerView setCalendar:calender];
    // 设置当前显示时间
    [_datePickerView setDate:[NSDate date] animated:YES];
    // 设置时区
    [_datePickerView setTimeZone:[NSTimeZone localTimeZone]];
    // 设置显示最大时间（此处为当前时间）
    [_datePickerView setMaximumDate:[NSDate date]];
    [_datePickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    // 当值发生改变的时候调用的方法
    [_datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    LewPickerController *pickerController = [[LewPickerController alloc]initWithDelegate:self];
    pickerController.pickerView = _datePickerView;
    pickerController.titleLabel.text = @"选择日期";
    [self.view addSubview:_backgroundView];
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    }];
    [pickerController showInView:self.view];
    _currentSelectDateBtn = (UIButton*)sender;
}


- (void)datePickerValueChanged:(UIDatePicker*)sender
{
    DLog(@"%@",[sender.date description]);
}

#pragma mark - UITextFieldDelegate
- (void)viewGetTouched:(NSNotification *)notifi
{
    UIEvent *event = notifi.object;
    NSSet *touches = [event allTouches];
    for (UITouch *touch in touches)
    {
        self.touchPtInView = [touch locationInView:self.window];
    }
}

- (void)keyboardWillShow:(NSNotification *)notifi
{
    NSDictionary *userInfo = [notifi userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyBoardHeight = keyboardRect.size.height;
    
    float height = PJ_SCREEN_HEIGHT - self.keyBoardHeight - 40;
    CGRect destiFrame = CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 64);
    if (self.touchPtInView.y > (height + 10))
    {
        destiFrame = CGRectMake(0, 64 - self.touchPtInView.y + height, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 64 - 75);
        [UIView animateWithDuration:0.5 animations:^{
            self.myTableView.frame = destiFrame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notifi
{
    [UIView animateWithDuration:0.5 animations:^{
        self.myTableView.frame = CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 64 - 75);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case FSTextFieldCarNum:
            textField.text = [textField.text uppercaseString];
            plateNumStr = textField.text;
            _carForm.car_num = [_carForm.car_num stringByAppendingString:plateNumStr];
            break;
            
        case FSTextFieldEngineCode:
            _carForm.engine_code = textField.text;
            break;
            
        case FSTextFieldVinCode:
            _carForm.vin_code = textField.text;
            break;
            
        default:
            break;
    }
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component) {
        return provinceAry.count;
    }
    if (1 == component)
    {
        return numberPlateAry.count;
    }
    return 10;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (0 == component) {
        return provinceAry[row];
    }
    if (1 == component)
    {
        return numberPlateAry[row];
    }
    return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

#pragma mark - LewPickerControllerDelegate
- (BOOL)lewPickerControllerShouldOKButtonPressed:(LewPickerController *)pickerController{
    if ([pickerController.pickerView isKindOfClass:[UIPickerView class]])
    {
        currentSelectPro = [_pickerView selectedRowInComponent:0];
        currentSelectNum = [_pickerView selectedRowInComponent:1];
        provinceStr = provinceAry[currentSelectPro];
        numverPlateStr = numberPlateAry[currentSelectNum];
        numberPlate = [NSString stringWithFormat:@"%@%@",provinceStr,numverPlateStr];
        [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([pickerController.pickerView isKindOfClass:[UIDatePicker class]])
    {
        NSDate *selected = _datePickerView.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];//修改时区为东8区
        NSString *destDateString = [dateFormatter stringFromDate:selected];
        [_currentSelectDateBtn setTitle:@"" forState:UIControlStateNormal];
        [_currentSelectDateBtn setTitle:destDateString forState:UIControlStateNormal];
        [_currentSelectDateBtn setTitleColor:destDateString ? FSBlackColor33 : FSGrayColor99 forState:UIControlStateNormal];
        switch (_currentSelectDateBtn.tag) {
            case 0:
                _carForm.product_date = destDateString;
                break;
                
            case 1:
                _carForm.buy_date = destDateString;
                break;
                
            case 2:
                _carForm.maintain_date = destDateString;
                break;
                
            default:
                break;
        }
    }
    [self closeBackgroundView];
    return  YES;
}

- (void)lewPickerControllerDidOKButtonPressed:(LewPickerController *)pickerController{
    [self closeBackgroundView];
}

- (void)lewPickerControllerDidCancelButtonPressed:(LewPickerController *)pickerController{
    [self closeBackgroundView];
}

- (void)closeBackgroundView
{
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
    }];
}
@end
