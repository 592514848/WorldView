//
//  PJStepSixViewController.m
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define STEP_IMAGEVIEW_HEIGHT 15.0F
#define MARGIN_LEFT 15.0F
#define TITLE_LABEL_HEIGHT 40.0F
#define TITLE_VALUE_HEIGHT 40.0F
#define TEXTVIEW_HEIGHT 130.0F
#define BUTTON_HEIGHT 35.0F
#define BUTTON_WIDTH 100.0F
#define COVERPHOTO_HEIGHT 120.0F
#define IMAGETEXTVIEW_HEIGHT 350.0F

#import "PJStepSixViewController.h"
#import "PJStepSevenViewController.h"

@implementation PJStepSixViewController
@synthesize serviceMainImagePath, imageTextViewArray, mainService;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"发布旅程"];
    [self loadMainView];
    ////
    serviceObj = [[ServiceObject alloc] init];
    [serviceObj setXDelegate: self];
}

- (void)loadMainView
{
    ///1.主滚动视图
    CGFloat origin_y = STEP_IMAGEVIEW_HEIGHT + 20.0f;
    mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, curScreenSize.height - origin_y)];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    [mainScrollView setDelegate: self];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [self.view addSubview: mainScrollView];
    
    ///2.服务名称
    origin_y = 0.0f;
    XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 20.0f, TITLE_LABEL_HEIGHT)];
    [titleLabel setText: @"添加封面照片："];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [mainScrollView addSubview: titleLabel];
    
    ///3.封面照片
    origin_y += TITLE_LABEL_HEIGHT;
    coverPhoto = [[UIImageView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, curScreenSize.width - 2 * MARGIN_LEFT, COVERPHOTO_HEIGHT)];
    [coverPhoto setImageWithURL: IMAGE_URL([mainService mainImageUrl]) placeholderImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"dot_line" ofType:@"png"]]];
    if([[mainService mainImageUrl] length] > 0){
        serviceMainImagePath = [mainService mainImageUrl];
        [coverPhoto setContentMode: UIViewContentModeScaleAspectFill];
        [coverPhoto.layer setMasksToBounds: YES];
    }
    [coverPhoto setUserInteractionEnabled: YES];
    [mainScrollView addSubview: coverPhoto];
    
    //4.添加按钮
    UIButton *addButton = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, BUTTON_HEIGHT, BUTTON_HEIGHT)];
    [addButton setCenter: CGPointMake(coverPhoto.frame.size.width / 2.0f, COVERPHOTO_HEIGHT / 2.0f)];
    [addButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_add_button" ofType: @"png"]] forState: UIControlStateNormal];
    [addButton setTag: 0];
    [addButton addTarget: self action: @selector(addCoverPhotoClick) forControlEvents: UIControlEventTouchUpInside];
    [coverPhoto addSubview: addButton];
    
    ///5.图文信息添加区/////////////////////////////////////////////
    //标题
    origin_y = coverPhoto.frame.size.height + coverPhoto.frame.origin.y + 10.0f;
    titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 2 * MARGIN_LEFT, TITLE_LABEL_HEIGHT)];
    [titleLabel setText: @"旅程详情照片："];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [mainScrollView addSubview: titleLabel];
    //图文内容
    imageTextViewArray = [NSMutableArray arrayWithCapacity: 5];
    origin_y += TITLE_LABEL_HEIGHT;
    ImageTextView *imageTextView = [[ImageTextView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 2 * MARGIN_LEFT, IMAGETEXTVIEW_HEIGHT) viewController: self];
    [imageTextView setTag: 0];
    [imageTextView setXDelegate: self];
    [mainScrollView addSubview: imageTextView];
    [imageTextViewArray addObject: imageTextView];
    
    /////操作区域
    origin_y += IMAGETEXTVIEW_HEIGHT + 10.0f;
    displayView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, origin_y, mainScrollView.frame.size.width, BUTTON_HEIGHT * 4.0f)];
    [mainScrollView addSubview: displayView];
    ///添加按钮
    UIButton *addImageTextViewbutton = [[UIButton alloc] initWithFrame: CGRectMake((curScreenSize.width - BUTTON_WIDTH / 4.0f) / 2.0f, 10.0f, BUTTON_WIDTH / 4.0f, BUTTON_WIDTH / 4.0f)];
    [addImageTextViewbutton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"add_location" ofType: @"png"]] forState: UIControlStateNormal];
    [addImageTextViewbutton addTarget: self action: @selector(addImageTextViewbuttonClick) forControlEvents: UIControlEventTouchUpInside];
    [displayView addSubview: addImageTextViewbutton];
    ///显示已经添加的照片
    origin_y = addImageTextViewbutton.frame.size.height + addImageTextViewbutton.frame.origin.y;
    addedImageTextViweLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, displayView.frame.size.width, BUTTON_HEIGHT / 2.0f)];
    [addedImageTextViweLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"7b7c7e"]];
    [addedImageTextViweLabel setTextAlignment: NSTextAlignmentCenter];
    [addedImageTextViweLabel setFont: [UIFont systemFontOfSize: 12.0f]];
    [addedImageTextViweLabel setText: @"增加照片：1/5"];
    [displayView addSubview: addedImageTextViweLabel];
    
    ///上一步按钮
    origin_y = addedImageTextViweLabel.frame.size.height + addedImageTextViweLabel.frame.origin.y + 10.0f;
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
    [displayView addSubview: lastStepButton];
    
    ///7.下一步按钮
    CGFloat origin_x = 2 * margin + BUTTON_WIDTH;
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [nextStepButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [nextStepButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [nextStepButton setTitle: @"下一步" forState: UIControlStateNormal];
    [nextStepButton.layer setCornerRadius: 3.0f];
    [nextStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [nextStepButton setTag: 1];
    [nextStepButton addTarget:self action: @selector(stepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [displayView addSubview: nextStepButton];
    
    ///18.调整滚动视图的contentSize
    CGFloat size_h = displayView.frame.size.height + displayView.frame.origin.y + 20.0f;
    size_h = (size_h > curScreenSize.height ? size_h : curScreenSize.height + 20.0f);
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, size_h)];
    
    ///19.编辑的时候的数据
    if([mainService detailImgDesc]){
        NSString *responsedString = [[mainService detailImgDesc] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *imageTextArray = [responsedString objectFromJSONStringWithParseOptions: JKParseOptionLooseUnicode];
        if([imageTextArray count] > 0){
            NSDictionary *tempDictionary = [imageTextArray objectAtIndex: 0];
            [imageTextView.mainImageView setContentMode: UIViewContentModeScaleAspectFill];
            [imageTextView.mainImageView.layer setMasksToBounds: YES];
            [imageTextView.mainImageView setImageWithURL: IMAGE_URL([tempDictionary objectForKey: @"url"])];
            [imageTextView.contentTextView setText: [tempDictionary objectForKey: @"desc"]];
        }
        for(NSInteger i = 1; i < [imageTextArray count]; i++){
            [self addImageTextViewbuttonClick];
        }
    }
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

#pragma mark -
#pragma mark 添加封面照片
- (void)addCoverPhotoClick
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
    [coverPhoto setContentMode: UIViewContentModeScaleAspectFill];
    [coverPhoto.layer setMasksToBounds: YES];
    [coverPhoto setImage: image];
    //上传图片
    NSData *imageData;
    NSString *imageName = nil;
    if (UIImagePNGRepresentation(image))
    {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(image);
        imageName = @"servie.png";
    }
    else
    {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(image, 1.0);
        imageName = @"servie.jpg";
    }
    [serviceObj uploadFile: imageData fileName: imageName];
}

#pragma mark -
#pragma mark serviceObject上传图片的返回结果
- (void)serviceObject_UploadFileSuccess:(BOOL)success imagePath:(NSString *)imagePath
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"图片上传成功"];
        serviceMainImagePath = imagePath;
    }
    else{
        [applicationClass methodOfShowAlert: @"图片上传失败，请稍候重试"];
    }
}

