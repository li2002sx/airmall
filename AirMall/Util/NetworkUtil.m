//
//  NetworkUtil.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/28.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "NetworkUtil.h"

@implementation NetworkUtil

//+ (instancetype)shareNetwork
//{
//    static NetworkUtil *networkUtil = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        networkUtil = [[NetworkUtil alloc] init];
//    });
//    return networkUtil;
//}

/**
 *  get方法
 */
+(void)get:(NSString *)url params:(NSMutableDictionary *)params success:(Success)success fail:(Fail)fail{
    params = [CommonUtil createCommonArgs: params];
    AFHTTPSessionManager *manager = [self managerWithBaseURL:@_ApiUrl sessionConfiguration:NO];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dic = [self responseConfiguration:responseObject];
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

/**
 *  post方法
 */
+(void)post:(NSString *)url params:(NSMutableDictionary *)params success:(Success)success fail:(Fail)fail{
    params = [CommonUtil createCommonArgs: params];
    AFHTTPSessionManager *manager = [self managerWithBaseURL:@_ApiUrl sessionConfiguration:NO];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id dic = [self responseConfiguration:responseObject];
        id dic = responseObject;
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

/**
 *  上传文件
 */
+(void)upload:(NSString *)url params:(NSMutableDictionary *)params fileData:(NSData *)filedata
         name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *) mimeType
     progress:(Progress)progress success:(Success)success fail:(Fail)fail{
    params = [CommonUtil createCommonArgs: params];
    AFHTTPSessionManager *manager = [self managerWithBaseURL:@_ApiUrl sessionConfiguration:NO];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
            [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id dic = [NetworkUtil responseConfiguration:responseObject];
        id dic = responseObject;
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

/**
 *  下载文件
 */
+(NSURLSessionDownloadTask *)down:(NSString *)url saveUrl:(NSURL *)fileUrl
                         progress:(Progress )progress success:(void (^)(NSURLResponse *, NSURL *))success
                             fail:(void (^)(NSError *))fail{
    AFHTTPSessionManager *manager = [self managerWithBaseURL:@_ApiUrl sessionConfiguration:YES];
    
    NSURL *urlpath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [fileUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            fail(error);
        }else{
            success(response,filePath);
        }
    }];
    [downloadtask resume];
    return downloadtask;
}

#pragma mark - Private

+(AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL sessionConfiguration:(BOOL)isConfiguration{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =nil;
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    if (isConfiguration) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return manager;
}

+(NSDictionary*)responseConfiguration:(id)responseObject{
    
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

@end
