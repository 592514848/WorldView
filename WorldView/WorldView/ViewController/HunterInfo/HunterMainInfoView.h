//
//  HunterMainInfoView.h
//  WorldView
//
//  Created by WorldView on 15/12/3.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "ServiceClass.h"

@interface HunterMainInfoView : UIView
{
    XZJ_ApplicationClass *mainApplication;
    UIImageView *topImageView;
    UIImageView *photoImageView;
    XZJ_CustomLabel *memberNameLabel;
    XZJ_CustomLabel *introduceLabel;
    XZJ_ImagesScrollView *intriduceImageScrollView;
    XZJ_CustomLabel *contentLabel;
}
- (void)updateMainView:(MemberObject *) memberObj;
@end
