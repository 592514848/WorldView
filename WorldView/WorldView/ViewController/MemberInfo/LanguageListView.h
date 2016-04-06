//
//  LanguageListView.h
//  WorldView
//
//  Created by WorldView on 15/11/21.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_CommonClass.h"
#import "LanguageClass.h"

@protocol LanguageListView_Delegate <NSObject>
@optional
-(void)languageListView_EnsureClick:(NSArray *) _dataArray;
@end

@interface LanguageListView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *dataArray;
    XZJ_ApplicationClass *applicationClass;
    NSMutableArray *selectedArray;
}
@property(nonatomic, retain) id<LanguageListView_Delegate> xDelegate;
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *) _dataArray;
- (void)animateDisappear;
- (void)animateShow;
@end
