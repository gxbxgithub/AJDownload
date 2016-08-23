//
//  TaskViewController.m
//  AJDownload
//
//  Created by Guoxb on 16/8/19.
//  Copyright © 2016年 guoxb. All rights reserved.
//

#import "TaskViewController.h"
#import "CustomTableViewCell.h"
#import "AJDownload.h"

@interface TaskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *localTaskArray;
@property (nonatomic, strong) NSMutableDictionary *downLoadDict;

@end

@implementation TaskViewController

+ (TaskViewController *)sharedTaskViewController
{
    static TaskViewController *sharedTaskViewControllerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTaskViewControllerInstance = [[self alloc] init];
    });
    return sharedTaskViewControllerInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取本地文件
    [self achieveLocalFiles];
    [self.view addSubview:self.myTableView];
}

-(void)achieveLocalFiles{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"download"];
    NSArray *fileNameArray = [manager contentsOfDirectoryAtPath:cachePath error:nil];
    [self.localTaskArray removeAllObjects];
    if (fileNameArray) {
        for (NSString *fileName in fileNameArray) {
            NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
            NSMutableDictionary *fileAttributes = [NSMutableDictionary dictionaryWithDictionary:[manager attributesOfItemAtPath:filePath error:nil]];
            [fileAttributes setObject:fileName forKey:@"NSFileName"];
            [self.localTaskArray addObject:fileAttributes];
        }
    }
    [self.myTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self achieveLocalFiles];
    for (NSString *url in self.downloadListArray) {
        if (![self.downLoadDict.allKeys containsObject:[[url componentsSeparatedByString:@"/"] lastObject]]) {
            AJDownload *download = [[AJDownload alloc] initWithUrl:url];
            [self.downLoadDict setValue:download forKey:[[url componentsSeparatedByString:@"/"] lastObject]];
            [self.myTableView reloadData];
        }
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 64 : 71;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? self.localTaskArray.count : self.downloadListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier_finish = @"cellFinish";
    static NSString *identifier_down = @"cellDown";
    CustomTableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier_finish];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil] objectAtIndex:1];
        }
        NSDictionary *dict = self.localTaskArray[indexPath.row];
        cell.finish_title.text = dict[@"NSFileName"];
        NSNumber *fileSize = dict[@"NSFileSize"];
        unsigned long long size = fileSize.unsignedLongLongValue;
        cell.finish_size.text = [NSString stringWithFormat:@"%.2fMb",size * 1.0 / 1024 / 1024];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:identifier_down];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil] objectAtIndex:2];
        }
        NSString *url = self.downloadListArray[indexPath.row];
        NSString *key = [[url componentsSeparatedByString:@"/"] lastObject];
        /*
         * block
         */
        __weak typeof(self) weakSelf = self;
        [cell wayOfFinishDownloadBlock:^{
            [weakSelf.downloadListArray removeObjectAtIndex:indexPath.row];
            [weakSelf.downLoadDict removeObjectForKey:key];
            [weakSelf achieveLocalFiles];
        }];
        cell.down_title.text = url;
        AJDownload *download = self.downLoadDict[key];
        cell.download = download;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    label.text = section == 0 ? @"已完成" : @"正在下载";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    [vv addSubview:label];
    return vv;
}

#pragma mark - lazyLoad

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}

-(NSMutableArray *)downloadListArray{
    if (!_downloadListArray) {
        _downloadListArray = [NSMutableArray array];
    }
    return _downloadListArray;
}

-(NSMutableArray *)localTaskArray{
    if (!_localTaskArray) {
        _localTaskArray = [NSMutableArray array];
    }
    return _localTaskArray;
}

-(NSMutableDictionary *)downLoadDict{
    if (!_downLoadDict) {
        _downLoadDict = [NSMutableDictionary dictionary];
    }
    return _downLoadDict;
}

@end
