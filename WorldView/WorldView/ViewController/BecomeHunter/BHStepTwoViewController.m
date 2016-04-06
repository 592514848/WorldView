//
//  BHStepTwoViewController.m
//  WorldView
//
//  Created by WorldView on 15/11/30.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define BASE_CELL_HEIGHT 50.0F
#define SECOND_CELL_HEIGHT 70.0F
#define REMARKS_CELL_HEIGHT 180.0F
#define SECTION_HEIGHT 10.0F
#define INPUT_FONT_SIZE 12.0F
#define SELECTED_WIDTH 60.0F
#import "BHStepTwoViewController.h"
#import "BHStepThreeViewController.h"

@implementation BHStepTwoViewController

- (void)viewWillAppear:(BOOL)animated
{
    ///获取用户个人资料
    memberObj = [[MemberObject alloc] init];
    [memberObj setMemberId: [memberDictionary objectForKey: @"id"]];
    [memberObj setXDelegate: self];
    [memberObj getMemberDetails];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"完善个人资料"];
    ////1.获取职业的列表
    memberObj = [[MemberObject alloc] init];
    [memberObj setXDelegate: self];
    [memberObj getProfessionList];
    ///2.获取语言列表
    memberObj = [[MemberObject alloc] init];
    [memberObj setXDelegate: self];
    [memberObj getLanguaList];
    ///3.加载主视图
    [self loadMainView];
}

#pragma mark -
#pragma mark MemberObject
- (void)MemberObject_GetProfessionList:(NSArray *) dataArray;
{
    professoinList = dataArray;
}

- (void)MemberObject_GetLanguaList:(NSArray *)dataArray
{
    languageList = dataArray;
}

- (void)MemberObject_GetMemberDetails:(BOOL)success infoDictionarys:(NSDictionary *)infoDictionary
{
    ///设置主视图的数据
    if(success){
        [photoImageView setImageWithURL: IMAGE_URL([memberObj memberPhoto]) placeholderImage: [UIImage imageNamed: @"default.png"]];
        memberPhotoImagePath = [memberObj memberPhoto];
        [ch_NametextField setText: [memberObj nickName]];
        [en_NametextField setText: [memberObj nickName_EN]];
        NSInteger index = [[memberObj memberSex] isEqualToString: @"男"] ? 0 : 1;
        if(index < [sexGestureArray count])
            [self sexImageViewDidSelected: [sexGestureArray objectAtIndex: index]];
        NSArray *languageArray = [infoDictionary objectForKey: @"languageList"];
        NSMutableString *languageString = [NSMutableString string];
        NSMutableString *languageIdString = [NSMutableString string];
        for(NSDictionary *dictionary in languageArray){
            [languageString appendString: [dictionary objectForKey:@"name"]];
            [languageString appendString: @","];
            [languageIdString appendString: LONG_PASER_TOSTRING([dictionary objectForKey: @"id"])];
            [languageIdString appendString: @","];
        }
        if([languageString length] > 0){
            [languageLabel setText: [languageString substringToIndex: [languageString length] - 1]];
           selectedLanguage =  [languageIdString substringToIndex: [languageIdString length] - 1];
        }
        [weixinTextField setText: [memberObj weixinAccount]];
        [mailTextFiled setText: [memberObj memberMail]];
        [phoneTextFiled setText: [memberObj memberPhone]];
        [placeTextFiled setText: [memberObj memberAddress]];
        [jobTextLabel setText: VALIDATE_VALUE_STRING([infoDictionary objectForKey: @"professionName"])];
        if(!IsNSNULL([infoDictionary objectForKey: @"professionId"])){
            ProfessionClass *profession = [[ProfessionClass alloc] init];
            [profession setProfessionId: [infoDictionary objectForKey: @"professionId"]];
            [profession setProfessionName: VALIDATE_VALUE_STRING([infoDictionary objectForKey: @"professionName"])];
            selectedProfession = profession;
        }
        [signTextView setText: [memberObj memberSign]];
        [remarksTextView setText:[memberObj synopsis]];
    }
}

