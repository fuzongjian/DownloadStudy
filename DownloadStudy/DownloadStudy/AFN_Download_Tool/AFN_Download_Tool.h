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
typedef void(^CompletionState) (BOOL state,NSString * message,NSString * filePath);
@interface AFN_Download_Tool : NSObject
+ (NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString *)url DownloadProgress:(DownloadProgress)progress DownloadCompletion:(CompletionState)completion;
+ (void)pause:(NSURLSessionDownloadTask *)task;
+ (void)start:(NSURLSessionDownloadTask *)task;
@end
