//
//  AboutMeViewController.m
//  WorldView
//
//  Created by WorldView on 15/12/5.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define IMAGE_HEIGHT 120.0f
#define ADDIMAGE_HEIGHT 30.0f
#define TEXTVIEW_HEIGHT 120.0f
#import "AboutMeViewController.h"
@implementation AboutMeViewController
@synthesize memberObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    if(memberObj)
        [memberObj setXDelegate: self];
    [self loadNaviagationRight];
    [self loadMainView];
}

#pragma mark -
#pragma mark 加载确定按钮
- (void)loadNaviagationRight
{
    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT)];
    [button setTitle: @"完成" forState: UIControlStateNormal];
    [button setTitleColor: [applicationClass methodOfTurnToUIColor: @"#5495fc"]forState: UIControlStateNormal];
    [button.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
    [button addTarget: self action: @selector(confirmButtonClick) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView: button];
    [self.navigationItem setRightBarButtonItem: rightBarButton];
}

#pragma mark -
#pragma mark 主视图
- (void)loadMainView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [mainScrollView setBackgroundColor: [UIColor whiteColor]];
    [self.view addSubview: mainScrollView];
    ///1.标题
    CGFloat origin_y = 20.0f;
    XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, mainScrollView.frame.size.width - 20.0f, 25.0f)];
    [titleLabel setText: @"添加照片："];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [mainScrollView addSubview: titleLabel];
    
    ///2.图片上传区域
    origin_y += titleLabel.frame.size.height;
    imagesArray = [NSMutableArray arrayWithCapacity: 3];
    pathsArray = [NSMutableArray arrayWithCapacity: 3];
    NSArray *memberAboutImageUrl = [[memberObj aboutMeImgUrl] componentsSeparatedByString: @","];
    for(NSInteger i = 0; i < 3; i++){
        ///添加按钮
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame: CGRectMake((curScreenSize.width - ADDIMAGE_HEIGHT) / 2.0f, origin_y + i * (IMAGE_HEIGHT + 10.0f) + (IMAGE_HEIGHT - ADDIMAGE_HEIGHT) / 2.0f, ADDIMAGE_HEIGHT, ADDIMAGE_HEIGHT)];
        [addImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_add_button" ofType: @"png"]]];
        [mainScrollView addSubview: addImageView];
        ///图片主视图
        UIImageView *mainImageView = [[UIImageView alloc] initWithFrame: CGRectMake(15.0f, origin_y + i * (IMAGE_HEIGHT + 10.0f), curScreenSize.width - 30.0f, IMAGE_HEIGHT)];
        [mainImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"dot_line" ofType:@"png"]]];
        [mainImageView setUserInteractionEnabled: YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(addPhotoClick:)];
        [mainImageView setUserInteractionEnabled: YES];
        [mainImageView addGestureRecognizer: tap];
        [mainImageView setTag: i];
        [mainScrollView addSubview: mainImageView];
        [imagesArray addObject: mainImageView];
        [pathsArray addObject: @""];
        if([memberAboutImageUrl count] > i){
            if([[memberAboutImageUrl objectAtIndex: i] length] > 0){
                [mainImageView setImageWithURL: IMAGE_URL([memberAboutImageUrl objectAtIndex: i])];
                [mainImageView setContentMode: UIViewContentModeScaleAspectFill];
                [mainImageView.layer setMasksToBounds: YES];
                [pathsArray setObject: [memberAboutImageUrl objectAtIndex: i] atIndexedSubscript: i];
            }
        }
    }
    
    ///3.描述输入框
    origin_y += 3 * (IMAGE_HEIGHT + 10.0f);
    titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, mainScrollView.frame.size.width - 20.0f, 25.0f)];
    [titleLabel setText: @"添加描述："];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [mainScrollView addSubview: titleLabel];
    
    ///4.输入框
    origin_y += titleLabel.frame.size.height;
    contentTextView = [[UITextView alloc] initWithFrame: CGRectMake(10.0f,origin_y, curScreenSize.width - 20.0f, TEXTVIEW_HEIGHT)];
    [contentTextView setDelegate: self];
    [contentTextView setFont: [UIFont systemFontOfSize: 14.0F]];
    [contentTextView setTextColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b2b3b4"]];
    if([[memberObj aboutMeImgDesc] length] > 0){
        [contentTextView setText: [memberObj aboutMeImgDesc]];
    }
    else
        [contentTextView setText: @"请添加描述..."];
    [contentTextView.layer setBorderColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b2b3b4"].CGColor];
    [contentTextView.layer setBorderWidth: 0.5f];
    [contentTextView.layer setCornerRadius: 3.0f];
    [mainScrollView addSubview: contentTextView];
    
    ///4.字数
    origin_y += TEXTVIEW_HEIGHT;
    fontNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y,curScreenSize.width - 20.0f, 20.0f)];
    [fontNumberLabel setFont: [UIFont systemFontOfSize: 12.0f]];
    [fontNumberLabel setTextAlignment: NSTextAlignmentRight];
    [fontNumberLabel setText: @"您还可以输入300个字"];
    [fontNumberLabel setTextColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b5b6b7"]];
    [mainScrollView addSubview: fontNumberLabel];
    
    ///调整滚动视图
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, origin_y + fontNumberLabel.frame.size.height + 20.0f)];
}

