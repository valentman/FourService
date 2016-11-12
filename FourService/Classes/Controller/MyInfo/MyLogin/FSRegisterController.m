//
//  FSRegisterController.m
//  CZJShop
//
//  Created by Joe.Pen on 12/21/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "FSRegisterController.h"
#import "LJWKeyboardHandlerHeaders.h"
#import "FSLoginController.h"
#import "FSBaseDataManager.h"
#import "XGPush.h"
#define kLoginColorRed RGB(255, 102, 102)



typedef NS_ENUM(NSUInteger, RegistStageType)
{
    RegistStageTypeVerifyCode = 1,
    RegistStageTypeSetPwd,
    RegistStageTypeSuccess
};


@interface FSRegisterController ()
<
UITextFieldDelegate,
UIGestureRecognizerDelegate,
FDAlertViewDelegate
>
{
    BOOL isIdentityVerify;
    NSDictionary* vertifySuccessDict;
    RegistStageType currentStageType;
}

@property (weak, nonatomic) IBOutlet UIButton *identityButton;
@property (weak, nonatomic) IBOutlet UIButton *setPWDButton;
@property (weak, nonatomic) IBOutlet UIButton *registSuccessButton;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumPrompt;
@property (weak, nonatomic) IBOutlet UILabel *pwdPrompt;
@property (weak, nonatomic) IBOutlet UILabel *repeatPwdPrompt;
@property (weak, nonatomic) IBOutlet UILabel *codePrompt;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;


@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *rePwdView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *protocolView;
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;

@property (weak, nonatomic) IBOutlet UILabel *daojishiLab;
@property (weak, nonatomic) IBOutlet UIButton *isPasswordTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *isRePasswordTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeProtocolBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtnTop;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;


- (IBAction)getCodeAction:(id)sender;
- (IBAction)confirmAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)isSecurityPwdAction:(id)sender;


@end

@implementation FSRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self registerLJWKeyboardHandler];
    [self initViews];
}

- (void)initViews
{
    //顶部步骤按钮颜色
    [self setStageButtonColor:RegistStageTypeSetPwd];
    
    self.phoneNumTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.repeatPwdTextField.delegate = self;
    self.codeTextField.delegate = self;
    
    [self.phoneNumTextField setTag:1000];
    [self.pwdTextField setTag:1001];
    [self.codeTextField setTag:1002];
    [self.repeatPwdTextField setTag:1003];
    self.pwdTextField.secureTextEntry = YES;
    self.repeatPwdTextField.secureTextEntry = YES;
    
    [self.isPasswordTypeBtn setSelected:NO];
    [self.isRePasswordTypeBtn setSelected:NO];
    
    [self.confirmBtn setEnabled:YES];
    self.confirmBtn.backgroundColor = [UIColor lightGrayColor];

    [self.agreeProtocolBtn setSelected:YES];
    
    
    if (![PUtils isBlankString:self.phoneNum])
    {
        self.phoneNumTextField.text = self.phoneNum;
        self.phoneNumPrompt.hidden = YES;
        [self.phoneNumTextField becomeFirstResponder];
    }
    
    vertifySuccessDict = [NSDictionary dictionary];
    isIdentityVerify = YES;
    [self.daojishiLab setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark- Actions
- (IBAction)getCodeAction:(id)sender
{
    //输入内容校验（是不是手机号，以及有没有输入文字）
    if ([PUtils isBlankString:self.phoneNumTextField.text] ||
        ![PUtils isPhoneNumber:self.phoneNumTextField.text])
    {
        [PUtils tipWithText:@"请输入正确手机号码!" onView:self.view];
        return;
    }
    
    if (self.getCodeBtn.enabled)
    {
//        GeneralBlockHandler successblock = ^(){
//            [self.getCodeBtn setEnabled:NO];
//            [self.getCodeBtn setHidden:YES];
//            [self.daojishiLab setHidden:NO];
//            
//            [self.codeTextField becomeFirstResponder];
//            
//            __block int timeout=119; //倒计时时间
//            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//            dispatch_source_set_event_handler(timer, ^{
//                if(timeout<=0){ //倒计时结束，关闭
//                    dispatch_source_cancel(timer);
//                    timer = nil;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //设置界面的按钮显示 根据自己需求设置
//                        [self.getCodeBtn setEnabled:YES];
//                        [self.getCodeBtn setHidden:NO];
//                        [self.daojishiLab setHidden:YES];
//                        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                    });
//                }else{
//                    int seconds = timeout % 120;
//                    NSString *strTime = [NSString stringWithFormat:@"重新发送(%d)", seconds];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //设置界面的按钮显示 根据自己需求设置
//                        [self.getCodeBtn setEnabled:NO];
//                        [self.getCodeBtn setHidden:YES];
//                        [self.daojishiLab setHidden:NO];
//                        [self.daojishiLab setText:strTime];
//                    });
//                    timeout--;
//                }
//            });
//            dispatch_resume(timer);
//        };
        
        //临时用图片验证码代替
        [self.imageCode sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr, kFSServerAPIVerifyCode) ] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.getCodeBtn setEnabled:NO];
            [self.getCodeBtn setHidden:YES];
        }];

    }
}

