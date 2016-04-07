//
//  HomePageMemberView.m
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define MEMBER_TOP_CELL_HEIGHT 180.0f
#define MEMBER_BASE_CELL_HEIGHT 40.0f
#define NAVIGATIONBAR_HEIGHT 44.0f
#import "HomePageMemberView.h"

@implementation HomePageMemberView
- (id)initWithFrame:(CGRect)frame delegate:(UIViewController<HomePageMemberViewDelegate> *) _delegate
{
    self = [super initWithFrame: frame];
    if(self){
        xDelegate = _delegate;
        applicationClass = [XZJ_ApplicationClass commonApplication];
        ///1.初始化
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#d6d6d6"].CGColor];
        [self.layer setMasksToBounds: YES];
        [self.layer setBorderWidth: 0.5f];
        [self setShowsVerticalScrollIndicator: NO];
        
        ///2.tableView
        memberDictionary = (NSDictionary *)[applicationClass methodOfReadLocal: @"LOCALUSER"];
        isHunter = [[memberDictionary objectForKey: @"userType"] isEqualToString: @"HUNTER_USER"] ? YES : NO;
        isMale = [[memberDictionary objectForKey: @"sex"] integerValue] == 0 ? YES : NO;
        CGFloat tableViewHeight = MEMBER_TOP_CELL_HEIGHT + 9 * MEMBER_BASE_CELL_HEIGHT + 5.0f;
        mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT, frame.size.width, tableViewHeight)];
        [mainTableView setDelegate: self];
        [mainTableView setDataSource: self];
        UIView *footerView = [[UIView alloc] init];
        [footerView setBackgroundColor: [UIColor clearColor]];
        [mainTableView setTableFooterView: footerView];
        [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [mainTableView setScrollEnabled: NO];
        [mainTableView setShowsVerticalScrollIndicator: NO];
        [self addSubview: mainTableView];
        ///3.分割线
        CGFloat origin_y = tableViewHeight + mainTableView.frame.origin.y;
        UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, origin_y, frame.size.width, 1.0f)];
        [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f7f7f7"]];
        [self addSubview: lineView];
        ///4.底部icon
        origin_y += 20.0f;
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(frame.size.width * 3.0f / 8.0f, origin_y, frame.size.width / 4.0f, 20.0f)];
        [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"gray_logo" ofType: @"png"]]];
        [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [self addSubview: iconImageView];
        //设置scrollview高度
        [self setContentSize: CGSizeMake(frame.size.width, iconImageView.frame.size.height + iconImageView.frame.origin.y + 20.0f)];
    }
    return self;
}

