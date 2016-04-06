//
//  AppointMainView.m
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define CARD_BOTTOM_HEIGHT 55.0F
#define CARD_MARGIN_LEFT 20.0F
#import "AppointMainView.h"

@implementation AppointMainView
- (id)initWithFrame:(CGRect)frame service:(ServiceClass *)_service
{
    self = [super initWithFrame: frame];
    mainService = _service;
    if(self){
        ///加载旅程时间数据
        seviceObj = [[ServiceObject alloc] init];
        [seviceObj setXDelegate: self];
        [seviceObj getTravelTimeList: [_service serviceId]];
        ///初始化预订信息
        appointClass = [[AppointClass alloc] init];
        ///
        CGSize _size = [[UIScreen mainScreen] bounds].size;
        mainApplication = [XZJ_ApplicationClass commonApplication];
        ///1.视图设置
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.2f alpha: 0.5f]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(mainMaskViewClick)];
        [self addGestureRecognizer: tap];
        ///2.底部背景
        cardBottomView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, self.frame.size.height - CARD_BOTTOM_HEIGHT, _size.width , CARD_BOTTOM_HEIGHT)];
        [cardBottomView setBackgroundColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#ff3647"]];
        [cardBottomView setContentMode: UIViewContentModeScaleAspectFit];
        [self addSubview: cardBottomView];
        ///3.左边三角形
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, cardBottomView.frame.origin.y - 10.0f, 20.0f, 10.0f)];
        [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"rect_left" ofType: @"png"]]];
        [self addSubview: tempImageView];
        ///3.右边三角形
        tempImageView = [[UIImageView alloc] initWithFrame: CGRectMake(_size.width - 20.0f, cardBottomView.frame.origin.y - 10.0f, 20.0f, 10.0f)];
        [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"rect_right" ofType: @"png"]]];
        [self addSubview: tempImageView];
        ///4.操作按钮
        cardOperateButton = [[UIButton alloc] initWithFrame: CGRectMake(_size.width - 120.0f, 10.0f, 80.0f, CARD_BOTTOM_HEIGHT - 20.0f)];
        [cardOperateButton.layer setCornerRadius: 3.0f];
        [cardOperateButton.layer setBorderWidth: 0.5f];
        [cardOperateButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [cardOperateButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [cardOperateButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [cardOperateButton addTarget: self action: @selector(cardOperateButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [cardBottomView addSubview: cardOperateButton];
    }
    return self;
}
#pragma mark -
#pragma mark serviceObject委托
- (void)serviceObject_GetTravelTimeList:(NSArray *)dataArray
{
    travelTimeArray = dataArray;
}

- (void)serviceObject_OrderServiceResult:(BOOL)success
{
    if(success){
        [mainApplication methodOfShowAlert: @"预定成功!"];
    }
    else
        [mainApplication methodOfShowAlert: @"预定失败,请稍候重试"];
}

#pragma mark -
#pragma mark 加载旅游原因的视图
- (void)loadTravelReasonView
{
    CGSize _size = [[UIScreen mainScreen] bounds].size;
    CGFloat carHeight = _size.height * 4 / 5.5;
    [cardOperateButton setTag: 1];
    [cardOperateButton setTitle: @"下一步" forState: UIControlStateNormal];
    if(!travelReasonView)
    {
        ///1.旅程原因主视图
        travelReasonView = [[UIView alloc] initWithFrame: CGRectMake(CARD_MARGIN_LEFT, self.frame.size.height - CARD_BOTTOM_HEIGHT + 10.0f, _size.width - 2 * CARD_MARGIN_LEFT, 0.0f)];
        [travelReasonView setBackgroundColor: [UIColor whiteColor]];
        [travelReasonView.layer setCornerRadius: 5.0f];
        [self insertSubview: travelReasonView belowSubview: cardBottomView];
        
        ///2.内容
        CGFloat size_h = (carHeight - 20.0f) / 2.0f;
        CGFloat origin_y = 0.0f, origin_x = 0.0f;
        for(NSInteger i = 0; i < 2; i++){
            ///背景
            UIView *tempView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, i * (size_h), travelReasonView.frame.size.width, size_h)];
            [travelReasonView addSubview: tempView];
            ///圆点图标
            UIView *iconView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, 15.0f, 6.0f, 6.0f)];
            [iconView setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#fb1539"]];
            [iconView.layer setCornerRadius: iconView.frame.size.height / 2.0f];
            [tempView addSubview: iconView];
            ///标题
            origin_x = iconView.frame.size.width + iconView.frame.origin.x + 5.0f;
            XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, travelReasonView.frame.size.width - origin_x - 10.0f, 40.0f)];
            [titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
            [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#4c4d4e"]];
            [tempView addSubview: titleLabel];
            ///输入框
            origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
            UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(10.0f, origin_y, tempView.frame.size.width - 20.0f, tempView.frame.size.height - origin_y - 20.0f)];
            [textView setText: @"请输入..."];
            [textView.layer setCornerRadius: 5.0f];
            [textView.layer setBorderColor:[mainApplication methodOfTurnToUIColor: @"#e0e1e2"].CGColor];
            [textView.layer setBorderWidth: 1.0f];
            [textView setTextColor: [mainApplication methodOfTurnToUIColor: @"#b4b5b6"]];
            [textView setDelegate: self];
            [textView setTag: i];
            if(i == 0)
                purposeTextView = textView;
            else
                introduceTextView = textView;
            [textView setKeyboardType: UIKeyboardTypeNumberPad];
            [tempView addSubview: textView];
            ///剩余字数
            origin_y = textView.frame.size.height + textView.frame.origin.y;
            XZJ_CustomLabel *numberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, tempView.frame.size.width - 20.0f, 20.0f)];
            [numberLabel setText: @"您还可以输入300个字"];
            [numberLabel setFont: [UIFont systemFontOfSize: 12.0f]];
            [numberLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#c6c7c8"]];
            [numberLabel setTextAlignment: NSTextAlignmentRight];
            [tempView addSubview: numberLabel];
            ///
            switch (i) {
                case 0:
                    [titleLabel setText: @"请向城市猎人说明此次出行的目的:"];
                    break;
                case 1:
                    [titleLabel setText: @"请向城市猎人简单的介绍一下自己:"];
                    break;
                default:
                    break;
            }
        }
    }
    [UIView animateWithDuration: 0.3f animations: ^{
        CGRect frame =  CGRectMake(CARD_MARGIN_LEFT, self.frame.size.height - carHeight - CARD_BOTTOM_HEIGHT + 10.0f, _size.width - 2 * CARD_MARGIN_LEFT, carHeight);
        [travelReasonView setFrame: frame];
    }];
}

