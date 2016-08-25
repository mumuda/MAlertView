//
//  ViewController.m
//  MAlertView
//
//  Created by ldj on 16/8/1.
//  Copyright © 2016年 ldj. All rights reserved.
//

#import "ViewController.h"
#import "MAlertView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"弹出框相关";
    _dataArray = @[@"中间提示框，不带事件",@"中间提示框，带事件",@"下方文字弹出框",@"下方图文弹出框小于一排",@"下方图文弹出框大于一排",@"中间密码弹出框"];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:rid];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            [self showMiddleAlert];
        }
            break;
            
        case 1:
        {
            [self showMiddleAlertWithAction];
        }
            break;
            
        case 2:
        {
            [self showDownAlertWithContext];
        }
            break;
            
        case 3:
        {
            [self showDownAlertWithPicture];
        }
            break;
            
        case 4:
        {
            
        }
            break;
            
        case 5:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)showMiddleAlert
{
    MAlertView *alert = [[MAlertView alloc] initWithTitle:@"提示"
                                                  message:@"中间提示框，不带事件"
                                              cancelTitle:@"取消"
                                              cancelImage:nil
                                                 withType:MAlertViewStyleMiddle];
    [alert setOnCancelBtn:^{
        NSLog(@"我取消了哈");
    }];
    [alert show];
}

- (void)showMiddleAlertWithAction
{
    MAlertView *alert = [[MAlertView alloc] initWithTitle:@"提示"
                                                  message:@"中间提示框，带事件"
                                              cancelTitle:@"取消"
                                              cancelImage:nil
                                                 withType:MAlertViewStyleMiddle];
    alert.actionTitle = @"就不取消";
    [alert setOnClickBtn:^(NSInteger index) {
        NSLog(@"点击事件");
    }];
    [alert setOnCancelBtn:^{
        NSLog(@"我取消了哈");
    }];
    [alert show];
}

- (void)showDownAlertWithContext
{
    MAlertView *alert = [[MAlertView alloc] initWithTitle:@"提示"
                                                  message:@"下方文字弹出框"
                                              cancelTitle:nil
                                              cancelImage:@"cancel"
                                                 withType:MAlertViewStyleDefault];
    alert.titleArray = @[@"事件0",@"事件1",@"事件2"];
    [alert setOnClickBtn:^(NSInteger index) {
        NSLog(@"点击事件%ld",index);
    }];
    [alert setOnCancelBtn:^{
        NSLog(@"我取消了哈");
    }];
    [alert show];
}

- (void)showDownAlertWithPicture
{
    MAlertView *alert = [[MAlertView alloc] initWithTitle:@"提示"
                                                  message:@"下方文字弹出框"
                                              cancelTitle:nil
                                              cancelImage:@"cancel"
                                                 withType:MAlertViewStyleDefault];
    alert.titleImageArray = @[@"事件0",@"事件1",@"事件2"];
    [alert setOnClickBtn:^(NSInteger index) {
        NSLog(@"点击事件%ld",index);
    }];
    [alert setOnCancelBtn:^{
        NSLog(@"我取消了哈");
    }];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
