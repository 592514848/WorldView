//
//  ImageTextView.m
//  WorldView
//
//  Created by WorldView on 15/11/27.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define ADDIMAGE_HEIGHT 35.0F
#import "ImageTextView.h"

@implementation ImageTextView
@synthesize mainImageView, xDelegate, mainImagePath, contentTextView;
- (id)initWithFrame:(CGRect)frame viewController:(UIViewController *) _viewController
{
    self = [super initWithFrame: frame];
    if(self){
        superViewController = _viewController;
        CGFloat size_h = (frame.size.width - 40.0f) / 2.0f;
        serviceObj = [[ServiceObject alloc] init];
        [serviceObj setXDelegate: self];
        ///1.添加按钮
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, ADDIMAGE_HEIGHT, ADDIMAGE_HEIGHT)];
        [addImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_add_button" ofType: @"png"]]];
        [addImageView setCenter: CGPointMake(frame.size.width / 2.0f, size_h / 2.0f)];
        [self addSubview: addImageView];
        
        ///2.图片主视图
        mainImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 10.0f, frame.size.width, size_h)];
        [mainImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"dot_line" ofType:@"png"]]];
        [mainImageView setUserInteractionEnabled: YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(addPhotoClick)];
        [mainImageView setUserInteractionEnabled: YES];
        [mainImageView addGestureRecognizer: tap];
        [self addSubview: mainImageView];
        
        ///3.输入框
        CGFloat origin_y = mainImageView.frame.origin.y + size_h + 10.0f;
        contentTextView = [[UITextView alloc] initWithFrame: CGRectMake(0.0f,origin_y, frame.size.width, size_h)];
        [contentTextView setDelegate: self];
        [contentTextView setFont: [UIFont systemFontOfSize: 14.0F]];
        [contentTextView setTextColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b2b3b4"]];
        [contentTextView setText: @"请添加描述..."];
        [contentTextView.layer setBorderColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b2b3b4"].CGColor];
        [contentTextView.layer setBorderWidth: 0.5f];
        [contentTextView.layer setCornerRadius: 3.0f];
        [self addSubview: contentTextView];
        
        ///4.字数
        origin_y += size_h;
        fontNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y,frame.size.width, 20.0f)];
        [fontNumberLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [fontNumberLabel setTextAlignment: NSTextAlignmentRight];
        [fontNumberLabel setText: @"您还可以输入300个字"];
        [fontNumberLabel setTextColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b5b6b7"]];
        [self addSubview: fontNumberLabel];
    }
    return self;
}

#pragma mark -
#pragma mark textView委托事件
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([[textView text] isEqualToString: @"请添加描述..."]){
        [textView setText: @""];
    }
    if([xDelegate respondsToSelector: @selector(ImageTextView_DidBeginEditing:view:)]){
        [xDelegate ImageTextView_DidBeginEditing: [self tag] view: self];
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
#pragma mark 添加照片
- (void)addPhotoClick
{
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
                [superViewController presentViewController: imagePickerController animated: YES completion: nil];
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
            [superViewController presentViewController: imagePickerController animated: YES completion: nil];
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
    [serviceObj uploadFile: imageData fileName: imageName];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark -
#pragma mark serviceObject上传图片的返回结果
- (void)serviceObject_UploadFileSuccess:(BOOL)success imagePath:(NSString *)imagePath
{
    if(success){
        [[XZJ_ApplicationClass commonApplication] methodOfAlterThenDisAppear: @"图片上传成功"];
        mainImagePath = imagePath;
    }
    else{
        [[XZJ_ApplicationClass commonApplication] methodOfShowAlert: @"图片上传失败，请稍候重试"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [contentTextView resignFirstResponder];
}

#pragma mark - 隐藏键盘
- (void)hiddenKeyBoard
{
    [contentTextView resignFirstResponder];
}
@end
