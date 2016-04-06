//
//  HunterInfoViewController.h
//  WorldView
//
//  Created by WorldView on 15/12/3.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "HunterMainInfoView.h"
#import "MemberObject.h"
#import "AppointHunterServiceView.h"

@interface HunterInfoViewController : BaseViewController<MemberObjectDelegate>
{
    UIScrollView *mainScrollView;
    HunterMainInfoView *mainHunterInfoView;
    MemberObject *memberObj;
    AppointHunterServiceView *mainHunterOtherServiceView;
}
@property(nonatomic, retain) NSString *hunterId;
@property(nonatomic, retain) ServiceClass *mainService;
@end
