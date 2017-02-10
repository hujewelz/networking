//
//  HUAPIProxy.m
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUApiProxy.h"
#import "AFURLSessionManager.h"
#import "HUApiURLRequestGenerator.h"
#import "AFURLResponseSerialization.h"
#import "HULogger.h"

@interface HUApiProxy ()

//AFNetworking stuff
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
// 根据 requestid，存放 task
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;


@end

@implementation HUApiProxy

+ (instancetype)sharedInstance {
    static HUApiProxy *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[HUApiProxy alloc] init];
    });
    return api;
}

- (NSUInteger)callGETWithParams:(NSDictionary *)params apiName:(NSString *)apiName success:(HUCallback)success failure:(HUCallback)failure {
    NSURLRequest *request = [[HUApiURLRequestGenerator sharedInstance] generateGETRequestWithParamas:params apiMethodName:apiName];
    NSNumber *requestID = [self callRequestWithRequest:request success:success failure:failure];
    return requestID.integerValue;
}

- (NSUInteger)callPOSTWithParams:(NSDictionary *)params apiName:(NSString *)apiName success:(HUCallback)success failure:(HUCallback)failure {
    NSURLRequest *request = [[HUApiURLRequestGenerator sharedInstance] generatePOSTRequestWithParamas:params apiMethodName:apiName];
    NSNumber *requestID = [self callRequestWithRequest:request success:success failure:failure];
    return requestID.integerValue;
}

/**
 *  取消网络请求
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList {
    typeof(self) __weak weakSelf = self;
    [requestIDList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task = [weakSelf.dispatchTable objectForKey:obj];
        [task cancel];
    }];
    [self.dispatchTable removeObjectsForKeys:requestIDList];
}

#pragma mark - private

- (NSNumber *)callRequestWithRequest:(NSURLRequest *)request success:(HUCallback)success failure:(HUCallback)failure {

    NSNumber *requestId = [self generateRequestId];
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request
                                                        completionHandler:^(NSURLResponse * _Nonnull response,
                                                                            id  _Nullable responseObject,
                                                                            NSError * _Nullable error)
    {
        NSURLSessionDataTask *storedTask = self.dispatchTable[requestId];
        if (storedTask == nil) {
            return ;
        }
        else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (!error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            [HULogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response resposeString:responseString error:nil];
            success?success(json, nil):nil;
        }
        else {
            [HULogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response resposeString:responseString error:error];
            failure?failure(nil, error):nil;
        }
        
    }];
    
    self.dispatchTable[requestId] = task;
    [task resume];
    return requestId;
}

- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

#pragma mark - upload task 

- (void)uploadData:(id)data
        withParams:(NSDictionary *)params
         URLString:(NSString *)URLString
          filePath:(id)filePath
           success:(HUCallback)success
           failure:(HUCallback)failure {
  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    if ([data isKindOfClass:[NSData class]]) {
      NSDate *date = [NSDate date];
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:[NSString stringWithFormat:@"yyMMddHHmmss"]];
      
      NSString *subfix = [filePath lastPathComponent];
      NSString *mimeType = [self getMIMEType:filePath];
      NSString *filename = [NSString stringWithFormat:@"%@%@", [formatter stringFromDate:date],subfix];
      
      [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:mimeType];
    }
    else if ([data isKindOfClass:[NSArray class]] &&
             [filePath isKindOfClass:[NSArray class]]){
      NSArray *dataArray = data;
      NSArray *filePathArray = filePath;
      [dataArray enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:[NSString stringWithFormat:@"yyMMddHHmmss"]];
        
        NSString *path = filePathArray[idx];
        NSString *subfix = [path lastPathComponent];
        NSString *mimeType = [self getMIMEType:path];
        NSString *filename = [NSString stringWithFormat:@"%@%@", [formatter stringFromDate:date],subfix];
        
        [formData appendPartWithFileData:obj name:@"file" fileName:filename mimeType:mimeType];
        
      }];
      
    }
    
  } error:nil];
  
  NSURLSessionUploadTask *uploadTask = [self.sessionManager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    
  } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    if (error == nil) {
      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
      [HULogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response resposeString:responseString error:nil];
      dispatch_async(dispatch_get_main_queue(), ^{
        success?success(json, nil):nil;
      });
      
    }else {
      [HULogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response resposeString:responseString error:error];
      dispatch_async(dispatch_get_main_queue(), ^{
        failure?failure(nil, error):nil;
      });
    }
//    NSLog(@"error: %@", error);
  }];
  
  [uploadTask resume];
}

#pragma mark - getters and setters

- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFURLSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForResource = 15;
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
    }
    return _sessionManager;
}

#pragma mark - private

/**
 *  功能 获取文件类型
 *  @param path 文件路径
 *  @return MIMEType
 */
- (NSString*)getMIMEType:(NSString *)path {
  NSString *subfix = [path lastPathComponent];
  NSString *mimeType = [[subfix componentsSeparatedByString:@"."] lastObject];
  if ([mimeType isEqualToString:@"MOV"]) {
    return @"video/quicktime";
  }
  else {
    return @"image/jpeg";
  }
  
  //    NSError *error;
  //    NSURLResponse *response;
  //    NSURL *url = [NSURL fileURLWithPath:path];
  //    if (url == nil) {
  //        return nil;
  //    }
  //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
  //    [NSURLConnection sendSynchronousRequest:request
  //                          returningResponse:&response
  //                                      error:&error];
  //    return [response MIMEType];
}


@end
