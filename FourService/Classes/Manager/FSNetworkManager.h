//
//  FSNetworkManager.h
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface FSNetworkManager : AFHTTPSessionManager
{    
}

singleton_interface(FSNetworkManager)

- (void)checkNetWorkStatus;

//Get请求网络数据
- (void)GetJSONDataWithUrl:(NSString *)url
                 parameter:(id)parameter
                   success:(SuccessBlockHandler) success
                      fail:(FailureBlockHandler)fail;
//Post请求网络数据
- (void)postJSONWithNoServerAPI:(NSString *)urlStr
                     parameters:(id)parameters
                        success:(SuccessBlockHandler)success
                           fail:(FailureBlockHandler)fail;

- (void)postJSONWithUrl:(NSString *)urlStr
             parameters:(id)parameters
                success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail;

- (void)postJSONWithUrl:(NSString *)urlStr
        withRequestType:(AFRequestType)requestType
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                   fail:(FailureBlockHandler)fail;

- (void)postJSONWithParameters:(id)parameters
                       success:(GeneralBlockHandler)success
                          fail:(FailureBlockHandler)fail;

- (void)sessionDownloadWithUrl:(NSString *)urlStr
                       success:(void (^)(NSURL *fileURL))success
                          fail:(FailureBlockHandler)fail;

- (void)loadImagePath:(NSString*)path
             callback:(void (^)(id responseObject))callfun;

- (void)uploadImageWithUrl:(NSString *)urlStr
                     Image:(UIImage *)image
                Parameters:(id)parameters
                   success:(SuccessBlockHandler)success
                   failure:(FailureBlockHandler)failure;

- (void)saveImage:(UIImage *)image withFilename:(NSString *)filename;
@end
