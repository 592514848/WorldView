//
//  RootViewNavigationController.m
//  WorldView
//
//  Created by XZJ on 10/28/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define WINDOW [[UIApplication sharedApplication] keyWindow]
#import "RootViewNavigationController.h"

@implementation RootViewNavigationController
@synthesize backgroundView, screenShotsList;

- (void)viewDidLoad {
    [super viewDidLoad];
    ///1.初始化基本信息
    screenShotsList = [NSMutableArray array];
    
    ///2.添加返回手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipeGesture:)];
    [[self view] addGestureRecognizer: panGestureRecognizer];
    
    ///3.设置根视图
    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
    [homePageVC setIsRoot: YES];
    [self pushViewController: homePageVC animated: NO];
}

#pragma mark -
#pragma mark 返回手势
- (void)handleSwipeGesture:(UIGestureRecognizer *)sender
{
    if (self.viewControllers.count <= 1)
        return; //如果是顶级viewcontroller，不返回
    
    CGPoint translation=[sender locationInView:WINDOW];
    if(sender.state == UIGestureRecognizerStateBegan){
        startTouch = translation;
        isMoving = YES;//是否开始移动
        if (!self.backgroundView)
        {
            //添加背景
            CGRect frame = self.view.frame;
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            //把backgroundView插入到Window视图上，并below低于self.view层
            [WINDOW insertSubview:self.backgroundView belowSubview:self.view];
            //在backgroundView添加黑色的掩盖视图
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        self.backgroundView.hidden = NO;
        if (lastScreenShotView)
            [lastScreenShotView removeFromSuperview];
        UIImage *lastScreenShot = [screenShotsList lastObject];//数组中最后截图
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];//把截图插入到backgroundView上
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
    }
    else if(sender.state == UIGestureRecognizerStateEnded){
        isMoving = NO;
        self.backgroundView.hidden = NO;
        if (translation.x - startTouch.x > 50.0f) {
            //如果结束坐标大于开始坐标50像素就动画效果移动
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewToX: self.view.frame.size.width];
            } completion:^(BOOL finished) {
                if(finished){
                    //返回上一层并且还原坐标
                    [self popViewControllerAnimated:NO];
                    CGRect frame = self.view.frame;
                    frame.origin.x = 0;
                    self.view.frame = frame;
                    self.backgroundView.hidden = YES;
                }
            }];
        }
        else{
            //不大于50时就移动原位
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewToX: 0.0f];
            } completion:^(BOOL finished) {
                self.backgroundView.hidden = YES;//背景隐藏
            }];
        }
        return;
    }
    if (isMoving) {
        [self moveViewToX:translation.x - startTouch.x];
    }
}

#pragma mark -
#pragma mark 移动到指定x坐标
- (void)moveViewToX:(float) origin_x
{
    origin_x = origin_x > self.view.frame.size.width ? self.view.frame.size.width : origin_x;
    origin_x = origin_x < 0.0f ? 0.0f : origin_x;
    CGRect frame = self.view.frame;
    frame.origin.x = origin_x;
    self.view.frame = frame;
    float scale = (origin_x / 6400) + 0.95;//缩放大小
    float alpha = 0.4 - (origin_x / 800);//透明值
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);//缩放scale
    blackMask.alpha = alpha;//背景颜色透明值
}

#pragma mark 把UIView转化成UIImage，实现截屏
- (UIImage *)ViewRenderImage
{
    //创建基于位图的图形上下文 Creates a bitmap-based graphics context with the specified options.:UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale),size大小，opaque是否透明，不透明（YES），scale比例缩放
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    //当前层渲染到上下文
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //上下文形成图片
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    //结束并删除当前基于位图的图形上下文。
    UIGraphicsEndImageContext();
    //反回图片
    return img;
}

#pragma mark -
#pragma mark UINavigationController 覆盖方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotsList addObject:[self ViewRenderImage]];//图像数组中存放一个当前的界面图像，然后再push
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];//移除最后一个界面图像
    return [super popViewControllerAnimated: animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
