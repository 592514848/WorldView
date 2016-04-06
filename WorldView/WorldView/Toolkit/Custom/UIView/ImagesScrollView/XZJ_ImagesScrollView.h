//
//  XZJ_ImagesScrollView_One.h
//  GRDApplication
//
//  Created by 6602 on 14-1-1.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_CommonClass.h"
#import "XZJ_PageControl.h"

@protocol XZJ_ImagesScrollViewDelegate <NSObject>
@optional
- (void)XZJ_ImagesScrollViewDidClicked: (NSUInteger)index; //图片点击时的委托
- (void)XZJ_ImagesScrollViewCurrentPage:(NSInteger) curPage; //当前页码
@end

@interface XZJ_ImagesScrollView : UIView <UIScrollViewDelegate>
{
    CGRect viewSize;//滚动视图的矩形区域
    UIScrollView *scrollview;//滚动视图
    NSMutableArray *imagesArray;//存放图片的数组
    NSArray *titleArray;//存放标题的数组
    XZJ_PageControl *pageControl;//分页控件
    id<XZJ_ImagesScrollViewDelegate> delegate;//委托对象
    int currentPageIndex;//当前view（图片）的下标
    UILabel *noteTitle;//显示标题的Label
    UIView *noteView; //添加存放标题和分页控件的view
    NSInteger scrollPoint; //滚动指针(指示现在滚动到什么地方)
    NSMutableArray *imageViewArray; //已经加载的imageView
    
    CGFloat lastScale;
}

@property(nonatomic,retain) id<XZJ_ImagesScrollViewDelegate> delegate;
@property(nonatomic,retain) UIView *noteView;
@property(nonatomic,retain) XZJ_PageControl *pageControl;//分页控件
@property(nonatomic,retain)  UILabel *noteTitle;

- (id)initWith:(CGRect) rect ImagesArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr; //初始化函数
- (id)initWith:(CGRect) rect ImagesArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr isURL:(BOOL) isURL; //使用URL加载图片的初始化函数
- (void)autoScrollImage:(NSTimeInterval)interval;//定时自动播放
- (void)setImageViewContentMode:(UIViewContentMode) contentMode; //调整图片的显示模式
- (void)setImageWithURLArray:(NSArray *) imageURLArray;
@end
