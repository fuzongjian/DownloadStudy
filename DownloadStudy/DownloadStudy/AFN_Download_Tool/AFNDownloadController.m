//
//  AFNDownloadController.m
//  DownloadStudy
//
//  Created by 陈舒澳 on 16/4/19.
//  Copyright © 2016年 xingbida. All rights reserved.
//
#import "AFNDownloadController.h"
#import "AFN_Download_Tool.h"
@interface AFNDownloadController ()

@property (strong, nonatomic) IBOutlet UIView *downloadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic,strong) NSURLSessionDownloadTask * task;
@end

@implementation AFNDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
//    http://www.baidu.com/img/bdlogo.png
//    http://wind4app-bdys.oss-cn-hangzhou.aliyuncs.com/CMD_MarkDown.zip
    NSString * path = @"http://wind4app-bdys.oss-cn-hangzhou.aliyuncs.com/CMD_MarkDown.zip";
    
    NSURLSessionDownloadTask * task =[AFN_Download_Tool downloadFileWithUrl:path DownloadProgress:^(CGFloat progress, CGFloat total, CGFloat current) {
        //  下载的线程重新开辟（非主线程）
            NSLog(@"当前线程---%@",[NSThread currentThread]);
        
        //  回到主线程更新进度条
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progress.progress = progress;
        });
        
    }DownloadCompletion:^(BOOL state, NSString *message, NSString *filePath) {
         NSLog(@"%@",message);
    }];
    _task = task;
   
}

- (IBAction)startDownload:(id)sender {
    [AFN_Download_Tool start:_task];
}

- (IBAction)pauseDownload:(id)sender {
    [AFN_Download_Tool pause:_task];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
