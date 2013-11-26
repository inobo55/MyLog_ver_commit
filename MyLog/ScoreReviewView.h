//
//  ScoreReviewView.h
//  MyLog
//
//  Created by inoue on 2013/11/09.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LogConfiguration.h"


/* EditLogDetailViewControllerの時のみ使用 */
@protocol ScoreReviewDelegate <NSObject>

- (void)saveReviewScore:(NSNumber*)this_score indexPath:(NSIndexPath*)indexPath;

@end

@interface ScoreReviewView : UIView{
    id <ScoreReviewDelegate> _delegate;
}
@property (strong,nonatomic)id<ScoreReviewDelegate> _delegate;

@property (strong,nonatomic)NSIndexPath *indexPath;

@property (strong,nonatomic)NSNumber* score;

-(id)initWithFrame;

-(void)setScore_Color:(NSNumber*)this_score;

@end
