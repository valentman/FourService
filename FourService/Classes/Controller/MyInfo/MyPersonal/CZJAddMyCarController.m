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
    __block UIView* _backgroundView;
    
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
@property (weak, nonatomic) IBOutlet UILabel *productDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *maintainDateLabel;

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
    self.carNameLabel.text = [NSString stringWithFormat:@"%@ %@", FSBaseDataInstance.carBrandForm.name,FSBaseDataInstance.carSerialForm.name];
    self.carModelLabel.text = FSBaseDataInstance.carModealForm.name;
    [self.carBrandImg sd_setImageWithURL:[NSURL URLWithString:FSBaseDataInstance.carBrandForm.icon] placeholderImage:DefaultPlaceHolderSquare];
    
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
    provinceStr = @"川";
    numverPlateStr = @"A";
    _carPlateNumLabel.text = [NSString stringWithFormat:@"%@%@",provinceStr, numverPlateStr];
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
    
    NSMutableDictionary* carInfo = [@{ @"car_type_id": _carModealForm.modelId,
                                       @"car_num" : self.plateNumTextField.text,
                                       @"is_default" : self.defBtn.selected ? @"true" : @"false",
                                       @"vin_code":self.vinCodeTextField.text ? self.vinCodeTextField.text : @"0",
                                       @"engine_code":self.engineCodeTextField.text ? self.engineCodeTextField.text : @"0",
                                       @"buy_date":self.buyDateLabel.text ? self.buyDateLabel.text : @"0",
                                       @"product_date":self.productDateLabel.text ? self.productDateLabel.text : @"0",
                                       @"maintain_date":self.maintainDateLabel.text ? self.maintainDateLabel.text : @"0"
                                       } mutableCopy];
    [FSBaseDataInstance addMyCar:carInfo Success:^(id json) {
        [PUtils tipWithText:@"添加成功" andView:nil];
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
//        [self pickerView:_pickerView didSelectRow:currentSelectPro inComponent:0];
        [_pickerView selectRow:currentSelectPro inComponent:0 animated:YES];
    }
    if (currentSelectNum > 0)
    {
//        [self pickerView:_pickerView didSelectRow:currentSelectNum inComponent:1];
        [_pickerView selectRow:currentSelectNum inComponent:1 animated:YES];
    }

}

- (IBAction)chooseDateAction:(id)sender {
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
    currentSelectPro = [_pickerView selectedRowInComponent:0];
    currentSelectNum = [_pickerView selectedRowInComponent:1];
    provinceStr = provinceAry[currentSelectPro];
    numverPlateStr = numberPlateAry[currentSelectNum];
    NSString *numberPlate = [NSString stringWithFormat:@"%@%@",provinceStr,numverPlateStr];
    _carPlateNumLabel.text = numberPlate;
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
