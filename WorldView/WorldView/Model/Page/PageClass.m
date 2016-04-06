//
//  PageClass.m
//  WorldView
//
//  Created by WorldView on 15/12/10.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "PageClass.h"

@implementation PageClass
@synthesize pageSize,currentPage,totalCount,totalPage,nextPage,prePage,currentOperate;
- (id)init
{
    self = [super init];
    if(self){
        currentPage = 1;
        pageSize = 5;
        totalCount = 0;
        totalPage = 1;
        nextPage = 0;
        prePage = 0;
        currentOperate = kOperate_Base;
    }
    return self;
}

- (void)refresh
{
    currentPage = 1;
    currentOperate = kOperate_Refresh;
}

- (BOOL)loadMore
{
    if(currentPage >= totalPage){
        return NO;
    }
    else{
        currentPage += 1;
        currentOperate = kOperate_LoadMore;
        return YES;
    }
}
@end
