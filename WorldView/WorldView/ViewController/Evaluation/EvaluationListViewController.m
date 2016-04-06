//
//  EvaluationListViewController.m
//  WorldView
//
//  Created by WorldView on 15/11/16.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define CELL_HEIGHT 120.0F
#import "EvaluationListViewController.h"
#import "EvaluationTableViewCell.h"

@implementation EvaluationListViewController
@synthesize serviceId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"评论列表"];
    ///加载评论列表
    evalutionObj = [[EvalutionObject alloc] init];
    [evalutionObj setXDelegate: self];
    [evalutionObj getEvalutionList: serviceId];
}

#pragma mark -
#pragma mark Evalution委托
- (void)evalutionObjectDelegate_GetEvalutionLsit:(NSArray *)dataArray
{
    evalutionArray = dataArray;
    [self loadMainView];
}

- (void)loadMainView
{
    if(!mainTableView){
        mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
        [mainTableView setDelegate: self];
        [mainTableView setDataSource: self];
        UIView *footerView = [[UIView alloc] init];
        [footerView setBackgroundColor: [UIColor clearColor]];
        [mainTableView setTableFooterView: footerView];
        [self.view addSubview: mainTableView];
    }
    else
        [mainTableView reloadData];
    if([evalutionArray count] == 0){
        [applicationClass methodOfShowTipInView: self.view text: @"暂无评论"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [evalutionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[EvaluationTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
    }
    EvaluationClass *evalution = [evalutionArray objectAtIndex: [indexPath row]];
    [cell setPhotoImage: [NSURL URLWithString: [[evalution member] memberPhoto]] sex: [[evalution member] memberSex]];
    [cell.nameLabel setText: [[evalution member] nickName]];
    [cell setStarLevel: [evalution evalutionScore]];
    [cell.contentLabel setText: [evalution evalutionContent]];
    [cell.timeLabel setText: [evalution addTime]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