#pragma mark -
#pragma mark tableView委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 3;
        case 2:
        {
            if(isHunter)
                return 2;
            else
                return 1;
        }
        case 3:
            return 1;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ////侧滑栏的tableView
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"cell"];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    switch ([indexPath section]) {
        case 0:
        {
            UIColor *themeColor = [applicationClass methodOfTurnToUIColor: @"#fbc9d4"];
            if(isMale){
                themeColor = [applicationClass methodOfTurnToUIColor: @"#6fc9e5"];
            }
            ////1.会员头像
            if(!photoImageView){
                photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake((tableView.frame.size.width - MEMBER_TOP_CELL_HEIGHT / 2.0f) / 2.0f, 20.0f, MEMBER_TOP_CELL_HEIGHT / 2.0f, MEMBER_TOP_CELL_HEIGHT / 2.0f)];
                [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
                [photoImageView.layer setMasksToBounds: YES];
                [photoImageView.layer setShadowOpacity: 0.2f];
                [photoImageView.layer setShadowOffset: CGSizeMake(0.0f, 1.0f)];
                [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
                [photoImageView.layer setBorderWidth: 2.0f];
            }
            [photoImageView.layer setBorderColor: themeColor.CGColor];
            [photoImageView setImageWithURL: IMAGE_URL([memberDictionary objectForKey: @"photo"]) placeholderImage: [UIImage imageNamed: @"default.png"]];
            [cell addSubview: photoImageView];
            CGFloat origin_x = 0.0f, origin_y = 0.0f;
            if(isHunter){
                CGFloat size_w = photoImageView.frame.size.width / 4.0f;
                origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x - size_w;
                origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y - size_w;
                if(!roleImageView){
                    roleImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, origin_y, size_w, size_w)];
                    [roleImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"hunter_icon" ofType: @"png"]]];
                    [roleImageView setContentMode: UIViewContentModeScaleAspectFit];
                    [roleImageView.layer setCornerRadius: roleImageView.frame.size.height / 2.0f];
                    [roleImageView.layer setShadowOpacity: 0.2f];
                    [roleImageView.layer setShadowOffset: CGSizeMake(0.0f, 1.0f)];
                }
                [roleImageView setBackgroundColor: themeColor];
                [roleImageView setHidden: NO];
                [cell addSubview: roleImageView];
            }
            else{
                [roleImageView setHidden: YES];
            }
            ///2.会员名
            origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y + 5.0f;
            if(!nameLabel){
                nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, tableView.frame.size.width - 20.0f, 20.0f)];
                [nameLabel setFont: [UIFont systemFontOfSize: 13.0f]];
                [nameLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#3d3d3d"]];
                [nameLabel setTextAlignment: NSTextAlignmentCenter];
            }
            [nameLabel setText: [memberDictionary objectForKey: @"ch_name"]];
            [cell addSubview: nameLabel];
            ///3.个性签名或者发布旅程
            origin_y += nameLabel.frame.size.height;
            if(isHunter)
            {
                //猎人
                [signIconImageView setHidden: YES];
                [signLabel setHidden: YES];
                if(!publishTravelImageView){
                    publishTravelImageView = [[UIImageView alloc] initWithFrame: CGRectMake(photoImageView.frame.origin.x, origin_y, photoImageView.frame.size.width, 30.0f)];
                    [publishTravelImageView setContentMode: UIViewContentModeScaleAspectFit];
                    [publishTravelImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"publish_travel" ofType: @"png"]]];
                    [publishTravelImageView setUserInteractionEnabled: YES];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(publishTravelClick)];
                    [publishTravelImageView addGestureRecognizer: tap];
                }
                [publishTravelImageView setHidden: NO];
                [cell addSubview: publishTravelImageView];
            }
            else{
                //普通用户
                [publishTravelImageView setHidden: YES];
                if(!signIconImageView){
                    signIconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(tableView.frame.size.width / 4.0f, origin_y + 5.0f, 14.0f, 14.0f)];
                    [signIconImageView setContentMode: UIViewContentModeScaleAspectFit];
                    [signIconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"member_sign" ofType: @"png"]]];
                }
                [signIconImageView setHidden: NO];
                [cell addSubview: signIconImageView];
                if(!signLabel){
                    origin_x = signIconImageView.frame.size.width + signIconImageView.frame.origin.x + 5.0f;
                    signLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, tableView.frame.size.width - origin_x - 10.0f, 25.0f)];
                    [signLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#a9a9a9"]];
                    [signLabel setFont: [UIFont systemFontOfSize: 13.0f]];
                }
                [signLabel setHidden: NO];
                if([[memberDictionary objectForKey: @"sign"] length] == 0){
                    [signLabel setText: @"该用户有点懒，暂未留下签名"];
                }
                else
                    [signLabel setText: [memberDictionary objectForKey: @"sign"]];
                [cell addSubview: signLabel];
            }
            break;
        }
        default:
        {
            ///1.图标
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, 13.0f, MEMBER_BASE_CELL_HEIGHT  -26.0f, MEMBER_BASE_CELL_HEIGHT - 26.0f)];
            [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
            [cell addSubview: iconImageView];
            ///2.标题
            CGFloat origin_x = iconImageView.frame.size.width + iconImageView.frame.origin.x + 10.0f;
            XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, tableView.frame.size.width - origin_x - 100.0f, MEMBER_BASE_CELL_HEIGHT)];
            [titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
            [cell addSubview: titleLabel];
            switch ([indexPath section]) {
                case 1:
                {
                    switch ([indexPath row]) {
                        case 0:
                            [titleLabel setText: @"我的行程单"];
                            [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_working" ofType: @"png"]]];
                            break;
                        case 1:
                            [titleLabel setText: @"我的心愿单"];
                            [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_hope" ofType: @"png"]]];
                            break;
                        case 2:
                            [titleLabel setText: @"私信"];
                            [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_message" ofType: @"png"]]];
                            break;
                        default:
                            break;
                    }
                    break;
                }
                case 2:
                {
                    if(isHunter){
                        ///2猎人
                        switch ([indexPath row]) {
                            case 0:
                                [titleLabel setText: @"我收到的预定"];
                                [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_message" ofType: @"png"]]];
                                break;
                            case 1:
                                [titleLabel setText: @"我发布的旅程"];
                                [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_message" ofType: @"png"]]];
                                break;
                            default:
                                break;
                        }
                    }
                    else{
                        ///普通用户
                        [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_hunter" ofType: @"png"]]];
                        [titleLabel setText: @"成为猎人"]; 
                    }
                    
                    break;
                }
                case 3:
                {
                    switch ([indexPath row]) {
//                        case 0:
//                            [titleLabel setText: @"我的优惠"];
//                            [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_free" ofType: @"png"]]];
//                            break;
//                        case 1:
//                            [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_pop" ofType: @"png"]]];
//                            [titleLabel setText: @"我要投稿"];
//                            break;
                        case 0:
                            [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_setting" ofType: @"png"]]];
                            [titleLabel setText: @"设置"];
                            break;
                        default:
                            break;
                    }
                    break;
                }
//                case 4:
//                {
//                    switch ([indexPath row]) {
//                        case 0:
//                            [titleLabel setText: @"关于世界观"];
//                            [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_about" ofType: @"png"]]];
//                            break;
//                        case 1:
//                            [titleLabel setText: @"加入世界观"];
//                            [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_join" ofType: @"png"]]];
//                            break;
//                        default:
//                            break;
//                    }
//                    break;
//                }
                default:
                    break;
            }
            [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
            break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
            return MEMBER_TOP_CELL_HEIGHT;
        default:
            return MEMBER_BASE_CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section != 0)
        return 1.0f;
    else
        return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([xDelegate respondsToSelector: @selector(homePageMemberView_WillDisplay:)]){
        [xDelegate homePageMemberView_WillDisplay:indexPath];
    }
}

#pragma mark -
#pragma mark 发布旅程
- (void)publishTravelClick
{
    if([xDelegate respondsToSelector: @selector(homePageMemberView_WillDisplay:)]){
        [xDelegate homePageMemberView_WillDisplay:[NSIndexPath indexPathForRow: 1 inSection: 0]];
    }    
}
#pragma mark -
#pragma mark 更新用户信息
- (void)updateMemberInfo
{
    memberDictionary = (NSDictionary *)[applicationClass methodOfReadLocal: @"LOCALUSER"];
    isHunter = [[memberDictionary objectForKey: @"userType"] isEqualToString: @"HUNTER_USER"] ? YES : NO;
    isMale = [[memberDictionary objectForKey: @"sex"] integerValue] == 0 ? YES : NO;
    [mainTableView reloadData];
}
@end
