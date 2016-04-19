//
//  AFN_Download_Tool.m
//  DownloadStudy
//
//  Created by 陈舒澳 on 16/4/19.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "AFN_Download_Tool.h"

@implementation AFN_Download_Tool
+ (NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString *)url DownloadProgress:(DownloadProgress)progress DownloadSuccess:(DownloadSuccess)success DownloadFail:(DownloadFail)fail{
    // 1、 设置请求
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    // 2、句柄的初始化
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    // 3、开始下载
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount,1.0 * downloadProgress.totalUnitCount,1.0 * downloadProgress.completedUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //这里要返回一个NSURL，其实就是文件的位置路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //使用建议的路径
        path = [path stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"%@",path);
        return [NSURL fileURLWithPath:path];//转化为文件路径
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //如果下载的是压缩包的话，可以在这里进行解压
    
        //下载完成之后将文件的路径返回去
        success(task,[filePath path]);
        fail(task,error);
    }];
    return task;
}
+ (void)pause:(NSURLSessionDownloadTask *)task{
    [task suspend];
}
+ (void)start:(NSURLSessionDownloadTask *)task{
    [task resume];
}
#pragma mark --- 监控当前网络状态(WiFi状态可以下载)
+ (void)MonitorNetState{
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    /**
     *  AFNetworkReachabilityStatusUnknown   未知状态  -1
     *  AFNetworkReachabilityStatusNotReachable 没有网络 0
     *  AFNetworkReachabilityStatusReachableViaWWAN  3G  1
     *  AFNetworkReachabilityStatusReachableViaWiFi WiFi    2
     *
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

    }];

}
@end
