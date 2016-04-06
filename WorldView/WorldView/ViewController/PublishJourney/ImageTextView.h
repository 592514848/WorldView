//
//  ImageTextView.h
//  WorldView
//
//  Created by WorldView on 15/11/27.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_CommonClass.h"
#import "ServiceObject.h"
@class ImageTextView;
@protocol ImageTextViewDelegate <NSObject>
- (void)ImageTextView_DidBeginEditing:(NSInteger) tag view:(ImageTextView *) _view;
@end

@interface ImageTextView : UIView<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,ServiceObjectDelegate>
{
    XZJ_CustomLabel *fontNumberLabel;
    NSString *textViewText;
    UIViewController *superViewController;
     ServiceObject *serviceObj;
}
@property(nonatomic, retain) UIImageView *mainImageView;
@property(nonatomic, retain) id<ImageTextViewDelegate> xDelegate;
@property(nonatomic, retain) UITextView *contentTextView;
@property(nonatomic, retain) NSString *mainImagePath;

- (id)initWithFrame:(CGRect)frame viewController:(UIViewController *) _viewController;
- (void)hiddenKeyBoard;
@end
