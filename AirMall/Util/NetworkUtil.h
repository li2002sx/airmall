//
//  NetworkUtil.h
//  AirMall
//
//  Created by 李胜喜 on 2018/2/28.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

/**
 *  宏定义请求成功的block
 *  @param response 请求成功返回的数据
 */
typedef void (^Success)(NSURLSessionDataTask *task,id response);

/**
 *  宏定义请求失败的block
 *  @param error 报错信息
 */
typedef void (^Fail)(NSURLSessionDataTask *task, NSError *error);

/**
 *  上传或者下载的进度
 *  @param progress 进度
 */
typedef void (^Progress)(NSProgress *progress);

@interface NetworkUtil : NSObject

//+ (instancetype)shareNetwork;

/**
 *  get方法
 */
+(void)get:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Fail)fail;

/**
 *  post方法
 */
+(void)post:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Fail)fail;

/**
 *  上传文件
 */
+(void)upload:(NSString *)url params:(NSDictionary *)params fileData:(NSData *)filedata
         name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *) mimeType
     progress:(Progress)progress success:(Success)success fail:(Fail)fail;

/**
 *  下载文件
 */
+(NSURLSessionDownloadTask *)down:(NSString *)url saveUrl:(NSURL *)fileUrl
                         progress:(Progress )progress success:(void (^)(NSURLResponse *, NSURL *))success
                             fail:(void (^)(NSError *))fail;
@end
