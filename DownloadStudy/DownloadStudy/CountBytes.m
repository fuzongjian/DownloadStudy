//
//  CountBytes.m
//  testDownBigFile
//
//  Created by 陈舒澳 on 16/4/13.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "CountBytes.h"

@implementation CountBytes
+ (NSString *)CountBytesBy:(NSInteger)bytes{
    NSString * bytesStr = nil;
    if (!(bytes / 1024)) {
        bytesStr = [NSString stringWithFormat:@"%dB",bytes];//B
    }else if (!(bytes / 1024 / 1024)){
        bytesStr = [NSString stringWithFormat:@"%.2fkb",(float)bytes / 1024 ];
    }else{
        bytesStr = [NSString stringWithFormat:@"%.2fM",(float) bytes / 1024 / 1024];
    }
    return  bytesStr;
}
@end
