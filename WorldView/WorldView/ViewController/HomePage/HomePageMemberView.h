//
//  HomePageMemberView.h
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@protocol HomePageMemberViewDelegate <NSObject>
- (void)homePageMemberView_WillDisplay:(NSIndexPath *) indexPath;
@end

@interface HomePageMemberView : UIScrollView<UITableViewDataSource, UITableViewDelegate>
{
    XZJ_ApplicationClass *applicationClass;
    UIViewController<HomePageMemberViewDelegate> *xDelegate;
    BOOL isHunter;
    BOOL isMale;
    UIImageView *photoImageView;
    NSDictionary *memberDictionary;
    UIImageView *roleImageView;
    UITableView *mainTableView;
    XZJ_CustomLabel *nameLabel;
    UIImageView *publishTravelImageView;
    UIImageView *signIconImageView;
    XZJ_CustomLabel *signLabel;
}

- (id)initWithFrame:(CGRect)frame delegate:(UIViewController<HomePageMemberViewDelegate> *) _delegate;
- (void)updateMemberInfo;
@end
