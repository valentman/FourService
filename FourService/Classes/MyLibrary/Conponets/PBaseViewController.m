//
//  PBaseViewController.m
//  FourService
//
//  Created by Joe.Pen on 12/22/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "PBaseViewController.h"


@interface PBaseViewController ()
<
PBaseNaviagtionBarViewDelegate,
UIGestureRecognizerDelegate
>

@property (strong, nonatomic) __block UIView* notifyView;

@end

@implementation PBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCZJVCDatas];
    [self checkNetWorkStatus];
}

- (void)initCZJVCDatas
{
    self.windowAlpha = 1.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * @naviBarViewType 这里根据传入自定义导航栏的类型初始相应的导航栏视图加入到当前视图控制器上
 */
- (void)addCZJNaviBarView:(CZJNaviBarViewType)naviBarViewType
{
    self.navigationController.navigationBarHidden = YES;
    [self addCZJNaviBarViewWithNotHiddenNavi:naviBarViewType];
}

- (void)addCZJNaviBarViewWithNotHiddenNavi:(CZJNaviBarViewType)naviBarViewType
{
    _naviBarView = [[PBaseNaviagtionBarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64) AndType:naviBarViewType];
    _naviBarView.delegate = self;
    [self.view addSubview:_naviBarView];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (self.searchStr != nil)
    {
        self.naviBarView.customSearchBar.text = self.searchStr;
    }
}

#pragma mark - PBaseNaviagtionBarViewDelegate(自定义导航栏按钮回调)
- (void)clickEventCallBack:(nullable id)sender
{
    UIButton* barButton = (UIButton*)sender;
    switch (barButton.tag) {
        case CZJButtonTypeNaviBarMore:
            break;
            
        case CZJButtonTypeNaviBarBack:
            [self.navigationController popViewControllerAnimated:true];
            break;
            
        case CZJButtonTypeHomeShopping:
            
            break;
            
        default:
            break;
    }
}

/* 每当跳转到继承自当前自定义视图控制器时，都进行网络状态检查，以提示用户当前网络状况 */
- (void)checkNetWorkStatus
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 DLog(@"未知网络状态");
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 [PUtils tipWithText:@"请检查网络设置，确保连接网络" andView:nil];
                 _isNetWorkCanReachable = NO;
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 _isNetWorkCanReachable = YES;
                 DLog(@"手机自有网络连接");
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 _isNetWorkCanReachable = YES;
                 DLog(@"Wifi连接");
                 break;
             default:
                 break;
         }
     }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


- (void)showFSAlertView:(NSString*)promptStr
       andConfirmHandler:(GeneralBlockHandler)confirmBlock
        andCancleHandler:(GeneralBlockHandler)cancleBlock
{
    self.cancleBlock = cancleBlock;
    FSBaseAlertViewController* alertViewVC = [[FSBaseAlertViewController alloc]init];
    self.popWindowInitialRect = ZEROVERTICALHIDERECT;
    self.popWindowDestineRect = ZERORECT;
    self.windowAlpha = 0;
    [PUtils showMyWindowOnTarget:self withPopVc:alertViewVC];
    alertViewVC.popView.descLabel.text = promptStr;
    [alertViewVC.popView.cancelBtn addTarget:self action:@selector(hideWindow) forControlEvents:UIControlEventTouchUpInside];
    [alertViewVC setConfirmItemHandle:confirmBlock];
}

- (void)hideWindow
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.window.frame = self.popWindowInitialRect;
        self.windowAlpha = 1.0f;
        self.upView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.upView removeFromSuperview];
            [self.window resignKeyWindow];
            self.window  = nil;
            self.upView = nil;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            if (self.cancleBlock) self.cancleBlock();
        }
    }];
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
