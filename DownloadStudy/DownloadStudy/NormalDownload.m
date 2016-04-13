//
//  NormalDownload.m
//  DownloadStudy
//
//  Created by 陈舒澳 on 16/4/13.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "NormalDownload.h"
#import "DACircularProgressView.h"
#import "CountBytes.h"
#define DOWNPATH @"http://wind4app-bdys.oss-cn-hangzhou.aliyuncs.com/CMD_MarkDown.zip"
@interface NormalDownload ()
@property (weak, nonatomic) IBOutlet UILabel *downloadProgress;
@property (weak, nonatomic) IBOutlet DACircularProgressView *CircleView;
/**
 *  用来写数据的文件句柄对象
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;
/**
 *  文件的总大小
 */
@property (nonatomic, assign) long long totalLength;
/**
 *  当前已经写入的文件大小
 */
@property (nonatomic, assign) long long currentLength;
@property(nonatomic,strong)NSURLConnection * connection;
@property(nonatomic,strong)NSString * path;
@property (nonatomic,strong) NSString * speed;
@property (nonatomic,assign) long long  length;
@end
@implementation NormalDownload
-(void)viewDidLoad{
    _CircleView.progressTintColor = [UIColor redColor];
    _CircleView.trackTintColor = [UIColor blueColor];
    _CircleView.progress = 0.01;
    [self updateProgress];
}
- (void)updateProgress{
    self.downloadProgress.text = [NSString stringWithFormat:@"%@/%@         %@/s",[CountBytes CountBytesBy:(NSInteger)self.currentLength],[CountBytes CountBytesBy:(NSInteger)self.totalLength],[self getSpeed]];
    [self performSelector:@selector(updateProgress) withObject:nil afterDelay:0.5];
}
- (NSString *)getSpeed{
    long long newLength = self.currentLength - self.length;
    self.length = self.currentLength;
    return [CountBytes CountBytesBy:(NSInteger)(newLength * 2)];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if (self.currentLength) return;
    //文件路径
    NSString * caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filepath = [caches stringByAppendingPathComponent:@"file.zip"];
    NSLog(@"%@",filepath);
    _path = filepath;
    //创建一个空的文件到沙河中
    NSFileManager * mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:filepath contents:nil attributes:nil];
    
    //创建一个用来写数据的文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
    
    //获取文件的大小
    self.totalLength = response.expectedContentLength;
    NSLog(@"--%lld",self.totalLength);
    //    68186536
}
/**
 *  2.当接收到服务器返回的实体数据时调用（具体内容，这个方法可能会被调用多次）
 *
 *  @param data       这次返回的数据
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //移动到文件的最后面
    [self.writeHandle seekToEndOfFile];
    //将数据写入到沙河
    [self.writeHandle writeData:data];
    //     NSLog(@"%@",data);
    //累计文件的长度
    self.currentLength += data.length;
    self.speed = [CountBytes CountBytesBy:data.length];
    self.CircleView.progress = (double)self.currentLength/ self.totalLength;
}
/**
 *  3.加载完毕后调用（服务器的数据已经完全返回后）
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
}
- (IBAction)downloadClicked:(id)sender {
    //1.请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:DOWNPATH]];
    
    //2.设置请求头
    NSString * range = [NSString stringWithFormat:@"bytes=%lld-",self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    //3.下载（创建完connection对象后，会自动发起一个异步请求）
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];

}
//此处暂停之后 再次下载需要重新下载
- (IBAction)pauseClicked:(id)sender {
    
    [_connection cancel];
    _connection = nil;
}
- (IBAction)deleteClicked:(id)sender {
    if ([[NSFileManager defaultManager] removeItemAtPath:_path error:nil]) {
        NSLog(@"删除成功");
        _CircleView.progress = 0.01;
        self.currentLength = 0;
        self.totalLength = 0;
    }else{
        NSLog(@"删除失败");
    }
}

@end