#pragma mark -
#pragma mark 加载预订条款
- (void)loadOrderProtocol
{
    CGSize _size = [[UIScreen mainScreen] bounds].size;
    CGFloat carHeight = _size.height * 4 / 5.5;
    [cardOperateButton setTitle: @"完成" forState: UIControlStateNormal];
    [cardOperateButton setTag: 2];
    if(!orderProtocolView)
    {
        ///1.旅程原因主视图
        orderProtocolView = [[UIView alloc] initWithFrame: CGRectMake(CARD_MARGIN_LEFT, self.frame.size.height - CARD_BOTTOM_HEIGHT + 10.0f, _size.width - 2 * CARD_MARGIN_LEFT, 0.0f)];
        [orderProtocolView setBackgroundColor: [UIColor whiteColor]];
        [orderProtocolView.layer setCornerRadius: 5.0f];
        [self insertSubview: orderProtocolView belowSubview: cardBottomView];
        
        ///2.标题
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, orderProtocolView.frame.size.width, 50.0f)];
        [titleLabel setFont: [UIFont systemFontOfSize: 18.0f]];
        [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#4c4d4e"]];
        [titleLabel setText: @"预订条款及协议"];
        [titleLabel setTextAlignment: NSTextAlignmentCenter];
        [orderProtocolView addSubview: titleLabel];
        
        ///3.具体条款和协议
        CGFloat origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(10.0f, origin_y, orderProtocolView.frame.size.width - 20.0f, carHeight - origin_y - 80.0f)];
        [textView setText: @"第一条 相关概念和注释"];
        [textView.layer setBorderColor:[mainApplication methodOfTurnToUIColor: @"#e0e1e2"].CGColor];
        [textView.layer setBorderWidth: 1.0f];
        [textView setTextColor: [mainApplication methodOfTurnToUIColor: @"#b4b5b6"]];
        [textView setEditable: NO];
        [orderProtocolView addSubview: textView];
        
        ///4.复选框
        origin_y = textView.frame.size.height + textView.frame.origin.y + 20.0f;
        chechedButton = [[UIButton alloc] initWithFrame: CGRectMake(orderProtocolView.frame.size.width / 3.0f - 20.0f, origin_y, 20.0f, 20.0f)];
        [chechedButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_none" ofType: @"png"]] forState: UIControlStateNormal];
        [chechedButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_checked" ofType: @"png"]] forState: UIControlStateSelected];
        [chechedButton addTarget: self action: @selector(chechedButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [orderProtocolView addSubview: chechedButton];
        
        ///5.用户协议
        CGFloat origin_x = chechedButton.frame.size.width + chechedButton.frame.origin.x + 5.0f;
        XZJ_CustomLabel *protocolLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, orderProtocolView.frame.size.width - origin_x, 20.0f)];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString: @"我已阅读并同意用户协议"];
        [attributeString addAttribute: NSForegroundColorAttributeName value: [mainApplication methodOfTurnToUIColor: @"#7f8081"] range: NSMakeRange(0, 7)];
        [attributeString addAttribute: NSForegroundColorAttributeName value: [mainApplication methodOfTurnToUIColor: @"#65aefc"] range: NSMakeRange(7, 4)];
        [protocolLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [protocolLabel setAttributedText: attributeString];
        [orderProtocolView addSubview: protocolLabel];
    }
    [UIView animateWithDuration: 0.3f animations: ^{
        CGRect frame =  CGRectMake(CARD_MARGIN_LEFT, self.frame.size.height - carHeight - CARD_BOTTOM_HEIGHT + 10.0f, _size.width - 2 * CARD_MARGIN_LEFT, carHeight);
        [orderProtocolView setFrame: frame];
    }];
}

