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

@interface CZJAddMyCarController ()
<
LewPickerControllerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate
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
    
    NSInteger currentSelectPro;
    NSInteger currentSelectNum;
}
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOneLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTwoLayoutWidth;
@property (weak, nonatomic) IBOutlet UIImageView *carBrandImg;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *carPlateNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *defBtn;
@property (weak, nonatomic) IBOutlet UITextField *plateNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *engineCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *vinCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *productBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *maintainDateBtn;

- (IBAction)setCarDefalutAction:(id)sender;
- (IBAction)addMyCarAction:(id)sender;
- (IBAction)chooseCarPlateNumAction:(id)sender;
- (IBAction)chooseDateAction:(id)sender;

@end

@implementation CZJAddMyCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initDatas];
}

- (void)initViews
{
    [PUtils customizeNavigationBarForTarget:self];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"编辑车辆信息";
    
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
    self.viewOneLayoutHeight.constant = 0.3;
    self.viewTwoLayoutWidth.constant = 0.3;
    CGPoint pt = CGPointMake(self.carPlateNumLabel.origin.x + self.carPlateNumLabel.size.width, self.carPlateNumLabel.origin.y + self.carPlateNumLabel.size.height * 0.5);
    CAShapeLayer *indicator = [PUtils creatIndicatorWithColor:[UIColor blackColor] andPosition:pt];
    [self.viewTwo.layer addSublayer:indicator];
    
    self.plateNumTextField.delegate = self;
    
    //背景触摸层
    _backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = RGBA(100, 240, 240, 0);
}

- (void)initDatas
{
    provinceAry = [PUtils readArrayFromBundleDirectoryWithName:@"Province"];
    numberPlateAry = @[@"A",
                       @"B",
                       @"C",
                       @"D",
                       @"E",
                       @"F",
                       @"G",
                       @"H",
                       @"I",
                       @"J",
                       @"K",
                       @"L",
                       @"M",
                       @"N",
                       @"O",
                       @"P",
                       @"Q",
                       @"R",
                       @"S",
                       @"T",
                       @"U",
                       @"V",
                       @"W",
                       @"X",
                       @"Y",
                       @"Z",
                       ];
    
    NSString* curProvince ;
    NSString* curCity;
    if (IS_IOS8)
    {
        curProvince = [CCLocationManager shareLocation].province;
        curCity = [CCLocationManager shareLocation].city;
    }
    else if (IS_IOS7)
    {
        curProvince = [ZXLocationManager sharedZXLocationManager].province;
        curCity = [ZXLocationManager sharedZXLocationManager].city;
    }
    
    if (!_carForm)
    {
        self.carNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", FSBaseDataInstance.carBrandForm.car_brand_name,FSBaseDataInstance.carSerialForm.car_model_name, FSBaseDataInstance.carModealForm.car_type_name];
        [self.carBrandImg sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr, FSBaseDataInstance.carBrandForm.icon)] placeholderImage:DefaultPlaceHolderSquare];
        
        provinceStr = @"川";
        numverPlateStr = @"A";
        _carPlateNumLabel.text = [NSString stringWithFormat:@"%@%@",provinceStr, numverPlateStr];
    }
    else
    {
        self.carNameLabel.text  = [NSString stringWithFormat:@"%@ %@ %@", _carForm.car_brand_name, _carForm.car_model_name, _carForm.car_type_name];
        [self.carBrandImg sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr,_carForm.icon)] placeholderImage:DefaultPlaceHolderSquare];
        NSArray* carNumAry = [_carForm.car_num componentsSeparatedByString:@"-"];
        self.carPlateNumLabel.text = [PUtils isBlankString:carNumAry.firstObject] ? @"川A" : carNumAry.firstObject;
        self.plateNumTextField.text = carNumAry.lastObject;
        self.defBtn.selected = _carForm.is_default;
        self.vinCodeTextField.text = _carForm.vin_code;
        self.engineCodeTextField.text = _carForm.engine_code;
        
        [self.buyDateBtn setTitle:_carForm.buy_date ? _carForm.buy_date : @"点击添加" forState:UIControlStateNormal];
        [self.productBtn setTitle:_carForm.product_date ? _carForm.product_date : @"点击添加" forState:UIControlStateNormal];
        [self.maintainDateBtn setTitle:_carForm.maintain_date ? _carForm.maintain_date : @"点击添加" forState:UIControlStateNormal];
        [self.buyDateBtn setTitleColor:_carForm.buy_date ? FSBlackColor33 : FSGrayColor99 forState:UIControlStateNormal];
        [self.productBtn setTitleColor:_carForm.product_date ? FSBlackColor33 : FSGrayColor99 forState:UIControlStateNormal];
        [self.maintainDateBtn setTitleColor:_carForm.maintain_date ? FSBlackColor33 : FSGrayColor99 forState:UIControlStateNormal];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)setCarDefalutAction:(id)sender
{
    [self.view endEditing:YES];
    self.defBtn.selected = !self.defBtn.selected;
}

