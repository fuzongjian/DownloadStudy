//
//  SpecialDownload.m
//  DownloadStudy
//
//  Created by 陈舒澳 on 16/4/13.
//  Copyright © 2016年 xingbida. All rights reserved.
//
#define DOWNPATH @"http://wind4app-bdys.oss-cn-hangzhou.aliyuncs.com/CMD_MarkDown.zip"
#import "SpecialDownload.h"
@interface SpecialDownload ()<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong) NSURLSession *session;
@end
@implementation SpecialDownload
-(void)viewDidLoad{
    
}
-(NSURLSession *)session{
    
    if (!_session) {
        //获取session
        NSURLSessionConfiguration * cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
#pragma mark --  NSURLSessionDownloadDelegate
/**
 *  下载完毕后调用
 *
 *  @param location     临时文件的路径（下载好的文件）
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // location : 临时文件的路径（下载好的文件）
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
    
    NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    // 将临时文件剪切或者复制Caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    [mgr moveItemAtPath:location.path toPath:file error:nil];
}
/**
 *  恢复下载时调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
/**
 *  每当下载完（写完）一部分时就会调用（可能会被调用多次）
 *
 *  @param bytesWritten              这次调用写了多少
 *  @param totalBytesWritten         累计写了多少长度到沙盒中了
 *  @param totalBytesExpectedToWrite 文件的总长度
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
    self.progressView.progress = progress;
}

- (IBAction)downloadClicked:(id)sender {
    NSURL * url = [NSURL URLWithString:DOWNPATH];
    self.task = [self.session downloadTaskWithURL:url];
    [self.task resume];
}
- (IBAction)pauseClicked:(id)sender {
    
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        _resumeData = resumeData;
        _task = nil;
    }];
    
}
- (IBAction)continueClicked:(id)sender{
    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.task resume];
    self.resumeData = nil;
}
/**
 *  看不到下载进度
 */
-(void)downLoadTask{
    
    //1.得到session对象
    NSURLSession * session = [NSURLSession sharedSession];
    //2.创建一个下载
    NSURL * url = [NSURL URLWithString:DOWNPATH];
    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // location : 临时文件的路径（下载好的文件）
        
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
        NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"%@",file);
        // 将临时文件剪切或者复制Caches文件夹
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // AtPath : 剪切前的文件路径
        // ToPath : 剪切后的文件路径
        [mgr moveItemAtPath:location.path toPath:file error:nil];
    }];
    //3.开始任务
    [task resume];
    
}

@end
