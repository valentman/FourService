//
//  FSLoginModelManager.m
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "FSLoginModelManager.h"
#import "FSNetworkManager.h"
#import "FSErrorCodeManager.h"
#import "ZXLocationManager.h"
#import "CCLocationManager.h"
#import "FSBaseDataManager.h"
#import "XGPush.h"
#import "XGSetting.h"


@implementation FSLoginModelManager

@synthesize usrBaseForm = _usrBaseForm;

singleton_implementation(FSLoginModelManager)

-(id)init{
    if (self = [super init]) {
//        self.usrBaseForm = [[UserBaseForm alloc]init];
        return self;
    }
    return nil;
}


- (BOOL)showAlertView:(id)info{
    NSDictionary* dict = [PUtils DataFromJson:info];
    NSString *string = [[NSString alloc] initWithData:info encoding:NSUTF8StringEncoding];
    DLog(@"%@",string);
    
    NSString* msgKey = [[dict valueForKey:@"code"] stringValue];
    if (![msgKey isEqual:@"0"])
    {
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowErrorInfoWithErrorCode:msgKey];
        return NO;
    }
    return YES;
}


- (void)getAuthCodeWithIphone:(NSString*)phone
                       success:(void (^)())success
                          fail:(void (^)())fail{
    NSDictionary *params = @{@"mobile" : phone};
    
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json]) {
            success(json);
            DLog(@"获取验证码成功");
        }
    };
    FailureBlockHandler failure = ^()
    {
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        fail();
    };
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPILoginSendVerifiCode
                             parameters:params
                                success:successBlock
                                   fail:failure];
}


- (void)loginWithAuthCode:(NSString*)codeNum
              mobilePhone:(NSString*)phoneNum
                  success:(SuccessBlockHandler)success
                     fali:(SuccessBlockHandler)fail
{
    NSDictionary *params = @{@"mobile" : phoneNum,
                             @"code" : codeNum};
    
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json]) {
            success(json);
        }
        else
        {
            if (fail) {
                fail(json);
            }
        }
    };
    FailureBlockHandler failure = ^()
    {
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPILoginInByVerifiCode
                             parameters:params
                                success:successBlock
                                   fail:failure];
}


- (void)loginWithPassword:(NSString*)pwd
              mobilePhone:(NSString*)phoneNum
                  success:(SuccessBlockHandler)success
                     fali:(SuccessBlockHandler)fail
{
    NSDictionary *params = @{@"mobile" : phoneNum,
                             @"passwd" : pwd};
    
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json]) {
            success(json);
        }
        else
        {
            if (fail) {
                fail(json);
            }
        }
    };
    FailureBlockHandler failure = ^()
    {
        if (fail) {
            fail(nil);
        }
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPILoginInByPassword
                             parameters:params
                                success:successBlock
                                   fail:failure];
}

- (void)loginSuccess:(id)json
             success:(GeneralBlockHandler)sucessBlock
                fail:(FailureBlockHandler)failBlock
{
//    self.usrBaseForm =  FSBaseDataInstance.userInfoForm;
//    if (self.usrBaseForm == nil)
//    {
//        self.usrBaseForm = [[UserBaseForm alloc]init];
//    }
//    DLog(@"UserBaseForm:%@",[self.usrBaseForm.keyValues description]);
//    
//    NSDictionary* dict = [[PUtils DataFromJson:json] valueForKey:@"msg"];
//    self.usrBaseForm.chezhuId = [dict valueForKey:@"chezhuId"];
//    self.usrBaseForm.headPic = [dict valueForKey:@"headPic"];
//    self.usrBaseForm.imId = [dict valueForKey:@"imId"];
//    self.usrBaseForm.mobile = [dict valueForKey:@"mobile"];
//    self.usrBaseForm.name = [dict valueForKey:@"name"];
//    
//    DLog(@"UserBaseForm:%@",[self.usrBaseForm.keyValues description]);
//    //登录成功，个人信息写入本地文件中
//    if ([PUtils writeDictionaryToDocumentsDirectory:[self.usrBaseForm.keyValues mutableCopy] withPlistName:kCZJPlistFileUserBaseForm]) {
//        [USER_DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:kCZJIsUserHaveLogined];
//        [USER_DEFAULT synchronize]; //强制更新到本地
//        
//        //将个人信息存入数据管理单例类中，并刷新上传参数
//        FSBaseDataInstance.userInfoForm = self.usrBaseForm;
//        [FSBaseDataInstance refreshChezhuID];
//        
//        //注册个人推送
//        [XGPush setAccount:self.usrBaseForm.chezhuId];
//        
//        //注册环信
//        EMError *errorss = [[EMClient sharedClient] loginWithUsername:FSLoginModelInstance.usrBaseForm.imId password:@"123456"];
//        if (!errorss)
//        {
//            [[EMClient sharedClient].options setIsAutoLogin:YES];
//        }
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:kCZJNotifiLoginSuccess object:nil];
//        
//        if (sucessBlock)
//        {
//            sucessBlock();
//        }
//    }
//    else
//    {
//        [PUtils tipWithText:@"登录超时，请重新操作" andView:nil];
//        if (failBlock)
//        {
//            failBlock();
//        }
//    }

}

