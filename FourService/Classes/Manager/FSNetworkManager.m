//
//  FSNetworkManager.m
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "FSNetworkManager.h"
#import <AVFoundation/AVFoundation.h>

static NSString* const ImageName = @"image";
static NSString* const ImageFileName = @"imageFile";

@implementation FSNetworkManager

singleton_implementation(FSNetworkManager)
-(id)init{
    if (self = [super init]) {
        
        return self;
    }
    
    return nil;
}


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
                 DLog(@"无网络");
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 DLog(@"手机移动网络连接");
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 DLog(@"Wifi连接");
                 break;
             default:
                 break;
         }
     }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (NSString*)getPath:(NSString*)cmd{
    return [NSString stringWithFormat:@"%@%@",kCZJServerAddr,cmd];
}

- (void)postJSONWithUrl:(NSString *)urlStr
             parameters:(id)parameters
                success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail
{
    NSString* path =  [self getPath:urlStr];
    iLog(@"\nServerAPI:%@, \nParameter:%@",path,[parameters description]);
    
    //这里暂时设置成Get方式。
    [self postJSONWithUrl:path withRequestType:AFRequestTypeGet parameters:parameters success:success fail:fail];
}


- (void)postJSONWithUrl:(NSString *)urlStr
        withRequestType:(AFRequestType)requestType
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                   fail:(FailureBlockHandler)fail
{
    if (AFRequestTypePost == requestType)
    {
        [self postDataWithUrl:urlStr parameters:parameters success:success fail:fail];
    }
    else if (AFRequestTypeGet == requestType)
    {
        [self getDataWithUrl:urlStr parameters:parameters success:success fail:fail];
    }
}

//POST方法获取数据
- (void)postDataWithUrl:(NSString*)_urlStr
             parameters:(id)_parameters
                success:(void (^)(id responseObject))_success
                   fail:(void (^)())_failure
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [manager POST:_urlStr parameters:_parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_failure) {
            _failure();
        }
    }];
}


//GET方法获取数据
- (void)getDataWithUrl:(NSString*)_urlStr
            parameters:(id)_parameters
               success:(void (^)(id responseObject))_success
                  fail:(void (^)())_failure
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [manager GET:_urlStr parameters:_parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_failure) {
            _failure();
        }
    }];
}

//下载数据
- (void)downloadDataWithURL:(NSString*)_urlStr
                   progress:(void (^)(NSProgress *))_progress
                    success:(void (^)(id responseObject))_success
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    NSURLSessionDownloadTask* downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (_progress) {
            _progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString* filePath = CachesDirectory;
        return [NSURL URLWithString:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (_success) {
            _success(response);
        }
    }];
    [downloadTask resume];
}

//上传图片文件（可多张）
- (void)uploadData:(NSArray*)_uploadImageAry
         parameter:(id)_parameter
             toURL:(NSString*)_urlStr
          progress:(void (^)(NSProgress *))_progress
            sccess:(void (^)(id responseObject))_success
           failure:(void (^)())_fail
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* path =  [self getPath:_urlStr];
    
    [manager POST:path parameters:_parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(NSInteger i = 0; i < _uploadImageAry.count; i++)
        {
            UIImage* image = _uploadImageAry[i];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0);
            NSString * Name = [NSString stringWithFormat:@"%@%zi", ImageName, i+1];
            NSString * fileName = [NSString stringWithFormat:@"%@%zi.jpeg", ImageFileName,i+1];
            
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_progress) {
            _progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            DLog(@"Error::%@",[error description]);
            [PUtils tipWithText:[error description] andView:nil];
            _fail();
        }
    }];
}

//上传音频文件
- (void)uploadVoice:(NSData*)_voiceData
         parameters:(id)_param
              toURL:(NSString*)_urlStr
           progress:(void (^)(NSProgress *))_progress
            success:(void (^)(id responseObject))_success
            failure:(void (^)())_fail
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [manager POST:_urlStr parameters:_param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.amr", str];
        [formData appendPartWithFileData:_voiceData name:@"voice" fileName:fileName mimeType:@"amr/mp3/wmr"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_progress) {
            _progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            DLog(@"Error::%@",[error description]);
            _fail();
        }
    }];
}

//上传视频文件
- (void)uploadVideo:(NSData*)_videoData
         parameters:(id)_param
              toURL:(NSString*)_urlStr
           progress:(void (^)(NSProgress *))_progress
            success:(void (^)(id responseObject))_success
            failure:(void (^)())_fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [manager POST:_urlStr parameters:_param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
        [formData appendPartWithFileData:_videoData name:@"video" fileName:fileName mimeType:@"video/mpeg4"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_progress) {
            _progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            DLog(@"Error::%@",[error description]);
            _fail();
        }
    }];
}


@end