- (IBAction)confirmAction:(id)sender
{
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    NSDictionary* params = @{@"customer_pho":self.phoneNumTextField.text,
                             @"password" : self.pwdTextField.text,
                             @"repassword" : self.repeatPwdTextField.text,
                             @"verify" : self.codeTextField.text};
    SuccessBlockHandler success = ^(id json)
    {
        [weakSelf setStageButtonColor:RegistStageTypeSuccess];
        
        [weakSelf loginSuccess:json success:^{
            [PUtils tipWithText:@"登录成功" andView:nil];
            [weakSelf exitAction:nil];
        } fail:^{
            
        }];
    };
    FailureBlockHandler failure = ^(){
        
    };
    
    [FSBaseDataInstance userRegistWithParam:params success:success fail:failure];
    
    return;

    
    //验证手机有效性
    if (isIdentityVerify &&
        self.phoneNumTextField.text.length == 11 &&
        self.codeTextField.text.length > 0)
    {
        [self.confirmBtn setEnabled:NO];
        self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
        SuccessBlockHandler successBlock = ^(id json){
            vertifySuccessDict = [[PUtils DataFromJson:json] valueForKey:@"msg"];
            if ([[vertifySuccessDict valueForKey:@"code"] integerValue] != 0)
            {
                [self showAlert:[vertifySuccessDict valueForKey:@"msg"]];
                return;
            }
            
            //身份验证成功
            [PUtils tipWithText:@"身份验证成功，请设置密码" withCompeletHandler:^{
                [self.pwdTextField becomeFirstResponder];
            }];
            isIdentityVerify = NO;
            
            //顶部身份验证和设置密码栏重置
            [self setStageButtonColor:currentStageType];
            
            
            
        };
        FailureBlockHandler failure = ^{
            NSLog(@"login fail");
            self.confirmBtn.enabled = YES;
            [self.confirmBtn setBackgroundColor:kLoginColorRed];
        };
        
        [FSBaseDataInstance verifyCodeWithParam:@{@"verify":self.codeTextField.text} success:successBlock fail:failure];
    }
//    //重设密码中
//    if (!isIdentityVerify &&
//        self.pwdTextField.text.length > 0)
//    {
//        [self.confirmBtn setEnabled:NO];123
    
//        SuccessBlockHandler successBlock = ^(id json){
//            NSDictionary* dict = [PUtils DataFromJson:json];
//            if ([[dict valueForKey:@"code"] integerValue] != 0)
//            {
//                [self showAlert:[dict valueForKey:@"msg"]];
//                
//            }
//            __weak typeof(self) weakSelf = self;
//            [PUtils tipWithText:@"设置密码成功,请到登录页面重新登录" withCompeletHandler:^{
//                [weakSelf.confirmBtn setEnabled:YES];
//                weakSelf.confirmBtn.backgroundColor = kLoginColorRed;
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//            
//        };
//        FailureBlockHandler failure = ^{
//            NSLog(@"login fail");
//            [self.confirmBtn setEnabled:YES];
//            self.confirmBtn.backgroundColor = kLoginColorRed;
//        };
//        NSString* pwdStr = self.pwdTextField.text;
//        NSDictionary* parms = @{@"chezhuId": [vertifySuccessDict valueForKey:@"chezhuId"],
//                                @"mobile": [vertifySuccessDict valueForKey:@"mobile"],
//                                @"passwd": pwdStr,
//                                };
////        [CZJLoginModelInstance setPassword:parms success:successBlock fali:failure];
//    }
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exitAction:(id)sender
{
    NSArray* views = [self.navigationController viewControllers];
    for (id view in views)
    {
        if ([view isKindOfClass:[FSLoginController class]])
        {
            [view exitOutAction:nil];
        }
    }
}

- (IBAction)isSecurityPwdAction:(UIButton *)sender {
    BOOL flag = sender.isSelected;
    [sender setSelected:!flag];
    if (sender.tag == 0) {
        self.pwdTextField.secureTextEntry = flag;
    }
    if (sender.tag == 1) {
        self.repeatPwdTextField.secureTextEntry = flag;
    }
}

- (void)showAlert:(NSString*)str{
    [PUtils tipWithText:str onView:self.view];
}


- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld", (long)buttonIndex);
}


