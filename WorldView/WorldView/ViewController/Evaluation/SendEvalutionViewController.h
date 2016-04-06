//
//  SendEvalutionViewController.h
//  WorldView
//
//  Created by WorldView on 15/12/5.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "EvalutionObject.h"
#import "TQStarRatingView.h"

@interface SendEvalutionViewController : BaseViewController<EvalutionObjectDelegate, UITextViewDelegate, StarRatingViewDelegate>
{
    EvalutionObject *evalutionObj;
    UITextView *contentTextView;
    XZJ_CustomLabel *fontNumberLabel;
    NSString *textViewText;
    NSInteger userScore;
}
@property(nonatomic, retain) NSString *serviceId;
@end
