//
//  AboutMeViewController.h
//  WorldView
//
//  Created by WorldView on 15/12/5.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberObject.h"

@interface AboutMeViewController : BaseViewController<UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MemberObjectDelegate>
{
    UITextView *contentTextView;
    XZJ_CustomLabel *fontNumberLabel;
    NSMutableArray *imagesArray;
    NSMutableArray *pathsArray;
    NSInteger curIndex;
    NSString *textViewText;
}
@property(nonatomic, retain) MemberObject *memberObj;
@end