#pragma mark - TextField
- (LJWKeyboardHandler *)registerLJWKeyboardHandler
{
    self.ljwKeyboardHandler = [[LJWKeyboardHandler alloc] init];
    return self.ljwKeyboardHandler;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1000:
            [self.phoneNumPrompt setHidden:YES];
            break;
            
        case 1001:
            [self.pwdPrompt setHidden:YES];
            break;
            
        case 1002:
            [self.codePrompt setHidden:YES];
            break;
            
        case 1003:
            [self.repeatPwdPrompt setHidden:YES];
            break;
            
        default:
            break;
    }
    DLog();
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self dealWithTextField:textField textStr:new_text_str];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self dealWithTextField:textField textStr:textField.text];
}

- (void)dealWithTextField:(UITextField *)textField textStr:(NSString*)textFieldStr
{
    DLog(@"%@",textFieldStr);
    switch (textField.tag) {
        case 1000:
            [self.phoneNumPrompt setHidden:!(textFieldStr.length == 0)];
            break;
            
        case 1001:
            [self.pwdPrompt setHidden:!(textFieldStr.length == 0)];
            break;
            
        case 1003:
            [self.repeatPwdPrompt setHidden:!(textFieldStr.length == 0)];
            
            break;
            
        case 1002:
            [self.codePrompt setHidden:!(textFieldStr.length == 0)];
            break;
            
        default:
            break;
    }
    
    BOOL confirmBtnEnable = NO;
    switch (currentStageType) {
        case RegistStageTypeVerifyCode: {
            if (self.phoneNumTextField.text.length == 11 &&
                self.codeTextField.text.length > 0) {
                confirmBtnEnable = YES;
            }
            break;
        }
        case RegistStageTypeSetPwd: {
            if (self.phoneNumTextField.text.length == 11 &&
                self.pwdTextField.text.length > 0 &&
                self.repeatPwdTextField.text.length > 0) {
                confirmBtnEnable = YES;
            }
            break;
        }
        case RegistStageTypeSuccess: {
            
            break;
        }
    }
    if (confirmBtnEnable)
    {
        self.confirmBtn.enabled = YES;
        [self.confirmBtn setBackgroundColor:kLoginColorRed];
    }
    if (textFieldStr.length == 0)
    {
        self.confirmBtn.enabled = NO;
        [self.confirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setStageButtonColor:(RegistStageType)stageNum
{
    currentStageType = stageNum;
    [self.identityButton setTitleColor:((stageNum == RegistStageTypeVerifyCode) ? BLACKCOLOR : CZJGRAYCOLOR) forState:UIControlStateNormal];
    [self.setPWDButton setTitleColor:((stageNum == RegistStageTypeSetPwd) ? BLACKCOLOR : CZJGRAYCOLOR) forState:UIControlStateNormal];
    [self.registSuccessButton setTitleColor:((stageNum == RegistStageTypeSuccess) ? BLACKCOLOR : CZJGRAYCOLOR) forState:UIControlStateNormal];
    self.identityButton.titleLabel.font = (stageNum == RegistStageTypeVerifyCode) ? BOLDSYSTEMFONT(15) :SYSTEMFONT(14);
    self.setPWDButton.titleLabel.font = (stageNum == RegistStageTypeSetPwd) ? BOLDSYSTEMFONT(15) :SYSTEMFONT(14);
    self.registSuccessButton.titleLabel.font = (stageNum == RegistStageTypeSuccess) ? BOLDSYSTEMFONT(15) :SYSTEMFONT(14);
    
    switch (stageNum) {
        case RegistStageTypeVerifyCode: {
            
            break;
        }
        case RegistStageTypeSetPwd: {
            //密码栏显示，验证码栏和服务协议隐藏
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.5 animations:^{
                //遍历查找view的heigh约束，并修改它
                [self.codeView setHidden:YES];
                [self.pwdView setHidden:NO];
                [self.rePwdView setHidden:NO];
                [self.protocolView setHidden:YES];
                self.confirmBtnTop.constant = 150;
                //更新约束  在某个时刻约束会被还原成frame使视图显示
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self.confirmBtn setEnabled:YES];
                self.confirmBtn.backgroundColor = FSBLUECOLOR;
            }];
            
//            self.phoneNumTextField.enabled = NO;
//            self.phoneNumTextField.textColor = [UIColor lightGrayColor];
            break;
        }
        case RegistStageTypeSuccess: {
            [self.phoneNumView setHidden:YES];
            [self.codeView setHidden:YES];
            [self.pwdView setHidden:YES];
            [self.rePwdView setHidden:YES];
            [self.protocolView setHidden:YES];
            [self.confirmBtn setHidden:YES];
            break;
        }
    }
}

- (void)loginSuccess:(id)json
             success:(GeneralBlockHandler)sucessBlock
                fail:(GeneralBlockHandler)failBlock
{
    NSDictionary* dict = [json valueForKey:@"data"];
    FSBaseDataInstance.userInfoForm.identifier = [dict valueForKey:@"identifier"];
    FSBaseDataInstance.userInfoForm.token = [dict valueForKey:@"token"];
    
    //登录成功，个人信息写入本地文件中
    if ([PUtils writeDictionaryToDocumentsDirectory:[FSBaseDataInstance.userInfoForm.keyValues mutableCopy] withPlistName:kCZJPlistFileUserBaseForm])
    {
        [USER_DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:kCZJIsUserHaveLogined];
        [USER_DEFAULT synchronize]; //强制更新到本地
        
        //更新基本参数
        [FSBaseDataInstance.baseParams setValue:[dict valueForKey:@"identifier"] forKey:@"identifier"];
        [FSBaseDataInstance.baseParams setValue:[dict valueForKey:@"token"] forKey:@"token"];
        
        //注册个人推送
        [XGPush setAccount:FSBaseDataInstance.userInfoForm.identifier];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kCZJNotifiLoginSuccess object:nil];
        
        if (sucessBlock)
        {
            sucessBlock();
        }
    }
    else
    {
        [PUtils tipWithText:@"登录超时，请重新操作" andView:nil];
        if (failBlock)
        {
            failBlock();
        }
    }
    
}

@end
