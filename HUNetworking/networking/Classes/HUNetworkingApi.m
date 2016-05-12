//
//  HUNetworkingApi.m
//  SportTimer
//
//  Created by mac on 15/12/26.
//  Copyright © 2015年 jinhuadiqigan. All rights reserved.
//

#import "HUNetworkingApi.h"
#import "AFNetworking/AFNetworking.h"

NSString  *kHUNetworkReachabilityStatusNotification = @"kHUNetworkReachabilityStatusNotification";

@interface HUNetworkingApi () {

    
}

@property (nonatomic,assign) BOOL newWorkReachable;
@property (nonatomic, strong) AFHTTPSessionManager *httpSession;


@end

@implementation HUNetworkingApi

+ (instancetype)sharedNetworking {
    static HUNetworkingApi *networkingApi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkingApi = [[HUNetworkingApi alloc] init];
    });
    return networkingApi;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;

    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.requestSerializer.timeoutInterval = 10.0f;
    httpSession.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript", nil];
    _httpSession = httpSession;
    
    _basicURL = @"";
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return self;
}

+ (void)cancel {
    [[HUNetworkingApi sharedNetworking].httpSession.tasks makeObjectsPerformSelector:@selector(cancel)];
   // [[HUNetworkingApi sharedNetworking].httpSession invalidateSessionCancelingTasks:NO];
}

- (BOOL)isNetWorkReachable {
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return NO;
    }
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
    
}


+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(SuccessBlock)success
    failure:(FailureBlock)failure {
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[HUNetworkingApi sharedNetworking].basicURL, URLString];
    
    [[HUNetworkingApi sharedNetworking].httpSession GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
       // NSString *errorMsg = [self errorMsgFromeErrorMsg:error.userInfo[NSLocalizedDescriptionKey]];
        failure(task, error);
    }];
    
}

+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(SuccessBlock)success
     failure:(FailureBlock)failure {
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@%@",[HUNetworkingApi sharedNetworking].basicURL, URLString];
    [[HUNetworkingApi sharedNetworking].httpSession POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
         //NSString *errorMsg = [self errorMsgFromeErrorMsg:error.userInfo[NSLocalizedDescriptionKey]];
         failure(task, error);
    }];
}

+ (void)uploadWithPOST:(NSString *)url
            parameters:(id)parameters
                  data:(NSData *)data
                  filePath:(NSString *)filePath
              finished:(SuccessBlock)finished
                 error:(FailureBlock)errorBlock {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[HUNetworkingApi sharedNetworking].basicURL, url];
    
    [[HUNetworkingApi sharedNetworking].httpSession POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:[NSString stringWithFormat:@"yyMMddHHmmss"]];
        
        NSString *subfix = [filePath lastPathComponent];
        NSString *mimeType = [self getMIMEType:filePath];
        
        NSString *filename = [NSString stringWithFormat:@"%@%@", [formatter stringFromDate:date],subfix];
        [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:mimeType];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        finished(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
       // NSString *errorMsg = [self errorMsgFromeErrorMsg:error.userInfo[NSLocalizedDescriptionKey]];
        errorBlock(task, error);
    }];

}

+ (void)uploadWithPOST:(NSString *)url parameters:(id)parameters data:(NSData *)data finished:(void (^)(id))finished error:(void (^)(NSError *))errorBlock{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[HUNetworkingApi sharedNetworking].basicURL, url];
    
    [[HUNetworkingApi sharedNetworking].httpSession POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:[NSString stringWithFormat:@"yyMMddHHmmss"]];
        
        NSString *filename = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:date]];
        [formData appendPartWithFileData:data name:@"image" fileName:filename mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
       finished(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorBlock(error);
    }];
}

+ (void)uploadWithPOST:(NSString *)URLString
            parameters:(id)parameters
                 datas:(NSArray *)datas
              fileName:(NSArray *)fileName
               success:(SuccessBlock)success
               failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",[HUNetworkingApi sharedNetworking].basicURL, URLString];
    
    [[HUNetworkingApi sharedNetworking].httpSession POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [datas enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
            
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:[NSString stringWithFormat:@"yyMMddHHmmss"]];
            
            NSString *filename = [NSString stringWithFormat:@"%@%zd.png", [formatter stringFromDate:date],idx];
            [formData appendPartWithFileData:data name:@"image" fileName:filename mimeType:@"image/png"];
            
        }];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
       // NSString *errorMsg = [self errorMsgFromeErrorMsg:error.userInfo[NSLocalizedDescriptionKey]];
        failure(task, error);
    }];
    
}


/**
 *  功能 获取文件类型
 *  @param path 文件路径
 *  @return MIMEType
 */
+ (NSString*)getMIMEType:(NSString *)path
{
    NSError *error;
    NSURLResponse*response;
    NSURLRequest*request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    return [response MIMEType];
}

@end
