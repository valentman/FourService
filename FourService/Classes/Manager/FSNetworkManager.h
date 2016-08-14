//
//  FSNetworkManager.h
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface FSNetworkManager : AFHTTPSessionManager
{    
}

singleton_interface(FSNetworkManager)

/**
 *
 */
- (void)checkNetWorkStatus;


- (void)postJSONWithUrl:(NSString *)urlStr
             parameters:(id)parameters
                success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail;


- (void)postJSONWithUrl:(NSString *)urlStr
        withRequestType:(AFRequestType)requestType
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                   fail:(FailureBlockHandler)fail;


/**
 *  Get Data From Specific URL By POST Method
 *
 */
- (void)postDataWithUrl:(NSString* _Nonnull)_urlStr
             parameters:(id __nullable)_parameters
                success:(nullable void (^)(id _Nonnull responseObject))_success
                   fail:(nullable void (^)())_failure;
/**
 *  Get Data From Specific URL By GET Method
 *
 */
- (void)getDataWithUrl:(NSString* _Nonnull)_urlStr
            parameters:(id __nullable)_parameters
               success:(nullable void (^)(id _Nonnull responseObject))_success
                  fail:(nullable void (^)())_failure;


/**
 *  Download Data From Specific URL
 *
 *  @param _urlStr     paramesters
 *  @param _progress   progress callback
 *  @param _success    success callback
 */
- (void)downloadDataWithURL:(NSString* _Nonnull)_urlStr
                   progress:(nullable void (^)(NSProgress * _Nonnull))_progress
                    success:(nullable void (^)(id _Nonnull responseObject))_success;


/**
 *  upload ImageData to Service
 *
 *  @param _uploadImageAry image Ary
 *  @param _parameter      paramesters
 *  @param _urlStr         service url
 *  @param _progress       progress callback
 *  @param _success        success callback
 *  @param _fail           fail callback
 */
- (void)uploadData:(NSArray* _Nonnull)_uploadImageAry
         parameter:(id __nullable)_parameter
             toURL:(NSString* _Nonnull)_urlStr
          progress:(nullable void (^)(NSProgress * _Nonnull))_progress
            sccess:(nullable void (^)(id _Nonnull responseObject))_success
           failure:(nullable void (^)())_fail;


/**
 *  upload  Voice Data to Service
 *
 *  @param _data     voice data
 *  @param _param    paramesters
 *  @param _urlStr   service url
 *  @param _progress progress callback
 *  @param _success  success callback
 *  @param _fail     fail callback
 */
- (void)uploadVoice:(NSData* _Nonnull)_voiceData
         parameters:(__nullable id)_param
              toURL:(NSString* _Nonnull)_urlStr
           progress:(nullable void (^)(NSProgress * _Nonnull))_progress
            success:(nullable void (^)(id _Nonnull responseObject))_success
            failure:(nullable void (^)())_fail;


/**
 *  upload  Video Data to Service
 *
 *  @param _videoData voice data
 *  @param _param     paramesters
 *  @param _urlStr    service url
 *  @param _progress  progress callback
 *  @param _success   success callback
 *  @param _fail      fail callback
 */
- (void)uploadVideo:(NSData* _Nonnull)_videoData
         parameters:(id __nullable)_param
              toURL:(NSString* _Nonnull)_urlStr
           progress:(nullable void (^)(NSProgress * _Nonnull))_progress
            success:(nullable void (^)(id _Nonnull responseObject))_success
            failure:(nullable void (^)())_fail;
@end
