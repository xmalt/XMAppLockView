//
//  ViewController.m
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import "ViewController.h"
#import "PatternViewController.h"
#import "KeyboardViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

/* 主视图 */
@property(nonatomic, strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    self.navigationItem.title = @"XMAppLock";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"手势解锁";
    }else {
        cell.textLabel.text = @"密码解锁";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PatternViewController *vc = [[PatternViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        KeyboardViewController *vc = [[KeyboardViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
