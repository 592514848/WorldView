//
//  BHStepFourViewController.m
//  WorldView
//
//  Created by WorldView on 15/12/1.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define BUTTON_HEIGHT 80.0f
#import "BHStepFourViewController.h"
@implementation BHStepFourViewController
@synthesize uploadType, certificate;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    ///
    memberObj = [[MemberObject alloc] init];
    [memberObj setXDelegate: self];
    [memberObj setMemberId: [memberDictionary objectForKey: @"id"]];
}

- (void)loadMainView
{
    [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#5b5c5d"]];
    UIView *mainView = [[UIView alloc] initWithFrame: CGRectMake(20.0f, 20.0f, curScreenSize.width - 40.0f, curScreenSize.height * 2.0f / 3.0f)];
    [mainView setBackgroundColor: [UIColor whiteColor]];
    [mainView.layer setCornerRadius: 5.0f];
    [self.view addSubview: mainView];
    ///
    cardImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, 10.0f, mainView.frame.size.width - 20.0f, mainView.frame.size.height - 120.0f)];
    [cardImageView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ecedee"]];
    if(certificate){
        [cardImageView setImageWithURL: IMAGE_URL([certificate imagePath]) placeholderImage: [UIImage imageNamed: @"default.png"]];
    }
    else
        [cardImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"card_default" ofType:@"jpg"]]];
    [cardImageView.layer setCornerRadius: 5.0f];
    [cardImageView.layer setMasksToBounds: YES];
    [cardImageView setContentMode: UIViewContentModeScaleAspectFit];
    [mainView addSubview: cardImageView];
    ///
    CGFloat origin_y = cardImageView.frame.size.height + cardImageView.frame.origin.y + 10.0f;
    XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, mainView.frame.size.width - 20.0f, 20.0f)];
    [titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
    [titleLabel setTextAlignment: NSTextAlignmentCenter];
    [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#484749"]];
    [titleLabel setText: @"图片规范"];
    [mainView addSubview: titleLabel];
    ///
    origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y + 5.0f;
    XZJ_CustomLabel *contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, mainView.frame.size.width - 20.0f, mainView.frame.size.height - origin_y - 20.0f)];
    [contentLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [contentLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#5c5c5d"]];
    NSString *contentStr = @"护照";
    switch (uploadType) {
        case 2:
            contentStr = @"身份证";
            break;
        case 3:
            contentStr = @"驾照";
            break;
        case 4:
            contentStr = @"导游证";
            break;
        case 5:
            contentStr = @"学生证";
            break;
        case 6:
            contentStr = @"工作证明";
            break;
        default:
            break;
    }
    [contentLabel setText: [NSString stringWithFormat: @"如上图所示，请上传您的%@照片（展示您的上半身并手持%@）确保%@号码清晰", contentStr,contentStr, contentStr]];
    [contentLabel setNumberOfLines: 0];
    [contentLabel setLineBreakMode: NSLineBreakByCharWrapping];
    [mainView addSubview: contentLabel];
    
    ///上传图片按钮
    UIButton *uploadButton = [[UIButton alloc] initWithFrame: CGRectMake((curScreenSize.width - BUTTON_HEIGHT) / 2.0f, curScreenSize.height - BUTTON_HEIGHT - 40.0f, BUTTON_HEIGHT, BUTTON_HEIGHT)];
    [uploadButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"upload_card" ofType:@"png"]] forState: UIControlStateNormal];
    [uploadButton addTarget: self action: @selector(uploadButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: uploadButton];
}

#pragma mark -
#pragma mark 上传证件
- (void)uploadButtonClick
{
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
            break;
    }
}

#pragma mark -
#pragma mark 获取相册的委托方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    [cardImageView setImage: image];
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

- (void)MemberObject_UploadPhotoSuccess:(BOOL)success imagePath:(NSString *)imagePath
{
    if(success){
        if(!certificate){
            certificate = [[CertificateClass alloc] init];
            [certificate setCertificateType: [NSString stringWithFormat: @"%ld", (long)uploadType]];
        }
        [certificate setImagePath: imagePath];
        [memberObj uploadCertificate: certificate];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"证件上传失败，请稍候再试"];
    }
}

- (void)MemberObject_DidUploadCertificate:(BOOL)success certificate:(CertificateClass *)_certificate
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"证件上传成功"];
        certificate = _certificate;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
