//
//  WebViewViewController.m
//  WorldView
//
//  Created by WorldView on 15/12/5.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "WebViewViewController.h"
@implementation WebViewViewController
@synthesize webUrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: webUrl]]];
    [webView setScalesPageToFit: YES];
    [self.view addSubview: webView];
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