#pragma mark -
#pragma mark 加载信息核对页面
- (void)loadInfoChecked
{
    CGSize _size = [[UIScreen mainScreen] bounds].size;
    CGFloat carHeight = _size.height * 4 / 5.5;
    [cardOperateButton setTag: 0];
    [cardOperateButton setTitle: @"下一步" forState: UIControlStateNormal];
    if(!infoCheckedView)
    {
        ///1.旅程原因主视图
        infoCheckedView = [[UIView alloc] initWithFrame: CGRectMake(CARD_MARGIN_LEFT, self.frame.size.height - CARD_BOTTOM_HEIGHT + 10.0f, _size.width - 2 * CARD_MARGIN_LEFT, 0.0f)];
        [infoCheckedView setBackgroundColor: [UIColor whiteColor]];
        [infoCheckedView.layer setCornerRadius: 5.0f];
        [self insertSubview: infoCheckedView belowSubview: cardBottomView];
        
        ///2.圆点图标
        UIView *iconView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, 15.0f, 10.0f, 10.0f)];
        [iconView setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#fb1539"]];
        [iconView.layer setCornerRadius: iconView.frame.size.height / 2.0f];
        [infoCheckedView addSubview: iconView];
        
        ///3.标题
        CGFloat origin_x = iconView.frame.size.width + iconView.frame.origin.x + 5.0f;
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, infoCheckedView.frame.size.width - origin_x - 10.0f, 40.0f)];
        [titleLabel setFont: [UIFont boldSystemFontOfSize: 16.0f]];
        [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#4c4d4e"]];
        [titleLabel setText: @"填写信息"];
        [infoCheckedView addSubview: titleLabel];
        
        ///4.表格信息
        CGFloat origin_y = titleLabel.frame.size.height +titleLabel.frame.origin.y;
        UIView *tableView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, infoCheckedView.frame.size.width - 20.0f, carHeight - origin_y - 50.0f)];
        [tableView setBackgroundColor: [UIColor whiteColor]];
        [tableView.layer setCornerRadius: 4.0f];
        [tableView.layer setBorderWidth: 1.0f];
        [tableView.layer setBorderColor: [mainApplication methodOfTurnToUIColor: @"#e1e1e1"].CGColor];
        [infoCheckedView addSubview: tableView];
        
        CGFloat size_h = (tableView.frame.size.height - 5.0f) / 6.5f;
        for(NSInteger i = 0; i < 6; i++){
            //标题
            XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, (i >= 1 ? (i - 1) * (size_h + 1.0f) + 1.5f * size_h + 1.0f : 0.0f), 60.0f, (i == 0 ? 1.5f * size_h : size_h))];
            [titleLabel setTextAlignment: NSTextAlignmentCenter];
            [titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
            [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#7a7a7a"]];
            [tableView addSubview: titleLabel];
            //内容
            origin_x = titleLabel.frame.size.width + titleLabel.frame.origin.x + 5.0f;
            BOOL isShowLine = false;
            switch (i) {
                case 0:
                {
                    [titleLabel setText: @"旅行名称"];
                    XZJ_CustomLabel *contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x + 10.0f, titleLabel.frame.origin.y, tableView.frame.size.width - origin_x - 20.0f, titleLabel.frame.size.height)];
                    [contentLabel setFont: [UIFont systemFontOfSize: 14.0f]];
                    [contentLabel setNumberOfLines: 3];
                    [contentLabel setLineBreakMode: NSLineBreakByTruncatingTail];
                    [contentLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#454545"]];
                    [contentLabel setTextAlignment: NSTextAlignmentRight];
                    [contentLabel setText: [mainService serviceTitle]];
                    [tableView addSubview: contentLabel];
                    isShowLine = YES;
                    break;
                }
                case 1:
                {
                    [titleLabel setText: @"猎人信息"];
                    XZJ_CustomLabel *nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, titleLabel.frame.origin.y, tableView.frame.size.width - origin_x - 15.0f, size_h)];
                    [nameLabel setTextAlignment: NSTextAlignmentRight];
                    [nameLabel setTextColor:[mainApplication methodOfTurnToUIColor: @"#636363"]];
                    [nameLabel setFont: [UIFont systemFontOfSize: 14.0f]];
                    [nameLabel setText: [NSString stringWithFormat: @"%@ %@",[[mainService member] nickName],[[mainService member] nickName]]];
                    [tableView addSubview: nameLabel];
                    isShowLine = YES;
                    break;
                }
                case 2:
                {
                    [titleLabel setText: @"出行日期"];
                    UIButton *tempButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, titleLabel.frame.origin.y, tableView.frame.size.width - origin_x, size_h)];
                    [tempButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_arrow" ofType: @"png"]] forState: UIControlStateNormal];
                    [tempButton setImageEdgeInsets: UIEdgeInsetsMake(size_h / 2.5f, tempButton.frame.size.width - 15.0f, size_h / 2.5f, 10.0f)];
                    [tempButton addTarget: self action: @selector(openTimePicker) forControlEvents: UIControlEventTouchUpInside];
                    [tableView addSubview: tempButton];
                    isShowLine = YES;
                    //时间
                    travelTimeLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, tempButton.frame.size.width - 20.0f, tempButton.frame.size.height)];
                    [travelTimeLabel setFont: [UIFont systemFontOfSize: 14.0f]];
                    [travelTimeLabel setTextAlignment: NSTextAlignmentRight];
                    [travelTimeLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#636363"]];
                    [travelTimeLabel setText: @"请选择出行时间"];
                    [tempButton addSubview: travelTimeLabel];
                    break;
                }
                case 3:{
                    [titleLabel setText: @"预订数量"];
                    isShowLine = YES;
                    ///减号
                    origin_x = tableView.frame.size.width / 1.8f;
                    CGFloat tmpSize_h = size_h - 20.0f;
                    UIButton *reduceButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, titleLabel.frame.origin.y +  10.0f, tmpSize_h, tmpSize_h)];
                    [reduceButton setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#ef5052"]];
                    [reduceButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
                    [reduceButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_reduce" ofType: @"png"]] forState: UIControlStateNormal];
                    [reduceButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
                    [reduceButton setTag: 0];
                    [reduceButton addTarget: self action: @selector(operateNumberClick:) forControlEvents: UIControlEventTouchUpInside];
                    [tableView addSubview: reduceButton];
                    
                    ///8.人数
                    origin_y = reduceButton.frame.origin.y;
                    origin_x = reduceButton.frame.size.width + reduceButton.frame.origin.x;
                    numberTextfiled = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, origin_y, tmpSize_h, tmpSize_h)];
                    [numberTextfiled setText: @"1"];
                    [numberTextfiled setTextAlignment: NSTextAlignmentCenter];
                    [numberTextfiled setFont: [UIFont systemFontOfSize: 13.0f]];
                    [numberTextfiled setTextColor: [mainApplication methodOfTurnToUIColor: @"#323437"]];
                    [numberTextfiled.layer setBorderWidth: 0.5f];
                    [numberTextfiled.layer setBorderColor: [mainApplication methodOfTurnToUIColor: @"#ef5052"].CGColor];
                    [numberTextfiled setKeyboardType: UIKeyboardTypeNumberPad];
                    [numberTextfiled setDelegate: self];
                    [tableView addSubview: numberTextfiled];
                    
                    ///9.加号
                    origin_x = numberTextfiled.frame.size.width + numberTextfiled.frame.origin.x;
                    UIButton *addButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y , tmpSize_h, tmpSize_h)];
                    [addButton setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#ef5052"]];
                    [addButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
                    [addButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_add" ofType: @"png"]] forState: UIControlStateNormal];
                    [addButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
                    [addButton setTag: 1];
                    [addButton addTarget: self action: @selector(operateNumberClick:) forControlEvents: UIControlEventTouchUpInside];
                    [tableView addSubview: addButton];
                    break;
                }
                case 4:{
                    [titleLabel setText: @"预订价格"];
                    isShowLine = YES;
                    prePriceLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, titleLabel.frame.origin.y, tableView.frame.size.width - origin_x - 10.0f, size_h)];
                    [prePriceLabel setTextAlignment: NSTextAlignmentRight];
                    [prePriceLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#686868"]];
                    [prePriceLabel setFont: [UIFont systemFontOfSize: 14.0f]];
                    //                    [valueLabel setText: @""];
                    [prePriceLabel setText: [NSString stringWithFormat: @"$%@", [mainService unitPrice]]];
                    [tableView addSubview: prePriceLabel];
                    break;
                }
                case 5:{
                    [titleLabel setText: @"见面地点"];
                    isShowLine = NO;
                    ///
                    XZJ_CustomLabel *valueLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, titleLabel.frame.origin.y, tableView.frame.size.width - origin_x - 10.0f, size_h)];
                    [valueLabel setTextAlignment: NSTextAlignmentRight];
                    [valueLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#515151"]];
                    [valueLabel setFont: [UIFont systemFontOfSize: 14.0f]];
                    [valueLabel setText: [mainService serviceAddress]];
                    [tableView addSubview: valueLabel];
                    break;
                }
                default:
                    break;
            }
            if(isShowLine){
                UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, titleLabel.frame.size.height + titleLabel.frame.origin.y, tableView.frame.size.width, 1.0f)];
                [lineView setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#e1e1e1"]];
                [tableView addSubview: lineView];
            }
        }
    }
    [UIView animateWithDuration: 0.3f animations: ^{
        CGRect frame =  CGRectMake(CARD_MARGIN_LEFT, self.frame.size.height - carHeight - CARD_BOTTOM_HEIGHT + 10.0f, _size.width - 2 * CARD_MARGIN_LEFT, carHeight);
        [infoCheckedView setFrame: frame];
    }];
}

