//
//  AJDownload.h
//  AJDownload
//
//  Created by Guoxb on 16/8/18.
//  Copyright © 2016年 guoxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^ProgessValueBlock)(CGFloat progress);

typedef enum : NSUInteger {
    DownloadStateNormal,
    DownloadStateLoading,
    DownloadStatePause,
} DownloadState;

@interface AJDownload : NSObject

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) DownloadState downloadState;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy) ProgessValueBlock progessValueBlock;
-(instancetype)initWithUrl:(NSString *)url;//初始化
-(void)start;
-(void)resume;
-(void)pause;

-(void)wayOfProgessValueBlock:(ProgessValueBlock)block;

@end
