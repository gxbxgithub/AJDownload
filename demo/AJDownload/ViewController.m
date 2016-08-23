//
//  ViewController.m
//  AJDownload
//
//  Created by Guoxb on 16/8/18.
//  Copyright © 2016年 guoxb. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "TaskViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *tasksArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg",
                       @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                       @"http://baobab.wdjcdn.com/14525705791193.mp4",
                       @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                       @"http://baobab.wdjcdn.com/1455968234865481297704.mp4"];
    [self.tasksArray addObjectsFromArray:array];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下载列表" style:UIBarButtonItemStylePlain target:self action:@selector(gotoList)];
    [self.navigationItem setRightBarButtonItem:item];
}

#pragma mark - private

-(void)gotoList{
    [self gotoTaskList:nil];
}

-(void)gotoTaskList:(NSString *)url{
    [self.myTableView reloadData];
    TaskViewController *taskViewController = [TaskViewController sharedTaskViewController];
    if (url) {
        [taskViewController.downloadListArray addObject:url];
    }
    [self.navigationController pushViewController:taskViewController animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tasksArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"listCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil] firstObject];
    }
    /*
     * block
     */
    __weak typeof(self) weakSelf = self;
    [cell wayOfDownloadBlock:^{
        NSString *url = weakSelf.tasksArray[indexPath.row];
        [weakSelf.tasksArray removeObjectAtIndex:indexPath.row];
        [weakSelf gotoTaskList:url];
    }];
    cell.lb_fileName.text = self.tasksArray[indexPath.row];
    return cell;
}

#pragma mark - lazyLoad

-(NSMutableArray *)tasksArray{
    if (!_tasksArray) {
        _tasksArray = [NSMutableArray array];
    }
    return _tasksArray;
}

@end
