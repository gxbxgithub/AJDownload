//
//  CustomTableViewCell.m
//  AJDownload
//
//  Created by Guoxb on 16/8/19.
//  Copyright © 2016年 guoxb. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)download:(UIButton *)sender {
    self.downloadBlock();
}
- (IBAction)stop:(id)sender {
    if (_download.downloadState == DownloadStateLoading) {
        [_download pause];
    }else{
        [_download resume];
    }
}

-(void)setDownload:(AJDownload *)download{
    _download = download;
    if (_download.downloadState == DownloadStateNormal) {
        [_download start];
    }
    [_down_progress setProgress:_download.progress];
    /*
     * block
     */
    __weak typeof(self) weakSelf = self;
    [_download wayOfProgessValueBlock:^(CGFloat progress) {
        [weakSelf.down_progress setProgress:progress];
        weakSelf.down_speed.text = [NSString stringWithFormat:@"%f",progress];
        if (progress == 1) {
            if (weakSelf.finishDownloadBlock) {
                weakSelf.finishDownloadBlock();
            }
        }
    }];
}

-(void)wayOfDownloadBlock:(DownloadBlock)block{
    if (!_downloadBlock) {
        _downloadBlock = block;
    }
}

-(void)wayOfFinishDownloadBlock:(FinishDownloadBlock)block{
    if (!_finishDownloadBlock) {
        _finishDownloadBlock = block;
    }
}

@end
