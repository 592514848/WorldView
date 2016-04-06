//
//  RootViewNavigationController.h
//  WorldView
//
//  Created by XZJ on 10/28/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewController.h"

@interface RootViewNavigationController : UINavigationController<UIGestureRecognizerDelegate>
{
    CGPoint startTouch;//拖动时的开始坐标
    BOOL isMoving;//是否在拖动中
    UIView *blackMask;//那层黑面罩
    UIImageView *lastScreenShotView;//截图
}

@property (nonatomic,retain) UIView *backgroundView;//背景
@property (nonatomic,retain) NSMutableArray *screenShotsList;//存截图的数组

@end