- (void)setPassword:(NSDictionary*)params
            success:(GeneralBlockHandler)success
               fali:(GeneralBlockHandler)fail;
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            NSDictionary* dict = [PUtils DataFromJson:json] ;
            success(json);
            DLog(@"设置密码成功");
//            self.usrBaseForm.chezhuId = [[dict valueForKey:@"msg"] valueForKey:@"chezhuId"];
//            self.usrBaseForm.mobile = [[dict valueForKey:@"msg"] valueForKey:@"mobile"];
//            self.usrBaseForm.cityName = [[dict valueForKey:@"msg"] valueForKey:@"cityName"];
//            self.usrBaseForm.cityId = [[dict valueForKey:@"msg"] valueForKey:@"cityId"];
        }
    };
    FailureBlockHandler failure = ^()
    {
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        fail();
    };
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIRegisterSetPassword
                             parameters:params
                                success:successBlock
                                   fail:failure];
}


- (void)loginWithDefaultInfoSuccess:(void (^)())success
                               fail:(void (^)())fail{
    
    NSDictionary* userDict = [PUtils readDictionaryFromDocumentsDirectoryWithPlistName:kCZJPlistFileUserBaseForm];
    if (!userDict)
    {
        [USER_DEFAULT setBool:NO forKey:kCZJIsUserHaveLogined];
        return;
    }
//    self.usrBaseForm = [[UserBaseForm alloc] init];
//    [self.usrBaseForm setUserInfoWithDictionary:userDict];
//    FSBaseDataInstance.userInfoForm = self.usrBaseForm;
//    [FSBaseDataInstance initPostBaseParameters];
    success();
}


- (BOOL)saveLoginInfoDataToLocal:(id)json{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [cacheDir stringByAppendingPathComponent:@"loginInfo"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (!isExists) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    NSData *resultData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",path);
    if ([resultData writeToFile:path atomically:YES]) {
        return YES;
    }
    return NO;
}


- (void)questCityIdByName:(NSString*)choiceCityName
                  success:(void (^)(id json))success
                     fail:(void (^)())fail{
    __block  double tmp_lat = 0;
    __block  double tmp_lng = 0;
    
    if (IS_IOS8) {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            tmp_lat = locationCorrrdinate.latitude;
            tmp_lng = locationCorrrdinate.longitude;
            DLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
        }];
    }else if(IS_IOS7){
        [[ZXLocationManager sharedZXLocationManager] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate){
            tmp_lat = locationCorrrdinate.latitude;
            tmp_lng = locationCorrrdinate.longitude;
            DLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);}];
    }
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json]) {
            NSDictionary* dict = [PUtils DataFromJson:json];
//            self.usrBaseForm.cityId = [[dict valueForKey:@"msg"] valueForKey:@"cityId"];
//            self.usrBaseForm.cityName = [[dict valueForKey:@"msg"] valueForKey:@"cityName"];
            DLog(@"login suc");
            success(json);
        }
    };
    FailureBlockHandler failure = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        fail();
    };
    NSDictionary *params = @{@"cityName" : choiceCityName};
    [[FSNetworkManager sharedFSNetworkManager] postJSONWithUrl:@"chezhu/loadCityIdByName.do"
                                                      parameters:params
                                                         success:successBlock
                                                            fail:failure];
}

@end
