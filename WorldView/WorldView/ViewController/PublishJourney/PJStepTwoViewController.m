//
//  PJStepTwoViewController.m
//  WorldView
//
//  Created by XZJ on 11/5/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define STEP_IMAGEVIEW_HEIGHT 15.0F
#define MARGIN_LEFT 15.0F
#define TITLE_LABEL_HEIGHT 40.0F
#define TITLE_VALUE_HEIGHT 40.0F
#define TEXTVIEW_HEIGHT 130.0F
#define BUTTON_HEIGHT 35.0F
#define BUTTON_WIDTH 100.0F
#import "PJStepTwoViewController.h"
#import "PJStepOneViewController.h"
#import "PJStepThreeViewController.h"

@implementation PJStepTwoViewController
@synthesize titleTextField, subTitleTextField, descriptionTextView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"发布旅程"];
    [self loadMainView];
}

- (void)loadMainView
{
    ///2.主滚动视图
    CGFloat origin_y = STEP_IMAGEVIEW_HEIGHT + 20.0f;
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, curScreenSize.height - origin_y)];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [mainScrollView setDelegate: self];
    [self.view addSubview: mainScrollView];
    
    ///3.旅程标题、副标题、旅程简介
    origin_y = 15.0F;
    for(NSInteger i = 0; i < 3; i++)
    {
        ///标题
        XZJ_CustomLabel *tempLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 2 * MARGIN_LEFT, TITLE_LABEL_HEIGHT)];
        [tempLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
        [mainScrollView addSubview: tempLabel];
        ///输入框
        origin_y = tempLabel.frame.size.height + tempLabel.frame.origin.y;
        switch (i) {
            case 2:
            {
                [tempLabel setText: @"旅程简介:"];
                ///输入框
                UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, tempLabel.frame.size.width, TEXTVIEW_HEIGHT)];
                [textView setFont: [UIFont systemFontOfSize: 14.0F]];
                [textView setTextColor: [applicationClass methodOfTurnToUIColor: @"#b2b3b4"]];
                [textView setText: @"请输入旅程简介...."];
                [textView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#b2b3b4"].CGColor];
                [textView.layer setBorderWidth: 0.5f];
                [textView.layer setCornerRadius: 3.0f];
                [textView setDelegate: self];
                [mainScrollView addSubview: textView];
                ///剩余字数
                origin_y += TEXTVIEW_HEIGHT;
                fontNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, textView.frame.size.width, 20.0f)];
                [fontNumberLabel setFont: [UIFont systemFontOfSize: 12.0f]];
                [fontNumberLabel setTextAlignment: NSTextAlignmentRight];
                [fontNumberLabel setText: @"您还可以输入300个字"];
                [fontNumberLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#b5b6b7"]];
                [mainScrollView addSubview: fontNumberLabel];
                origin_y += fontNumberLabel.frame.size.height + 20.0f;
                descriptionTextView = textView;
                break;
            }
            default:
            {
                UITextField *textFiled = [[UITextField alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, tempLabel.frame.size.width, TITLE_VALUE_HEIGHT)];
                [textFiled setFont: [UIFont systemFontOfSize: 14.0f]];
                [textFiled.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#b2b3b4"].CGColor];
                [textFiled.layer setBorderWidth: 0.5f];
                [textFiled.layer setCornerRadius: 3.0f];
                [mainScrollView addSubview: textFiled];
                origin_y = textFiled.frame.size.height + textFiled.frame.origin.y;
                if(i == 0)
                {
                    [tempLabel setText: @"旅程标题:"];
                    titleTextField = textFiled;
                }
                else{
                    [tempLabel setText: @"副标题:"];
                    subTitleTextField = titleTextField;
                }
                [textFiled setDelegate: self];
                [textFiled setReturnKeyType: UIReturnKeyDone];
                break;
            }
        }
    }
    
    ///4.上一步按钮
    CGFloat margin = (curScreenSize.width - 2 * BUTTON_WIDTH) / 3.0f;
    UIButton *lastStepButton = [[UIButton alloc] initWithFrame: CGRectMake(margin, origin_y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [lastStepButton setBackgroundColor: [UIColor whiteColor]];
    [lastStepButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"] forState: UIControlStateNormal];
    [lastStepButton setTitle: @"上一步" forState: UIControlStateNormal];
    [lastStepButton.layer setCornerRadius: 3.0f];
    [lastStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [lastStepButton.layer setBorderWidth: 0.5f];
    [lastStepButton setTag: 0];
    [lastStepButton.layer setBorderColor:[applicationClass methodOfTurnToUIColor: @"#ef5052"].CGColor];
    [lastStepButton addTarget:self action: @selector(stepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview: lastStepButton];
    
    ///5.下一步按钮
    CGFloat origin_x = 2 * margin + BUTTON_WIDTH;
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y , BUTTON_WIDTH, BUTTON_HEIGHT)];
    [nextStepButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [nextStepButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [nextStepButton setTitle: @"下一步" forState: UIControlStateNormal];
    [nextStepButton.layer setCornerRadius: 3.0f];
    [nextStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [nextStepButton setTag: 1];
    [nextStepButton addTarget:self action: @selector(stepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview: nextStepButton];
    
    ///18.调整滚动视图的contentSize
    CGFloat size_h = nextStepButton.frame.size.height + nextStepButton.frame.origin.y + 20.0f;
    size_h = (size_h > curScreenSize.height ? size_h : curScreenSize.height + 20.0f);
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, size_h)];
}

#pragma mark -
#pragma mark textView委托事件
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    curFirstResponder = textView;
    if([[textView text] isEqualToString: @"请输入旅程简介...."]){
        [textView setText: @""];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger fontNumber = [[textView text] length];
    if(fontNumber <= 300){
        [fontNumberLabel setText: [NSString stringWithFormat: @"您还可以输入%ld个字", (long)(300 - fontNumber)]];
        textViewText = [textView text];
    }
    else{
        [textView setText: textViewText];
    }
}

#pragma mark -
#pragma mark textView委托事件
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    curFirstResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [curFirstResponder resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [curFirstResponder resignFirstResponder];
}

#pragma mark -
#pragma mark 步骤按钮点击事件
- (void)stepButtonClick:(UIButton *)sender
{
    switch ([sender tag]) {
        case 0:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: @"PagerViewControllerGoToLast" object: nil];
            break;
        }
        case 1:{
            [[NSNotificationCenter defaultCenter] postNotificationName: @"PagerViewControllerGoToNext" object: nil];
            break;
        }
        default:
            break;
    }
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
