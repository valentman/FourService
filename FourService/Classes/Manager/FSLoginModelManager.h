//
//  FSLoginModelManager.h
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDAlertView.h"

@class UserBaseForm;

@interface FSLoginModelManager : NSObject{
    UserBaseForm* _usrBaseForm;
}
@property(nonatomic,retain)UserBaseForm* usrBaseForm;

singleton_interface(FSLoginModelManager)

//获取验证码
- (void)getAuthCodeWithIphone:(NSString*)phone
                       success:(GeneralBlockHandler)success
                          fail:(GeneralBlockHandler)fail;

//验证码登录
- (void)loginWithAuthCode:(NSString*)codeNum
              mobilePhone:(NSString*)phoneNum
                  success:(SuccessBlockHandler)success
                     fali:(SuccessBlockHandler)fail;
//密码登录
- (void)loginWithPassword:(NSString*)pwd
              mobilePhone:(NSString*)phoneNum
                  success:(SuccessBlockHandler)success
                     fali:(SuccessBlockHandler)fail;

//启动验证是否登录成功，登录成功则获取用户信息
- (void)loginWithDefaultInfoSuccess:(GeneralBlockHandler)success
                               fail:(GeneralBlockHandler)fail;

//设置密码（注册或忘记密码重置）
- (void)setPassword:(NSDictionary*)params
            success:(GeneralBlockHandler)success
               fali:(GeneralBlockHandler)fail;

//查询自己的城市ID
- (void)questCityIdByName:(NSString*)choiceCityName
                  success:(SuccessBlockHandler)success
                     fail:(GeneralBlockHandler)fail;

//登录成功，写入本地文件
- (void)loginSuccess:(id)json
             success:(GeneralBlockHandler)sucessBlock
                fail:(FailureBlockHandler)failBlock;

@end
