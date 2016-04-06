//
//  PublishJourneyViewController.h
//  WorldView
//
//  Created by WorldView on 15/11/25.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "PagerViewController.h"
#import "ServiceObject.h"
@interface PublishJourneyViewController : PagerViewController<PagerViewDataSource, PagerViewDelegate, ServiceObjectDelegate>
@property (nonatomic, retain) ServiceClass *mainService;
@end