#pragma mark -
#pragma mark 显示预订页面
- (void)show
{
    [self setHidden: NO];
    [self loadInfoChecked];
}

#pragma mark -
#pragma mark 隐藏预订页面
- (void)dismiss
{
    [UIView animateWithDuration: 0.3f animations:  ^{
        CGRect frame = [infoCheckedView frame];
        frame.origin.y = self.frame.size.height - CARD_BOTTOM_HEIGHT + 10.0f;
        frame.size.height = 0.0f;
        [orderProtocolView setFrame: frame];
    }completion: ^(BOOL finish){
        if(finish){
            //                    [self loadOrderProtocol];
        }
    }];
}

#pragma mark -
#pragma mark textView委托
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    isEdit = YES;
    curResponser = textView;
    if([[textView text] isEqualToString: @"请输入..."]){
        [textView setText: @""];
    }
    [mainApplication methodOfResizeView: [textView tag] * 120.0f + 20.0f target: self isNavigation: NO];
}

#pragma mark -
#pragma mark textField委托
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string integerValue] <= 0 && ![string isEqualToString: @""]){
        [mainApplication methodOfShowAlert: @"出行人数不能少于1人"];
        return NO;
    }
    else{
        ////更新价格
        double price = ([string integerValue] - 1) * [[mainService addOnePrice] doubleValue] + [[mainService unitPrice] doubleValue];
        [prePriceLabel setText: [NSString stringWithFormat:@"%.2f", price]];
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    isEdit = NO;
    [curResponser resignFirstResponder];
}

