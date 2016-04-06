//
//  XZJ_ImagesScrollView_One.m
//  GRDApplication
//
//  Created by 6602 on 14-1-1.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import "XZJ_ImagesScrollView.h"

@implementation XZJ_ImagesScrollView
@synthesize delegate,noteView,noteTitle,pageControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark 使用URL加载图片的初始化函数
- (id)initWith:(CGRect) rect ImagesArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr isURL:(BOOL) isURL
{
    if(self = [super initWithFrame: rect])
    {
        /*------初始化基本数据---------*/
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray: imgArr];
        /*------初始化滚动视图---------*/
        viewSize = rect;
        scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        [scrollview setPagingEnabled: YES];
        [scrollview setShowsHorizontalScrollIndicator: NO];
        [scrollview setShowsVerticalScrollIndicator: NO];
        [scrollview setScrollsToTop: NO];
        [scrollview setDelegate: self];
        [self addSubview: scrollview];
        
        NSUInteger pageCount = 3;
        if(tempArray.count > 0)
        {
            [tempArray insertObject: [imgArr objectAtIndex:[imgArr count] - 1] atIndex:0];//在第一个位置插入第一张图片(增加滑动的显示效果)
            [tempArray addObject:[imgArr objectAtIndex: 0]];//在最后一个位置添加第一张图片(增加滑动的显示效果)
            imagesArray = [[NSMutableArray alloc] initWithArray: tempArray];
            pageCount = [imagesArray count];
            [scrollview setContentSize: CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height)];
            imageViewArray = [NSMutableArray arrayWithCapacity: pageCount];
            /*------在滚动视图中加入图片---------*/
            for(int i = 0; i < pageCount; i++)
            {
                UIImageView *imgView = [[UIImageView alloc] init];
                if(isURL)
                     [imgView setImageWithURL: [imagesArray objectAtIndex: i] placeholderImage: [UIImage imageNamed: @"default.png"]];
                else
                {
                    UIImage *tempImage= [UIImage imageWithData: [imagesArray objectAtIndex: i]];
                    if(tempImage == nil)
                        tempImage = [UIImage imageNamed: @"default.png"];
                    [imgView setImage: tempImage];
                }
                [imgView setFrame: CGRectMake(viewSize.size.width*i, 0, viewSize.size.width, viewSize.size.height)];
                [imgView.layer setMasksToBounds: YES];
                if(i == 0 || i == 1){
                    [imgView setTag: 0];
                }
                else if(i == pageCount - 1){
                    [imgView setTag: pageCount - 3];
                }
                else
                    [imgView setTag: i - 1];
                /*-----给每张图片添加点击手势-----*/
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(imgPressed:)];
                [tapGesture setNumberOfTapsRequired: 1];
                [tapGesture setNumberOfTouchesRequired:1];
                [imgView setUserInteractionEnabled: YES];
                [imgView addGestureRecognizer: tapGesture];
                [imgView setContentMode: UIViewContentModeScaleAspectFill];
                [imgView.layer setMasksToBounds: YES];
                [scrollview addSubview: imgView];
                [imageViewArray addObject: imgView];
            }
        }
        else
        {
            imagesArray = [[NSMutableArray alloc] initWithObjects:@"default.png", nil];
            imageViewArray = [NSMutableArray array];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, viewSize.size.width, viewSize.size.height)];
            [imgView setImage: [UIImage imageNamed: @"default.png"]];
            [imgView setContentMode: UIViewContentModeScaleAspectFill];
            [imgView.layer setMasksToBounds: YES];
            [scrollview addSubview: imgView];
            [imageViewArray addObject: imgView];
        }
        /*------添加存放标题和分页控件的view---------*/
        noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-viewSize.size.height/6.0f,self.bounds.size.width,viewSize.size.height/6.0f)];
        [noteView setHidden: YES];
        [noteView setBackgroundColor: [[UIColor alloc] initWithWhite: 0.0f alpha: 0.5f]];
        /*------添加分页控件---------*/
        float pageControlWidth=(pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=noteView.frame.size.height/4.0f;
        pageControl=[[XZJ_PageControl alloc]initWithFrame:CGRectMake((self.frame.size.width - pageControlWidth) / 2.0f, self.frame.size.height - pagecontrolHeight - 5.0f,pageControlWidth,pagecontrolHeight)];
        pageControl.center = CGPointMake(rect.size.width/2, self.frame.size.height - pagecontrolHeight - 5.0f);
        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        [self addSubview:pageControl];
        /*------添加图片的标题---------*/
        if(titArr != nil)
        {
            titleArray = [NSArray arrayWithArray: titArr];
            noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, self.frame.size.width-pageControlWidth-15.0f, noteView.frame.size.height)];
            [noteTitle setText:[titleArray objectAtIndex:0]];
            [noteTitle setBackgroundColor:[UIColor clearColor]];
            [noteTitle setTextColor: [UIColor whiteColor]];
            [noteTitle setFont:[UIFont boldSystemFontOfSize:14]];
            [noteView addSubview:noteTitle];
        }
        [self insertSubview: noteView belowSubview: pageControl];
    }
    return  self;
}

