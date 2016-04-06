//
//  PageClass.h
//  WorldView
//
//  Created by WorldView on 15/12/10.
//  Copyright © 2015年 XZJ. All rights reserved.
//
typedef enum
{
    kOperate_Base = 0,
    kOperate_Refresh = 1,
    kOperate_LoadMore = 2
}Page_Operate;

#import <Foundation/Foundation.h>

@interface PageClass : NSObject
@property(nonatomic) NSInteger pageSize;
@property(nonatomic) NSInteger currentPage;
@property(nonatomic) NSInteger totalPage;
@property(nonatomic) NSInteger totalCount;
@property(nonatomic) NSInteger prePage;
@property(nonatomic) NSInteger nextPage;
@property(nonatomic) Page_Operate currentOperate;
- (void)refresh;
- (BOOL)loadMore;
@end
