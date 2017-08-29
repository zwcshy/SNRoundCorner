//
//  ViewController.m
//  snRoundCorner
//
//  Created by 周文超 on 2017/8/29.
//  Copyright © 2017年 超超. All rights reserved.
//

#import "ViewController.h"
#import "SNRoundedCell.h"
#import "YYFPSLabel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [UITableView new];
    tableView.rowHeight = 80.f;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = self.view.bounds;
    [tableView registerClass:[SNRoundedCell class] forCellReuseIdentifier:NSStringFromClass([SNRoundedCell class])];
    [self.view addSubview:tableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YYFPSLabel sn_addFPSLableOnWidnow];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SNRoundedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SNRoundedCell class])];
    [cell reloadDataWithUrl:[NSString stringWithFormat:@"https://oepjvpu5g.qnssl.com/avatar%@.jpg", @(indexPath.row % 20)]
                       name:[NSString stringWithFormat:@"挡不住的洋葱蘑菇头%@", @(indexPath.row)]];
    return cell;
    
}


@end
