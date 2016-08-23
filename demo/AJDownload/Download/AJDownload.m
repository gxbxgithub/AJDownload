//
//  AJDownload.m
//  AJDownload
//
//  Created by Guoxb on 16/8/18.
//  Copyright © 2016年 guoxb. All rights reserved.
//

#import "AJDownload.h"

@interface AJDownload ()<NSURLSessionDownloadDelegate>
{
    NSURL *_downloadUrl;
}

@end

@implementation AJDownload

#pragma mark - private

-(instancetype)initWithUrl:(NSString *)url{
    if (self = [super init]) {
        _downloadUrl = [NSURL URLWithString:url];
    }
    return self;
}

#pragma mark - public

/*
 * 开始
 */
-(void)start{
    self.task = [self.session downloadTaskWithURL:_downloadUrl];
    [self.task resume];
    _downloadState = DownloadStateLoading;
}

/*
 * 恢复
 */
-(void)resume{
    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
    //开始任务
    [self.task resume];
    self.resumeData = nil;
    _downloadState = DownloadStateLoading;
}

/*
 * 暂停
 */
-(void)pause{
    /*
     * block
     */
    __weak typeof(self) weakSelf = self;
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        weakSelf.resumeData = resumeData;
        weakSelf.task = nil;
        _downloadState = DownloadStatePause;
    }];
}

#pragma mark - NSURLSessionDownloadDelegate

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    caches = [caches stringByAppendingPathComponent:@"download"];
    NSFileManager *fmr = [NSFileManager defaultManager];
    if ([fmr createDirectoryAtPath:caches withIntermediateDirectories:YES attributes:nil error:nil]) {
        NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
        [fmr moveItemAtPath:location.path toPath:file error:nil];
        NSLog(@"%@",file);
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
//    NSLog(@"进度---%f",(double)totalBytesWritten / totalBytesExpectedToWrite);
    _progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
    if (self.progessValueBlock) {
        self.progessValueBlock((double)totalBytesWritten / totalBytesExpectedToWrite);
    }
}

-(void)wayOfProgessValueBlock:(ProgessValueBlock)block{
    if (!_progessValueBlock) {
        _progessValueBlock = block;
    }
}

#pragma mark - lazyLoad

-(NSURLSession *)session{
    if (!_session) {
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
