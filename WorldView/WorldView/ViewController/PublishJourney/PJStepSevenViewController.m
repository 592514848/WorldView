//
//  PJStepSevenViewController.m
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define STEP_IMAGEVIEW_HEIGHT 15.0F
#define BUTTON_HEIGHT 20.0F
#define BUTTON_WIDTH 100.0F
#define HEADER_HEIGHT 50.0F
#define CELL_HEIGHT 30.0F
#import "PJStepSevenViewController.h"

@implementation PJStepSevenViewController
@synthesize mainService;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"发布旅程"];
    ////
    timeArray = [[NSMutableArray alloc] init];
    ////
    [self loadMainView];
}

- (void)loadMainView
{
    ///1.主视图
    CGFloat origin_y = STEP_IMAGEVIEW_HEIGHT + 20.0f;
    mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, curScreenSize.height - origin_y - 4 * BUTTON_HEIGHT)];
    [mainTableView setDelegate: self];
    [mainTableView setDataSource: self];
    [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [self.view addSubview: mainTableView];
    ///footerView
    UIView *footerView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, BUTTON_HEIGHT)];
    [footerView setBackgroundColor: [UIColor clearColor]];
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame: CGRectMake((curScreenSize.width - BUTTON_HEIGHT) / 2.0f, 0.0f, BUTTON_HEIGHT, BUTTON_HEIGHT)];
    [addImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"add_location" ofType: @"png"]]];
    [addImageView setContentMode: UIViewContentModeScaleAspectFit];
    [addImageView setUserInteractionEnabled: YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(addTimeImageClick)];
    [addImageView addGestureRecognizer: tap];
    [footerView addSubview: addImageView];
    [mainTableView setTableFooterView: footerView];
    
    ///2.完成按钮
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame: CGRectMake((curScreenSize.width - BUTTON_WIDTH) / 2.0f, curScreenSize.height - BUTTON_HEIGHT * 3.0f, BUTTON_WIDTH, 2 * BUTTON_HEIGHT)];
    [nextStepButton setBackgroundColor: [UIColor whiteColor]];
    [nextStepButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"] forState: UIControlStateNormal];
    [nextStepButton setTitle: @"完成" forState: UIControlStateNormal];
    [nextStepButton.layer setCornerRadius: 3.0f];
    [nextStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [nextStepButton.layer setBorderWidth: 0.5f];
    [nextStepButton.layer setBorderColor:[applicationClass methodOfTurnToUIColor: @"#ef5052"].CGColor];
    [nextStepButton addTarget:self action: @selector(compeleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: nextStepButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    if(!cell){
        cell = [[TravelTimeTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
        [cell setXDelegate: self];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *curDate = [formatter dateFromString: [timeArray objectAtIndex: [indexPath row]]];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    [cell.dateLabel setText: [formatter stringFromDate: curDate]];
    [formatter setDateFormat: @"HH:mm:ss"];
    [cell.timeLabel setText: [formatter stringFromDate: curDate]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor: [UIColor whiteColor]];
    ///
    CGFloat size_w = [tableView frame].size.width / 3.0f;
    for(NSInteger i = 0; i < 3; i++){
        XZJ_CustomLabel *tmpLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(size_w * i, 0.0f, size_w, HEADER_HEIGHT)];
        [tmpLabel setTextAlignment: NSTextAlignmentCenter];
        [tmpLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        switch (i) {
            case 0:
                [tmpLabel setText: @"日期"];
                break;
            case 1:
                [tmpLabel setText: @"时间"];
                break;
            case 2:
                [tmpLabel setText: @"操作"];
                break;
            default:
                break;
        }
        [view addSubview: tmpLabel];
    }
    return view;
}

#pragma mark -
#pragma mark 打开时间选择器
- (void)addTimeImageClick
{
    [self XZJ_CustomPicker_CancelClick: 0];
    if(!mainDatePicker)
    {
        mainDatePicker = [[XZJ_CustomPicker alloc] initDatePickerWithFrame: CGRectMake(0.0f, curScreenSize.height, curScreenSize.width, curScreenSize.height/2.0f)];
        [mainDatePicker setDelegate: self];
        [mainDatePicker setDatePickerMode: UIDatePickerModeDateAndTime];
        [mainDatePicker setMinimumDate:[NSDate date]];
        [self.view addSubview: mainDatePicker];
    }
    [mainDatePicker setHidden: NO];
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, curScreenSize.height - curScreenSize.height/2.0f, curScreenSize.width, curScreenSize.height/2.0f));
    [applicationClass methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainDatePicker, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

#pragma mark -
#pragma mark CustomPicker委托
- (void)XZJ_CustomPicker_CancelClick:(NSInteger)tag
{
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, curScreenSize.height, curScreenSize.width, curScreenSize.height/2.0f));
    [applicationClass methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainDatePicker, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

- (void)XZJ_CustomPicker_EnsureClick:(NSInteger)tag date:(NSDate *)date
{
    [self XZJ_CustomPicker_CancelClick: tag];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [timeArray addObject:[formatter stringFromDate: date]];
    [mainTableView reloadData];
}

#pragma mark -
#pragma mark travelTimeTableViewCell委托
- (void)travelTimeTableViewCell_DidDeleteButton:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [mainTableView indexPathForCell: cell];
    if([timeArray count] > [indexPath row])
        [timeArray removeObjectAtIndex: [indexPath row]];
    [mainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark 完成按钮
- (void)compeleteButtonClick
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [timeArray componentsJoinedByString: @","] forKey: @"TripOrderDates"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"PublishService" object: nil userInfo: dictionary];
}
@end
