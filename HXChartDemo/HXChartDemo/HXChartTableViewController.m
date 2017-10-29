//
//  HXChartTableViewController.m
//  HXChartDemo
//
//  Created by hubery on 2017/10/28.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "HXChartTableViewController.h"

@interface HXChartTableViewController ()
@property(nonatomic,strong) NSArray *dataArray;
@end

@implementation HXChartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HXChartCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXChartCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataArray[indexPath.row] objectForKey:@"type"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [[NSClassFromString([self.dataArray[indexPath.row] objectForKey:@"jump"]) alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = @[
                           @{@"type":@"HXLineChart" , @"jump":@"HXLineChartViewController"},
                           @{@"type":@"HXBarChart" , @"jump":@"HXBarChartViewController"},
                           @{@"type":@"HXWaveRateChart" , @"jump":@"HXWaveRateChartViewController"},
                           @{@"type":@"HXPieChart" , @"jump":@"HXPieChartViewController"},
                           @{@"type":@"HXCircleChart" , @"jump":@"HXCircleChartViewController"}
                           ];
    }
    return _dataArray;
}
@end
