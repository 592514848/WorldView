//
//  SettingViewController.m
//  WorldView
//
//  Created by WorldView on 15/11/18.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define CELL_HEIGHT 45.0F
#import "SettingViewController.h"
@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
}

- (void)loadMainView
{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [mainTableView setDelegate: self];
    [mainTableView setDataSource: self];
    [self.view addSubview: mainTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell"];
    }
    [cell.textLabel setText: @"注销"];
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"" message: @"确定注销当前账号?" delegate: self cancelButtonTitle: @"取消" otherButtonTitles: @"确定", nil];
    [alertView show];
//    [applicationClass methodOfShowAlert: @"注销成功"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [applicationClass methodOfRemoveFromLocal: @"LOCALUSER"];
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
