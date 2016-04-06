//
//  BHStepFourViewController.h
//  WorldView
//
//  Created by WorldView on 15/12/1.
//  Copyright © 2015年 XZJ. All rights reserved.
//

typedef enum {
    kPassport_Type = 1,
    kIdCard_type = 2,
    kDrivingLicense_Type = 3,
    kTourGuide_Type = 4,
    kStuCard_Type = 5,
    kWorkCertificate_Type = 6
    
}Upload_Type;
#import "BaseViewController.h"
#import "MemberObject.h"
@interface BHStepFourViewController : BaseViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MemberObjectDelegate>
{
    UIImageView *cardImageView;
    MemberObject *memberObj;
}
@property(nonatomic) Upload_Type uploadType;
@property(nonatomic, retain) CertificateClass *certificate;
@end