#pragma mark -
#pragma mark 加载主视图
- (void)loadMainView
{
    ///1.主滚动视图
    mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [mainScrollView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchMainView)];
    [mainScrollView addGestureRecognizer: tap];
    [self.view addSubview: mainScrollView];
    
    ///2.个人资料视图
    CGFloat tableViewHeight = 2 * SECOND_CELL_HEIGHT + 9 * BASE_CELL_HEIGHT + REMARKS_CELL_HEIGHT + 3 * SECTION_HEIGHT + 50.0f;
    UITableView *mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, tableViewHeight)];
    [mainTableView setDelegate: self];
    [mainTableView setDataSource: self];
    [mainTableView setScrollEnabled: NO];
    [mainTableView setBackgroundColor: [UIColor clearColor]];
    [mainTableView setSeparatorColor: [applicationClass methodOfTurnToUIColor: @"#ebeded"]];
    UIView *footerView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, 50.0f)];
    [footerView setBackgroundColor: [UIColor whiteColor]];
    UIButton *nextButton = [[UIButton alloc] initWithFrame: CGRectMake((curScreenSize.width - 80.0f) / 2.0f, 0.0f, 80.0f, 30.0f)];
    [nextButton setTitle: @"下一步" forState: UIControlStateNormal];
    [nextButton.layer setBorderWidth: 0.5f];
    [nextButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"ff374e"].CGColor];
    [nextButton addTarget: self action: @selector(nextButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [nextButton.titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
    [nextButton setBackgroundColor: [UIColor whiteColor]];
    [nextButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ff374e"] forState: UIControlStateNormal];
    [footerView addSubview: nextButton];
    [mainTableView setTableFooterView: footerView];
    [mainScrollView addSubview: mainTableView];
    
    ///3.调整滚动视图的内容大小
    [mainScrollView setContentSize: CGSizeMake(mainScrollView.frame.size.width, tableViewHeight)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 5;
        }
        case 1:
        {
            return 4;
        }
        case 2:{
            return 3;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell"];
    }
    XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, 0.0f, 80.0f, BASE_CELL_HEIGHT)];
    [titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
    [cell addSubview: titleLabel];
    CGFloat origin_x = titleLabel.frame.size.width + titleLabel.frame.origin.x + 10.0f;
    switch ([indexPath section]) {
        case 0:
        {
            switch ([indexPath row]) {
                case 0:
                {
                    [titleLabel setFrame: CGRectMake(10.0f, 0.0f, 80.0f, SECOND_CELL_HEIGHT)];
                    [titleLabel setText: @"头像*"];
                    ///头像
                    photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(tableView.frame.size.width - SECOND_CELL_HEIGHT, 5.0f, SECOND_CELL_HEIGHT - 10.0f, SECOND_CELL_HEIGHT - 10.0f)];
                    [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
                    [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
                    [photoImageView.layer setMasksToBounds: YES];
                    [photoImageView setImage: [UIImage imageNamed: @"default.png"]];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(uploadPhotoImage)];
                    [photoImageView setUserInteractionEnabled: YES];
                    [photoImageView addGestureRecognizer: tap];
                    [cell addSubview: photoImageView];
                    break;
                }
                case 1:
                {
                    [titleLabel setText: @"中文名*"];
                    ///中文名
                    ch_NametextField = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    [ch_NametextField setTextAlignment: NSTextAlignmentRight];
                    [ch_NametextField setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [ch_NametextField setDelegate: self];
                    [ch_NametextField setPlaceholder: @"请输入您的中文名"];
                    [ch_NametextField setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    [ch_NametextField setReturnKeyType: UIReturnKeyDone];
                    [ch_NametextField setTag: 0];
                    [cell addSubview: ch_NametextField];
                    break;
                }
                case 2:{
                    [titleLabel setText: @"英文名*"];
                    ///英文名
                    en_NametextField = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    [en_NametextField setTextAlignment: NSTextAlignmentRight];
                    [en_NametextField setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [en_NametextField setPlaceholder: @"请输入您的英文名"];
                    [en_NametextField setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    [en_NametextField setDelegate: self];
                    [en_NametextField setReturnKeyType: UIReturnKeyDone];
                    [en_NametextField setTag: 1];
                    [cell addSubview: en_NametextField];
                    break;
                }
                case 3:{
                    [titleLabel setText: @"性别*"];
                    ///性别
                    origin_x = tableView.frame.size.width - 2 * (SELECTED_WIDTH + 10.0f);
                    sexGestureArray = [NSMutableArray arrayWithCapacity: 2];
                    for(NSInteger i = 0; i < 2; i++){
                        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x + i * (SELECTED_WIDTH + 10.0f), 15.0f, SELECTED_WIDTH, BASE_CELL_HEIGHT - 30.0f)];
                        [tempImageView setContentMode: UIViewContentModeScaleAspectFit];
                        NSString *imageName = (i == 0 ? @"not_select_male" : @"not_select_femal");
                        [tempImageView setTag: i];
                        [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"]]];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(sexImageViewDidSelected:)];
                        [tempImageView setUserInteractionEnabled: YES];
                        [tempImageView addGestureRecognizer: tap];
                        [cell addSubview: tempImageView];
                        [sexGestureArray addObject: tap];
                    }
                    break;
                }
                case 4:{
                    [titleLabel setText: @"语言*"];
                    ///语言
                    origin_x = tableView.frame.size.width - 3 * (SELECTED_WIDTH + 10.0f);
                    languageLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    [languageLabel setTextAlignment: NSTextAlignmentRight];
                    [languageLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [languageLabel setText: @"请选择您所会的语言"];
                    [languageLabel setTag: 8];
                    [languageLabel setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(openLanguagePicker)];
                    [languageLabel setUserInteractionEnabled: YES];
                    [languageLabel addGestureRecognizer: tap];
                    [cell addSubview: languageLabel];
                    
                    //                    for(NSInteger i = 0; i < 3; i++){
                    //                        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x + i * (SELECTED_WIDTH + 10.0f), 0.0f, SELECTED_WIDTH, BASE_CELL_HEIGHT)];
                    //                        [tempImageView setContentMode: UIViewContentModeScaleAspectFit];
                    //                        NSString *imageName = @"not_select_chese";
                    //                        switch (i) {
                    //                            case 1:
                    //                                imageName = @"not_select_english";
                    //                                break;
                    //                            case 2:
                    //                                imageName = @"not_select_other";
                    //                                break;
                    //                            default:
                    //                                break;
                    //                        }
                    //                        [tempImageView setTag: i];
                    //                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(languageImageViewDidSelected:)];
                    //                        [tempImageView setUserInteractionEnabled: YES];
                    //                        [tempImageView addGestureRecognizer: tap];
                    //                        [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"]]];
                    //                        [cell addSubview: tempImageView];
                    //                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch ([indexPath row]) {
                case 0:
                {
                    [titleLabel setText: @"微信号"];
                    ///
                    weixinTextField = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    [weixinTextField setTextAlignment: NSTextAlignmentRight];
                    [weixinTextField setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [weixinTextField setPlaceholder: @"请输入您的微信号"];
                    [weixinTextField setDelegate: self];
                    [weixinTextField setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    [weixinTextField setReturnKeyType: UIReturnKeyDone];
                    [weixinTextField setTag: 4];
                    [cell addSubview: weixinTextField];
                    break;
                }
                case 1:{
                    [titleLabel setText: @"邮箱"];
                    ///
                    mailTextFiled = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    [mailTextFiled setTextAlignment: NSTextAlignmentRight];
                    [mailTextFiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [mailTextFiled setPlaceholder: @"请输入您的邮箱地址"];
                    [mailTextFiled setDelegate: self];
                    [mailTextFiled setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    [mailTextFiled setReturnKeyType: UIReturnKeyDone];
                    [mailTextFiled setTag: 5];
                    [cell addSubview: mailTextFiled];
                    break;
                }
                case 2:{
                    [titleLabel setText: @"手机号码"];
                    ///
                    phoneTextFiled = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    [phoneTextFiled setTextAlignment: NSTextAlignmentRight];
                    [phoneTextFiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [phoneTextFiled setDelegate: self];
                    [phoneTextFiled setPlaceholder: @"请输入您的手机号码"];
                    [phoneTextFiled setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    [phoneTextFiled setReturnKeyType: UIReturnKeyDone];
                    [phoneTextFiled setTag: 6];
                    [cell addSubview: phoneTextFiled];
                    break;
                }
                case 3:{
                    [titleLabel setText: @"所在地"];
                    ///
                    placeTextFiled = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    [placeTextFiled setTextAlignment: NSTextAlignmentRight];
                    [placeTextFiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [placeTextFiled setDelegate: self];
                    [placeTextFiled setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    [placeTextFiled setPlaceholder: @"请输入您的所在地"];
                    [placeTextFiled setReturnKeyType: UIReturnKeyDone];
                    [placeTextFiled setTag: 7];
                    [cell addSubview: placeTextFiled];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch ([indexPath row]) {
                case 0:
                {
                    [titleLabel setText: @"职业／标签*"];
                    ///
                    //                    UITextField *tagTextFiled = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    //                    [tagTextFiled setTextAlignment: NSTextAlignmentRight];
                    //                    [tagTextFiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    //                    [tagTextFiled setDelegate: self];
                    //                    [tagTextFiled setPlaceholder: @"请输入您的职业"];
                    //                    [tagTextFiled setReturnKeyType: UIReturnKeyDone];
                    //                    [tagTextFiled setTag: 8];
                    //                    [tagTextFiled setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    //                    [cell addSubview: tagTextFiled];
                    jobTextLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, BASE_CELL_HEIGHT - 20.0f)];
                    [jobTextLabel setTextAlignment: NSTextAlignmentRight];
                    [jobTextLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [jobTextLabel setText: @"请选择您的职业"];
                    [jobTextLabel setTag: 8];
                    [jobTextLabel setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(openPicker)];
                    [jobTextLabel setUserInteractionEnabled: YES];
                    [jobTextLabel addGestureRecognizer: tap];
                    [cell addSubview: jobTextLabel];
                    break;
                }
                case 1:
                {
                    [titleLabel setText: @"个人签名"];
                    ///
                    signTextView = [[UITextView alloc] initWithFrame: CGRectMake(origin_x, 10.0f, tableView.frame.size.width - origin_x - 10.0f, SECOND_CELL_HEIGHT - 20.0f)];
                    [signTextView setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c5c5"]];
                    [signTextView setDelegate: self];
                    [signTextView setReturnKeyType: UIReturnKeyDone];
                    [signTextView setTag:9];
                    [signTextView setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    [cell addSubview: signTextView];
                    break;
                }
                case 2:{
                    [titleLabel setText: @"个人简介"];
                    CGFloat tmpOrigin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
                    ///简介输入框
                    remarksTextView = [[UITextView alloc] initWithFrame: CGRectMake(10.0f, tmpOrigin_y, tableView.frame.size.width - 20.0f, REMARKS_CELL_HEIGHT - tmpOrigin_y - 40.0f)];
                    [remarksTextView.layer setBorderWidth: 1.0f];
                    [remarksTextView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#eef1f1"].CGColor];
                    [remarksTextView.layer setCornerRadius: 2.0f];
                    [remarksTextView setText: @"请输入..."];
                    [remarksTextView setReturnKeyType: UIReturnKeyDone];
                    [remarksTextView setTextColor: [applicationClass methodOfTurnToUIColor: @"#c9cbcb"]];
                    [remarksTextView setTag: 10];
                    [remarksTextView setDelegate: self];
                    [remarksTextView setFont: [UIFont systemFontOfSize: INPUT_FONT_SIZE]];
                    [cell addSubview: remarksTextView];
                    ///字数
                    tmpOrigin_y += remarksTextView.frame.size.height;
                    fontNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, tmpOrigin_y, tableView.frame.size.width - 20.0f, 20.0f)];
                    [fontNumberLabel setText: @"您还可以输入320个字"];
                    [fontNumberLabel setTextAlignment: NSTextAlignmentRight];
                    [fontNumberLabel setFont: [UIFont systemFontOfSize: 11.0f]];
                    [fontNumberLabel setTextColor: [UIColor grayColor]];
                    [cell addSubview: fontNumberLabel];
                    break;
                }
                default:
                    break;
            }
        }
        default:
            break;
    }
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
        {
            switch ([indexPath row]) {
                case 0:
                    return SECOND_CELL_HEIGHT;
                default:
                    return BASE_CELL_HEIGHT;
            }
            break;
        }
        case 2:{
            switch ([indexPath row]) {
                case 1:
                    return SECOND_CELL_HEIGHT;
                case 2:
                    return REMARKS_CELL_HEIGHT;
                default:
                    return BASE_CELL_HEIGHT;
            }
        }
        default:
            return BASE_CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor: [UIColor clearColor]];
    return view;
}

#pragma mark -
#pragma mark textField委托
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    lastResponser = textField;
    [mainScrollView setContentOffset:CGPointMake(0.0f, SECTION_HEIGHT + SECOND_CELL_HEIGHT + [textField tag] * BASE_CELL_HEIGHT) animated: YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark textView委托
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    lastResponser = textView;
    [mainScrollView setContentOffset:CGPointMake(0.0f, SECTION_HEIGHT +  SECOND_CELL_HEIGHT + [textView tag] * BASE_CELL_HEIGHT) animated: YES];
    if([textView tag] == 10 && [[textView text] isEqualToString: @"请输入..."]){
        [textView setText: @""];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if([textView tag] == 10)
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
}

#pragma mark -
#pragma mark 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [lastResponser resignFirstResponder];
}

- (void)touchMainView
{
    [lastResponser resignFirstResponder];
    [mainScrollView setContentOffset: CGPointMake(0.0f, 0.0f) animated: YES];
}


#pragma mark -
#pragma mark
- (void)sexImageViewDidSelected:(UITapGestureRecognizer *) sender
{
    BOOL isChange = NO;
    if([lastSelectedSexImageView tag] != [sender.view tag])
    {
        isChange = YES;
    }
    switch ([sender.view tag]) {
        case 0:
        {
            selectedSex = @"0";
            [(UIImageView *)sender.view setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selected_male" ofType: @"png"]]];
            if(isChange)
                [lastSelectedSexImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"not_select_femal" ofType: @"png"]]];
            break;
        }
        case 1:
        {
            selectedSex = @"1";
            [(UIImageView *)sender.view setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selected_femal" ofType: @"png"]]];
            if(isChange)
                [lastSelectedSexImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"not_select_male" ofType: @"png"]]];
            break;
        }
        default:
            break;
    }
    lastSelectedSexImageView = (UIImageView *)sender.view;
}


- (void)languageImageViewDidSelected:(UITapGestureRecognizer *)sender
{
    
    switch ([sender.view tag]) {
        case 0:
        {
            [(UIImageView *)sender.view setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selected_chese" ofType: @"png"]]];
            break;
        }
        case 1:
        {
            [(UIImageView *)sender.view setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selected_english" ofType: @"png"]]];
            break;
        }
        case 2:
        {
            [(UIImageView *)sender.view setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selected_other" ofType: @"png"]]];
            break;
        }
        default:
            break;
    }
    if([lastSelectedLanguageImageView tag] != [sender.view tag])
    {
        switch ([lastSelectedLanguageImageView tag]) {
            case 0:
            {
                [lastSelectedLanguageImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"not_select_chese" ofType: @"png"]]];
                break;
            }
            case 1:
            {
                [lastSelectedLanguageImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"not_select_english" ofType: @"png"]]];
                break;
            }
            case 2:
            {
                [lastSelectedLanguageImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"not_select_other" ofType: @"png"]]];
                break;
            }
            default:
                break;
        }
        lastSelectedLanguageImageView = (UIImageView *)sender.view;
    }
}

#pragma mark -
#pragma mark 打开筛选器
- (void)openPicker
{
    [lastResponser resignFirstResponder];
    if(!mainPickerView)
    {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity: [professoinList count]];
        for(ProfessionClass *profession in professoinList){
            [tempArray addObject: [profession professionName]];
        }
        mainPickerView = [[XZJ_CustomPicker alloc] initWithFrame:CGRectMake(0.0f, curScreenSize.height, curScreenSize.width, curScreenSize.height/2.0f) dataArray: [NSArray arrayWithObject: tempArray]];
        [mainPickerView setDelegate: self];
        [self.view addSubview: mainPickerView];
    }
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, curScreenSize.height - curScreenSize.height/2.0f, curScreenSize.width, curScreenSize.height/2.0f));
    [applicationClass methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainPickerView, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

- (void)XZJ_CustomPicker_CancelClick:(NSInteger)tag
{
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, curScreenSize.height, curScreenSize.width, curScreenSize.height/2.0f));
    [applicationClass methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainPickerView, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

- (void)XZJ_CustomPicker_EnsureClick:(NSInteger)tag data:(NSArray *)data selectIndexs:(NSArray *)indexs
{
    [self XZJ_CustomPicker_CancelClick: 0];
    if([data count] > 0)
    {
        ProfessionClass *class = [professoinList objectAtIndex: [[indexs objectAtIndex: 0] integerValue]];
        selectedProfession = class;
        [jobTextLabel setText: [data objectAtIndex: 0]];
    }
}

#pragma mark -
#pragma mark 打开语言的选择框
- (void)openLanguagePicker
{
    [lastResponser resignFirstResponder];
    if(!languageListView){
        languageListView = [[LanguageListView alloc] initWithFrame: CGRectMake(0.0f, curScreenSize.height, curScreenSize.width, curScreenSize.height / 2.0f) dataArray: languageList];
        [languageListView setXDelegate: self];
        [self.view addSubview: languageListView];
    }
    [languageListView animateShow];
}

- (void)languageListView_EnsureClick:(NSArray *)_dataArray
{
    NSLog(@"%@",_dataArray);
    NSMutableArray *languaArray = [[NSMutableArray alloc] init];
    NSMutableArray *languaIdArray = [[NSMutableArray alloc] init];
    for(LanguageClass *language in _dataArray){
        [languaArray addObject: [language languageName] ];
        [languaIdArray addObject: [language languageId]];
    }
    [languageLabel setText: [languaArray componentsJoinedByString: @","]];
    selectedLanguage = [languaIdArray componentsJoinedByString: @","];
}

#pragma mark -
#pragma mark 上传头像
- (void)uploadPhotoImage
{
    //上传头像
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"请选择上传方式" delegate: self cancelButtonTitle: @"取消" destructiveButtonTitle: nil otherButtonTitles: @"拍照", @"打开相册", nil];
    [actionSheet showInView: [[UIApplication sharedApplication] keyWindow]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //修改头像
    switch (buttonIndex) {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                [imagePickerController setSourceType: UIImagePickerControllerSourceTypeCamera];
                [imagePickerController setDelegate: self];
                [imagePickerController setAllowsEditing: YES];
                [imagePickerController.navigationBar setTintColor: [applicationClass themeColor]];
                [imagePickerController setCameraDevice: UIImagePickerControllerCameraDeviceFront];
                [self presentViewController: imagePickerController animated: YES completion: nil];
            }
            else
                [applicationClass methodOfShowAlert: @"对不起，您的设备不支持拍照"];
            break;
        }
        case 1:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            [imagePickerController setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePickerController setDelegate: self];
            [imagePickerController setAllowsEditing: YES];
            [imagePickerController.navigationBar setTintColor: [applicationClass themeColor]];
            [self presentViewController: imagePickerController animated: YES completion: nil];
            break;
        }
        default:
            //                    [maskView setHidden: YES];
            break;
    }
}

#pragma mark -
#pragma mark 获取相册的委托方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    [photoImageView setImage: image];
    //    image = [applicationClass methodOfAdjustImage: image scaleToSize: CGSizeMake(50.0f, 50.0f)];
    //上传头像
    NSData *imageData;
    NSString *imageName = nil;
    if (UIImagePNGRepresentation(image))
    {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(image);
        imageName = @"photo2.png";
    }
    else
    {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(image, 1.0);
        imageName = @"photo2.jpg";
    }
    [memberObj uploadFile: imageData fileName: imageName];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated: YES completion: nil];
    //    [maskView setHidden: YES];
}

- (void)MemberObject_UploadPhotoSuccess:(BOOL)success imagePath:(NSString *)imagePath
{
    if(success){
        memberPhotoImagePath = imagePath;
    }
    else{
        [applicationClass methodOfShowAlert: @"头像上传失败"];
    }
}

#pragma mark -
#pragma mark 
- (void)nextButtonClick
{
    if([[ch_NametextField text] length] == 0){
        [applicationClass methodOfShowAlert: @"请输入您的中文名"];
        return;
    }
    if([[en_NametextField text] length] == 0){
        [applicationClass methodOfShowAlert: @"请输入您的英文名"];
        return;
    }
    if(!selectedSex){
        [applicationClass methodOfShowAlert: @"请选择您的性别"];
        return;
    }
    if([[languageLabel text] length] == 0 || [[languageLabel text] isEqualToString: @"请选择您所会的语言"]){
        [applicationClass methodOfShowAlert: @"请选择您所会的语言"];
        return;
    }
    if([[jobTextLabel text] length] == 0 || [[jobTextLabel text] isEqualToString: @"请选择您的职业"]){
        [applicationClass methodOfShowAlert: @"请选择您的职业"];
        return;
    }
    if([[phoneTextFiled text] length] > 0 && ![applicationClass methodOfValidatePhoneNumber: [phoneTextFiled text]]){
        [applicationClass methodOfShowAlert: @"请输入正确的手机号码"];
        return;
    }
    if([[mailTextFiled text] length] > 0 && ![applicationClass methodOfValidateEmail: [mailTextFiled text]]){
        [applicationClass methodOfShowAlert: @"请输入正确的邮箱地址"];
        return;
    }
    [memberObj setMemberId: [memberDictionary objectForKey:@"id"]];
    [memberObj setNickName: [ch_NametextField text]];
    [memberObj setNickName_EN: [en_NametextField text]];
    [memberObj setMemberPhone: [phoneTextFiled text]];
    [memberObj setWeixinAccount: [weixinTextField text]];
    [memberObj setMemberMail: [mailTextFiled text]];
    [memberObj setMemberAddress: [placeTextFiled text]];
    [memberObj setMemberSex: selectedSex];
    [memberObj setMemberSign: [signTextView text]];
    [memberObj setSynopsis: ([[remarksTextView text] isEqualToString: @"请输入..."] ? @"" : [remarksTextView text])];
    [memberObj setLanguageIds: selectedLanguage];
    [memberObj setProfession: selectedProfession];
    [memberObj setMemberPhoto: memberPhotoImagePath];
    [memberObj updateMemberInfo];
}

- (void)MemberObject_DidUpdateSuccess:(BOOL)success
{
    if(success){
        BHStepThreeViewController *nextVC = [[BHStepThreeViewController alloc] init];
        [nextVC setMemberObj: memberObj];
        [self.navigationController pushViewController: nextVC animated: YES];
    }
    else{
        [applicationClass methodOfShowAlert: @"个人资料更新失败，请稍候再试"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
