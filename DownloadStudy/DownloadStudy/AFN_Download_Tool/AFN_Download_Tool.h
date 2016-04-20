//
//  AFN_Download_Tool.h
//  DownloadStudy
//
//  Created by 陈舒澳 on 16/4/19.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^DownloadProgress) (CGFloat progress,CGFloat total,CGFloat current);
typedef void(^DownloadSuccess) (NSURLSessionDownloadTask * task,NSString * path);
typedef void(^CompletionState) (BOOL state,NSString * message);
typedef void(^DownloadFail) (NSURLSessionDownloadTask * task,NSError * error);
@interface AFN_Download_Tool : NSObject
+ (NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString *)url DownloadProgress:(DownloadProgress)progress DownloadSuccess:(DownloadSuccess)success DownloadFail:(DownloadFail)fail;
+ (void)pause:(NSURLSessionDownloadTask *)task;
+ (void)start:(NSURLSessionDownloadTask *)task;
@end