#pragma mark -
#pragma mark mainMask隐藏操作
- (void)mainMaskViewClick
{
    if(!isEdit){
        [UIView animateWithDuration: 0.3f animations:  ^{
            CGRect frame = [infoCheckedView frame];
            frame.origin.y = self.frame.size.height - CARD_BOTTOM_HEIGHT + 10.0f;
            frame.size.height = 0.0f;
            if(infoCheckedView){
                [infoCheckedView setFrame: frame];
            }
            if(travelReasonView){
                [travelReasonView setFrame: frame];
            }
            if(orderProtocolView){
                [orderProtocolView setFrame: frame];
            }
        }completion: ^(BOOL finish){
            if(finish){
                [self setHidden: YES];
            }
        }];
    }
    else{
        isEdit = NO;
        [mainApplication methodOfResizeView: 0.0f target: self isNavigation: NO];
        [curResponser resignFirstResponder];
    }
}

#pragma mark -
#pragma mark 预订人数的操作事件
- (void)operateNumberClick:(UIButton *)sender
{
    NSInteger curNumber = [[numberTextfiled text] integerValue];
    switch ([sender tag]) {
        case 0:
        {
            if(curNumber > 1){
                [numberTextfiled setText: [[NSNumber numberWithInteger: --curNumber] stringValue]];
            }
            break;
        }
        case 1:
        {
            [numberTextfiled setText: [[NSNumber numberWithInteger: ++curNumber] stringValue]];
            //            if(curNumber < maxNumber){
            //
            //            }
        }
        default:
            break;
    }
    ////更新价格
    double price = ([[numberTextfiled text] integerValue] - 1) * [[mainService addOnePrice] doubleValue] + [[mainService unitPrice] doubleValue];
    [prePriceLabel setText: [NSString stringWithFormat:@"%.2f", price]];
}

