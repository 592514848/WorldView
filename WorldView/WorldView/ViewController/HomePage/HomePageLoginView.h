//
//  HomePageLoginView.h
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "WXApi.h"

@protocol HomePageLoginViewDelegate <NSObject>
- (void)homePageLoginView_DidClick:(NSInteger) index;
@end

@interface HomePageLoginView : UIView
{
    XZJ_ApplicationClass *applicationClass;
    UIViewController<HomePageLoginViewDelegate> *viewControllerSender;
}
@property(nonatomic, copy) void(^weChatLogin)();
- (id)initWithFrame:(CGRect)frame sender:(UIViewController *)_sender;
@end