#pragma mark -
#pragma mark 添加照片
- (void)addPhotoClick:(UITapGestureRecognizer *)sender
{
    curIndex = [sender.view tag];
    //上传图片
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"请选择上传方式" delegate: self cancelButtonTitle: @"取消" destructiveButtonTitle: nil otherButtonTitles: @"拍照", @"打开相册", nil];
    [actionSheet showInView: [[UIApplication sharedApplication] keyWindow]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                [imagePickerController setSourceType: UIImagePickerControllerSourceTypeCamera];
                [imagePickerController setDelegate: self];
                [imagePickerController setAllowsEditing: YES];
                [imagePickerController.navigationBar setTintColor: [[XZJ_ApplicationClass commonApplication] themeColor]];
                [imagePickerController setCameraDevice: UIImagePickerControllerCameraDeviceFront];
                [self presentViewController: imagePickerController animated: YES completion: nil];
            }
            else
                [[XZJ_ApplicationClass commonApplication] methodOfShowAlert: @"对不起，您的设备不支持拍照"];
            break;
        }
        case 1:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            [imagePickerController setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePickerController setDelegate: self];
            [imagePickerController setAllowsEditing: YES];
            [imagePickerController.navigationBar setTintColor: [[XZJ_ApplicationClass commonApplication] themeColor]];
            [self presentViewController: imagePickerController animated: YES completion: nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark 获取相册的委托方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    UIImageView *mainImageView = [imagesArray objectAtIndex: curIndex];
    [mainImageView setContentMode: UIViewContentModeScaleAspectFill];
    [mainImageView.layer setMasksToBounds: YES];
    [mainImageView setImage: image];
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
    [memberObj uploadFile: imageData fileName: imageName];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated: YES completion: nil];
}

- (void)MemberObject_UploadPhotoSuccess:(BOOL)success imagePath:(NSString *)imagePath
{
    if(success)
        [pathsArray setObject: imagePath atIndexedSubscript: curIndex];
    else{
        [applicationClass methodOfAlterThenDisAppear: @"图片上传失败，请重试"];
    }
}

#pragma mark -
#pragma mark textView委托事件
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([[textView text] isEqualToString: @"请添加描述..."]){
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
#pragma mark 完成按钮的点击
- (void)confirmButtonClick
{
    [memberObj setAboutMeImgDesc: [contentTextView text]];
    [memberObj setAboutMeImgUrl: [pathsArray componentsJoinedByString: @","]];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
