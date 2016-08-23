//
//  CustomTableViewCell.h
//  AJDownload
//
//  Created by Guoxb on 16/8/19.
//  Copyright © 2016年 guoxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJDownload.h"

typedef void (^DownloadBlock)();
typedef void (^FinishDownloadBlock)();

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_fileName;
@property (nonatomic, copy) DownloadBlock downloadBlock;

@property (weak, nonatomic) IBOutlet UILabel *finish_title;
@property (weak, nonatomic) IBOutlet UILabel *finish_size;

@property (weak, nonatomic) IBOutlet UILabel *down_title;
@property (weak, nonatomic) IBOutlet UIProgressView *down_progress;
@property (weak, nonatomic) IBOutlet UILabel *down_speed;
@property (weak, nonatomic) IBOutlet UIButton *down_button;
@property (nonatomic, strong) AJDownload *download;
@property (nonatomic, copy) FinishDownloadBlock finishDownloadBlock;


-(void)wayOfDownloadBlock:(DownloadBlock)block;
-(void)wayOfFinishDownloadBlock:(FinishDownloadBlock)block;

@end
