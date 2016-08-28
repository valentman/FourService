//
//  AppDelegate.m
//  FourService
//
//  Created by Joe.Pen on 6/28/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "AppDelegate.h"
#import "CCLocationManager.h"
#import "ZXLocationManager.h"
#import "FSBaseDataManager.h"
#import "PUtils.h"
#import "OpenShareHeader.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XGPush.h"
#import "XGSetting.h"
#import "JRSwizzle.h"
#import "KMCGeigerCounter.h"
#import "FSServiceListController.h"
#import "FSMyInformationController.h"
#import "YQSlideMenuController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //-------------------1.设置状态栏隐藏，因为有广告------------------
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    //------------------2.设置URL缓存机制----------------
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:40 * 1024 * 1024 diskCapacity:40 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    //------------------3.登录设置----------------
    [FSBaseDataInstance loginWithDefaultInfoSuccess:^
     {
//         if (![USER_DEFAULT valueForKey:kCZJDefaultCityID] ||
//             ![USER_DEFAULT valueForKey:kCZJDefaultyCityName])
//         {
//             [USER_DEFAULT setObject:kCZJChengduID forKey:kCZJDefaultCityID];
//             [USER_DEFAULT setObject:kCZJChengdu forKey:kCZJDefaultyCityName];
//             CZJLoginModelInstance.usrBaseForm.cityId = kCZJChengduID;
//             CZJLoginModelInstance.usrBaseForm.cityName = kCZJChengdu;
//             [CZJBaseDataInstance setCurCityName:kCZJChengdu];
//         }
//         else
//         {
//             CZJLoginModelInstance.usrBaseForm.cityId = [USER_DEFAULT valueForKey: kCZJDefaultCityID];
//             CZJLoginModelInstance.usrBaseForm.cityName = [USER_DEFAULT valueForKey:kCZJDefaultyCityName];
//             [CZJBaseDataInstance setCurCityName:[USER_DEFAULT valueForKey:kCZJDefaultyCityName]];
//         }
         
//         UserBaseForm* userForm = CZJBaseDataInstance.userInfoForm;
//         //应该先判断是否设置了自动登录，如果设置了，则不需要您再调用
//         EMError *erroras = [[EMClient sharedClient] loginWithUsername:userForm.imId password:@"123456"];
//         if (erroras)
//         {
//             DLog(@"*********%@",erroras.errorDescription);
//         }
     } fail:^{
         
     }];
    
    //--------------------4.初始化定位-------------------
    if (IS_IOS8)
    {
        [[CCLocationManager shareLocation]getCity:^(NSString *addressString) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([USER_DEFAULT doubleForKey:CCLastLatitude],[USER_DEFAULT doubleForKey:CCLastLongitude]);
            [FSBaseDataInstance setCurLocation:location];
            [FSBaseDataInstance setCurCityName:addressString];
        }];
    }
    else if (IS_IOS7)
    {
        [[ZXLocationManager sharedZXLocationManager]getCityName:^(NSString *addressString) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([USER_DEFAULT doubleForKey:CCLastLatitude],[USER_DEFAULT doubleForKey:CCLastLongitude]);
            [FSBaseDataInstance setCurLocation:location];
            [FSBaseDataInstance setCurCityName:addressString];
        }];
    }
    
    //--------------------5.推送注册中心-----------------
    [XGPush startApp:kCZJPushServerAppId appKey:kCZJPushServerAppKey];
    //注销之后需要再次注册前的准备
    GeneralBlockHandler successBlock = ^(void)
    {
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            if(IS_IOS8)
            {
                [self registerPushForIOS8];
            }
            else
            {
                [self registerPush];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successBlock];
    
    //推送反馈回调版本示例
    GeneralBlockHandler _successBlock = ^(void){
        //成功之后的处理
        DLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    GeneralBlockHandler _errorBlock = ^(void){
        //失败之后的处理
        DLog(@"[XGPush]handleLaunching's errorBlock");
    };
    [XGPush handleLaunching:launchOptions successCallback:_successBlock errorCallback:_errorBlock];
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    iLog(@"========CZJ launchOptions:%@",[launchOptions description]);
    
    
    //-----------------6.设置主页并判断是否启动广告页面--------------
#ifdef DEBUG//离线日志打印
    self.window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif
    UIViewController *contentViewController = [PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"4S"];
    
    UIViewController* leftMenuViewController = [PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"4SMyInfo"];
    YQSlideMenuController *sideMenuController = [[YQSlideMenuController alloc] initWithContentViewController:contentViewController
                                                                                      leftMenuViewController:leftMenuViewController];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:sideMenuController];
    sideMenuController.scaleContent = NO;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    //---------------------7.分享设置---------------------
    [OpenShare connectQQWithAppId:kCZJOpenShareQQAppId];
    [OpenShare connectWeiboWithAppKey:kCZJOpenShareWeiboAppKey];
    [OpenShare connectWeixinWithAppId:kCZJOpenShareWeixinAppId];
    [OpenShare connectAlipay];
    
    
    //-------------------8.字典描述分类替换----------------
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    
    
    //--------------------9.开启帧数显示------------------
    [KMCGeigerCounter sharedGeigerCounter].enabled = NO;
    
    return YES;
}


#pragma mark- PushNotification
//注册系统为IOS8及以后的版本推送服务
- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

//注册系统为IOS8之前的版本推送服务
- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    iLog(@"========CZJ 注册用户通知成功");
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}
#endif


//注册远程通知获取deviceToken成功回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    GeneralBlockHandler successBlock = ^(void){
        //成功之后的处理
        DLog(@"[XGPush]register successBlock");
    };
    
    GeneralBlockHandler errorBlock = ^(void){
        //失败之后的处理
        DLog(@"[XGPush]register errorBlock");
    };
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    [USER_DEFAULT setValue:deviceToken forKey:kUserDefaultDeviceTokenStr];
    iLog(@"========CZJ 设备deviceTokenStr:%@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"%@", [NSString stringWithFormat: @"[XGPush] Error: %@",error]);
}


#pragma mark- 应用跳转
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        DLog(@"result ---- = %@",resultDic);
        if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCZJAlipaySuccseful object:resultDic];
        }
    }];
    
    DLog(@"%@",url.absoluteString);
    //第二步：添加回调
    if (![url.absoluteString hasPrefix:@"CheZhiJian"]) {
        DLog(@"微信");
        return [OpenShare handleOpenURL:url];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
