//
//  PJStepSixViewController.h
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageTextView.h"
#import "ServiceObject.h"

@interface PJStepSixViewController : BaseViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImageTextViewDelegate, UIScrollViewDelegate, ServiceObjectDelegate>
{
    UIImageView *coverPhoto;
    UIScrollView *mainScrollView;
    UIView *displayView;
    XZJ_CustomLabel *addedImageTextViweLabel;
    ServiceObject *serviceObj;
    ImageTextView *curImageTextView;
}
@property(nonatomic) ServiceClass *mainService;
@property(nonatomic, retain) NSString *serviceMainImagePath;
@property(nonatomic, retain) NSMutableArray *imageTextViewArray;
@end