#pragma mark -
#pragma mark imagePicker委托方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated: YES completion: nil];
}

- (void)ImageTextView_DidBeginEditing:(NSInteger)tag view:(id)_view
{
    [mainScrollView setContentOffset: CGPointMake(0.0f, (tag + 1) * IMAGETEXTVIEW_HEIGHT)];
    curImageTextView = _view;
}

#pragma mark -
#pragma mark 添加图文描述视图
- (void)addImageTextViewbuttonClick
{
    if([imageTextViewArray count] < 5)
    {
        ImageTextView *lastImageTextView = [imageTextViewArray lastObject];
        ///添加一个新的
        CGFloat origin_y = lastImageTextView.frame.size.height + lastImageTextView.frame.origin.y + 5.0f;
        ImageTextView *imageTextView = [[ImageTextView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 2 * MARGIN_LEFT, IMAGETEXTVIEW_HEIGHT) viewController: self];
        [imageTextView setTag: [imageTextViewArray count]];
        [imageTextView setXDelegate: self];
        [mainScrollView addSubview: imageTextView];
        
        ///调整操作区域的位置
        CGRect frame = [displayView frame];
        frame.origin.y = imageTextView.frame.origin.y + IMAGETEXTVIEW_HEIGHT + 10.0f;
        [displayView setFrame: frame];
        [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, frame.origin.y + frame.size.height)];
        ///
        NSString *responsedString = [[mainService detailImgDesc] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *imageTextArray = [responsedString objectFromJSONStringWithParseOptions: JKParseOptionLooseUnicode];
        if([imageTextArray count] > [imageTextViewArray count]){
            NSDictionary *tempDictionary = [imageTextArray objectAtIndex: [imageTextViewArray count]];
            [imageTextView.mainImageView setContentMode: UIViewContentModeScaleAspectFill];
            [imageTextView.mainImageView.layer setMasksToBounds: YES];
            [imageTextView.mainImageView setImageWithURL: IMAGE_URL([tempDictionary objectForKey: @"url"])];
            [imageTextView.contentTextView setText: [tempDictionary objectForKey: @"desc"]];
        }
        [imageTextViewArray addObject: imageTextView];
        ///设置已经添加的照片
        [addedImageTextViweLabel setText: [NSString stringWithFormat: @"增加照片：%ld/5", (long)[imageTextViewArray count]]];
    }
    else{
        [applicationClass methodOfShowAlert: @"您好，旅程详情最多只能添加5张图片"];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [curImageTextView hiddenKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