- (IBAction)addMyCarAction:(id)sender
{
    [self.view endEditing:YES];
    if (self.plateNumTextField.text == nil ||
        [self.plateNumTextField.text isEqualToString:@""] ||
        [PUtils isBlankString:self.plateNumTextField.text])
    {
        [PUtils tipWithText:@"请输入车牌号" andView:nil];
        return;
    }
    else if (![PUtils isLicencePlate:self.plateNumTextField.text]) {
        [PUtils tipWithText:@"请输入正确的车牌" andView:nil];
        return;
    }

    CarModelForm* _carModealForm = FSBaseDataInstance.carModealForm;
    
    NSString* modelId = _carModealForm ? _carModealForm.car_model_id: _carForm.car_type_id;
    
    NSMutableDictionary* carInfo = [@{ @"car_id" : _carForm ? _carForm.car_id : @"",
                                       @"car_type_id": modelId,
                                       @"car_num" : [NSString stringWithFormat:@"%@-%@",self.carPlateNumLabel.text, self.plateNumTextField.text],
                                       @"is_default" : self.defBtn.selected ? @"true" : @"false",
                                       @"vin_code":self.vinCodeTextField.text ? self.vinCodeTextField.text : @"0",
                                       @"engine_code":self.engineCodeTextField.text ? self.engineCodeTextField.text : @"0",
                                       @"buy_date":self.buyDateBtn.titleLabel.text ? self.buyDateBtn.titleLabel.text : @"0",
                                       @"product_date":self.productBtn.titleLabel.text ? self.productBtn.titleLabel.text : @"0",
                                       @"maintain_date":self.maintainDateBtn.titleLabel.text ? self.maintainDateBtn.titleLabel.text : @"0"
                                       } mutableCopy];
    [FSBaseDataInstance addMyCar:carInfo Success:^(id json) {
        [PUtils tipWithText:_carForm ? @"更新成功" : @"添加成功" andView:nil];
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
    } fail:^{
        
    }];
}

- (IBAction)chooseCarPlateNumAction:(id)sender
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

- (IBAction)chooseDateAction:(id)sender
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
    DLog(@"%@",sender.date);
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.plateNumTextField.text = [textField.text uppercaseString];
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
        NSString *numberPlate = [NSString stringWithFormat:@"%@%@",provinceStr,numverPlateStr];
        _carPlateNumLabel.text = numberPlate;
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
        DLog(@"%@",destDateString);
    }
    [self closeBackgroundView];
    return  YES;
}

- (void)lewPickerControllerDidOKButtonPressed:(LewPickerController *)pickerController{
    NSLog(@"OK");
    [self closeBackgroundView];
}

- (void)lewPickerControllerDidCancelButtonPressed:(LewPickerController *)pickerController{
    NSLog(@"cancel");
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
