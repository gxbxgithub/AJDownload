//
//  TaskViewController.h
//  AJDownload
//
//  Created by Guoxb on 16/8/19.
//  Copyright © 2016年 guoxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *downloadListArray;
+ (TaskViewController *)sharedTaskViewController;

@end
