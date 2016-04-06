//
//  AppointmentViewController.h
//  WorldView
//
//  Created by XZJ on 11/10/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceObject.h"
#import "AppointMainView.h"
#import "AppointEvalutionView.h"
#import "AppointRecommonView.h"
#import "AppointHunterServiceView.h"
#import "AppointMeetingPlaceView.h"
#import "AppointTravelDetailsView.h"
#import "AppointHunterInfoView.h"
#import "SendMessageViewController.h"

@interface AppointmentViewController : BaseViewController<UITextFieldDelegate, UITextViewDelegate, ServiceObjectDelegate>
{
    UIScrollView *mainScrollView;
    AppointHunterInfoView *mainHunterInfoView;
    AppointTravelDetailsView *mainTravelDetailsView;
    AppointMeetingPlaceView *mainMeetingPlaceView;
    AppointEvalutionView *mainEvalutionView;
    AppointRecommonView *mainRecommonView;
    AppointHunterServiceView *mainHunterServiceView;
    AppointMainView *mainAppointView;
    id curResponser;
    BOOL isEdit;
    ServiceObject *serviceObj;
    ServiceClass *mainService;
}
@property(nonatomic, retain) NSString *serviceID;
@end
