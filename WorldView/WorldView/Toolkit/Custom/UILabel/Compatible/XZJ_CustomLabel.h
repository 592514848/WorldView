//
//  XZJ_CustomLabel.h
//  GRDApplication
//
//  Created by 6602 on 14-4-13.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZJ_CustomLabel : UILabel
{
    float systemVersion; //系统版本
}

- (void)setHTMLText:(NSString *) text; //识别HTML的文本
@end
