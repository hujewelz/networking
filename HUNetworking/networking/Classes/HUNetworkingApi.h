//
//  HUNetworkingApi.h
//  SportTimer
//
//  Created by mac on 15/12/26.
//  Copyright © 2015年 jinhuadiqigan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

extern NSString const * kHUNetworkReachabilityStatusNotification;

typedef NS_ENUM(NSInteger, HUUploadMediaType) {
    HUUploadMediaTypeImage,
    HUUploadMediaTypeVideo,
    HUUploadMediaTypeAudio
};

@interface HUNetworkingApi : NSObject

@property (nonatomic, strong) NSString *basicURL;

+ (instancetype)sharedNetworking;

+ (void)cancel;

+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(SuccessBlock)success
    failure:(FailureBlock)failure;

+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(SuccessBlock)success
     failure:(FailureBlock)failure;

/*！
 上媒体文件
 @param url 请求地址
 @param parameters 请求参数
 @param filePath 媒体文件路径
 @param data 图片
 
 */
+ (void)uploadWithPOST:(NSString *)url
            parameters:(id)parameters
                  data:(NSData *)data
                  filePath:(NSString *)filePath
              finished:(SuccessBlock)finished
                 error:(FailureBlock)errorBlock;

/*！
 上传单张图片
 @param url 请求地址
 @param parameters 请求参数
 @param data 图片
 
 */
+ (void)uploadWithPOST:(NSString *)url
            parameters:(id)parameters
                  data:(NSData *)data
              finished:(void (^)(id))finished
                 error:(void (^)(NSError *))errorBlock;

+ (void)uploadWithPOST:(NSString *)URLString
            parameters:(id)parameters
                 datas:(NSArray *)datas
              fileName:(NSArray *)fileName
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;


@property (nonatomic, readonly,assign, getter=isNetWorkReachable) BOOL netWorkReachable;

@end