#pragma mark -
#pragma mark 复选框按钮
- (void)chechedButtonClick:(UIButton *)sender
{
    [sender setSelected: ![sender isSelected]];
}

#pragma mark -
#pragma mark 打开旅程时间筛选器
- (void)openTimePicker
{
    if(!mainPickerView)
    {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity: [travelTimeArray count]];
        for(TravelTime *travelTime in travelTimeArray){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dataArray addObject: [dateFormatter stringFromDate: [travelTime startTime]]];
        }
        mainPickerView = [[XZJ_CustomPicker alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height/2.0f) dataArray: [NSArray arrayWithObject: dataArray]];
        [mainPickerView setDelegate: self];
        [self addSubview: mainPickerView];
    }
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, self.frame.size.height - self.frame.size.height/2.0f, self.frame.size.width, self.frame.size.height/2.0f));
    [mainApplication methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainPickerView, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

- (void)XZJ_CustomPicker_CancelClick:(NSInteger)tag
{
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height/2.0f));
    [mainApplication methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainPickerView, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

- (void)XZJ_CustomPicker_EnsureClick:(NSInteger)tag data:(NSArray *)data selectIndexs:(NSArray *)indexs
{
    if([data count] > 0 && [indexs count] > 0){
        [travelTimeLabel setText: [data objectAtIndex: 0]];
        TravelTime *travelTime = [travelTimeArray objectAtIndex: [[indexs objectAtIndex: 0] integerValue]];
        [appointClass setTravelTimeId: [travelTime travelTimeId]];
    }
    [self XZJ_CustomPicker_CancelClick: 0];
}

#pragma mark -
#pragma mark [下一步按钮和完成按钮]操作按钮点击事件
- (void)cardOperateButtonClick:(UIButton *)sender
{
    switch ([sender tag]) {
        case 0:
        {
            if(![appointClass travelTimeId])
            {
                [mainApplication methodOfAlterThenDisAppear: @"请选择您的出行时间"];
                break;
            }
            if([[numberTextfiled text] length] == 0)
            {
                [mainApplication methodOfAlterThenDisAppear: @"请输入您的预订数量"];
                break;
            }
            [appointClass setTravelProsonNum: [numberTextfiled text]];
            [UIView animateWithDuration: 0.3f animations:  ^{
                CGRect frame = [infoCheckedView frame];
                frame.origin.y = self.frame.size.height - CARD_BOTTOM_HEIGHT + 10.0f;
                frame.size.height = 0.0f;
                [infoCheckedView setFrame: frame];
            }completion: ^(BOOL finish){
                if(finish){
                    [self loadTravelReasonView];
                }
            }];
            break;
        }
        case 1:{
            ////填写完出行理由
            [appointClass setTravelPurpose: [purposeTextView text]];
            [appointClass setOneselfIntroduce: [introduceTextView text]];
            [UIView animateWithDuration: 0.3f animations:  ^{
                CGRect frame = [infoCheckedView frame];
                frame.origin.y = self.frame.size.height - CARD_BOTTOM_HEIGHT + 10.0f;
                frame.size.height = 0.0f;
                [travelReasonView setFrame: frame];
            }completion: ^(BOOL finish){
                if(finish){
                    [self loadOrderProtocol];
                }
            }];
            break;
        }
        case 2:{
            if([chechedButton isSelected])
            {
                ///完成预定
                [UIView animateWithDuration: 0.3f animations:  ^{
                    CGRect frame = [infoCheckedView frame];
                    frame.origin.y = self.frame.size.height - CARD_BOTTOM_HEIGHT + 10.0f;
                    frame.size.height = 0.0f;
                    [orderProtocolView setFrame: frame];
                }completion: ^(BOOL finish){
                    if(finish){
                        [self setHidden: YES];
                        if([mainApplication methodOfExistLocal: @"LOCALUSER"])
                        {
                            NSDictionary *memberDictionary = (NSDictionary *)[mainApplication methodOfReadLocal: @"LOCALUSER"];
                            [appointClass setServiceId: [mainService serviceId]];
                            [appointClass setMemberId: [memberDictionary objectForKey: @"id"]];
                            [seviceObj orderService: appointClass];
                        }
                    }
                }];
            }
            else{
                [mainApplication methodOfShowAlert: @"请先阅读并同意用户协议"];
            }
            break;
        }
        default:
            break;
    }
}
@end