#pragma mark -
#pragma mark 自定义初始化函数
- (id)initWith:(CGRect)rect ImagesArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr
{
    return [self initWith: rect ImagesArray: imgArr TitleArray: titArr isURL:NO];
}

#pragma mark -
#pragma mark [Scrollview的委托方法]
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGFloat pageWith = scrollview.frame.size.width;
    int page = floor((scrollview.contentOffset.x - pageWith / 2) /pageWith) + 1;
    currentPageIndex = page;
    pageControl.currentPage = (page - 1);
    if(titleArray.count > 0)
    {
        long titleIndex=page-1;
        if (titleIndex==[titleArray count]) {
            titleIndex=0;
        }
        if (titleIndex<0) {
            titleIndex=[titleArray count]-1;
        }
        [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    /*--当超出第一张图片时，显示最后一张--*/
    NSInteger tmpPageIndex = currentPageIndex;
    if(currentPageIndex == 0)
    {
        [_scrollView setContentOffset: CGPointMake(([imagesArray count] - 2)*viewSize.size.width, 0)];
        tmpPageIndex = [imagesArray count] - 2;
    }
    /*--当超出最后一张图片时，显示第一张--*/
    if(currentPageIndex == [imagesArray count] - 1)
    {
        [_scrollView setContentOffset: CGPointMake(viewSize.size.width, 0)];
        tmpPageIndex = 1;
    }
    if([delegate respondsToSelector: @selector(XZJ_ImagesScrollViewCurrentPage:)])
        [delegate XZJ_ImagesScrollViewCurrentPage: tmpPageIndex];
}

#pragma mark -
#pragma mark 点击图片时的执行方法
- (void)imgPressed:(UITapGestureRecognizer *)sender
{
    if([delegate respondsToSelector: @selector(XZJ_ImagesScrollViewDidClicked:)])
    {
        [delegate XZJ_ImagesScrollViewDidClicked: sender.view.tag];
    }
}

#pragma mark -
#pragma mark 自动播放
- (void)autoScrollImage:(NSTimeInterval)interval
{
    scrollPoint = currentPageIndex;
    [NSTimer scheduledTimerWithTimeInterval: interval target:self selector: @selector(autoChangeScrollView) userInfo:nil repeats:YES];
}

#pragma mark -
#pragma mark 按比例显示图片
- (void)setImageViewContentMode:(UIViewContentMode) contentMode
{
    for(NSInteger i = 0; i < [imageViewArray count]; i++)
    {
        UIImageView *tempImageView = [imageViewArray objectAtIndex: i];
        [tempImageView setContentMode: contentMode];
    }
}

- (void)autoChangeScrollView
{
    if(scrollPoint >= imagesArray.count-2)
    {
        scrollPoint = 0;
    }
    [scrollview setContentOffset:CGPointMake((scrollPoint+1)*[scrollview frame].size.width, [scrollview contentOffset].y) animated:YES];
    scrollPoint++;
}

#pragma mark -
#pragma mark 添加缩放的手势函数
- (void)pinchGestureFunction:(id) sender
{
    [self bringSubviewToFront: [(UIPinchGestureRecognizer *)sender view]];
    if([(UIPinchGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        return;
    }
    CGFloat scale = 1.0f - (lastScale - [(UIPinchGestureRecognizer *)sender scale]);
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer *)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [[(UIPinchGestureRecognizer *)sender view] setTransform: newTransform];
    lastScale = [(UIPinchGestureRecognizer *)sender scale];
}

#pragma mark -
#pragma mark 旋转手势的执行事件
- (void)rotationGestureFunction:(UIRotationGestureRecognizer *) sender
{
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        lastScale = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastScale - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = [sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [[sender view] setTransform:newTransform];
    
    lastScale = [(UIRotationGestureRecognizer*)sender rotation];
    //[self showOverlayWithFrame:[sender view].frame];
}

- (void)setImageWithURLArray:(NSArray *) _imageURLArray
{
    [imagesArray removeAllObjects];
    NSMutableArray *imageURLArray = [NSMutableArray arrayWithArray: _imageURLArray];
    if([_imageURLArray count] > 0)
    {
        [imageURLArray insertObject: [_imageURLArray objectAtIndex:[_imageURLArray count] - 1] atIndex:0];//在第一个位置插入第一张图片(增加滑动的显示效果)
        [imageURLArray addObject:[_imageURLArray objectAtIndex: 0]];//在最后一个位置添加第一张图片(增加滑动的显示效果)
    }
    for(NSInteger i = 0; i < [imageURLArray count]; i++)
    {
        NSURL *imageURL = [imageURLArray objectAtIndex: i];
        [imagesArray addObject: imageURL];
        if([imageViewArray count] <= i)
        {
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setImageWithURL:imageURL placeholderImage: [UIImage imageNamed: @"default.png"]];
            [imgView setContentMode: UIViewContentModeScaleAspectFill];;
            [imgView setFrame: CGRectMake(viewSize.size.width*i, 0, viewSize.size.width, viewSize.size.height)];
            [imgView.layer setMasksToBounds: YES];
            [imgView setTag: i];
            
            /*-----给每张图片添加点击手势-----*/
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(imgPressed:)];
            [tapGesture setNumberOfTapsRequired: 1];
            [tapGesture setNumberOfTouchesRequired:1];
            [imgView setUserInteractionEnabled: YES]; //一定要将用户交互性设置为YES
            [imgView addGestureRecognizer: tapGesture];
            [scrollview addSubview: imgView];
            [imageViewArray addObject: imgView];
        }
        else
        {
            UIImageView *imageView = [imageViewArray objectAtIndex: i];
            [imageView setHidden: NO];
            [imageView setImageWithURL: imageURL placeholderImage: [UIImage imageNamed: @"default.png"]];
        }
    }
    for(NSInteger j = [imageURLArray count]; j < [imageViewArray count]; j++)
    {
        //如果当前准备加载的imageView小于已经加载的视图，则需要将多余的视图隐藏
        UIImageView *imageView = [imageViewArray objectAtIndex: j];
        [imageView setHidden: YES];
    }
    [pageControl setNumberOfPages: [imageURLArray count] - 2];
    [pageControl setCurrentPage: 0];
    [scrollview setContentSize: CGSizeMake(viewSize.size.width * ([imageURLArray count]), viewSize.size.height)];
    [scrollview setContentOffset: CGPointMake(viewSize.size.width, 0.0f)];
}

@end
