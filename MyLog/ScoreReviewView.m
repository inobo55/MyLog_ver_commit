//
//  ScoreReviewView.m
//  MyLog
//
//  Created by inoue on 2013/11/09.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "ScoreReviewView.h"

@implementation ScoreReviewView

@synthesize indexPath;
@synthesize _delegate;
@synthesize score;

#define MAX_SCOREVIEW_NUM 5 //評価は５段階

enum{
    SCORE1=7,
    SCORE2=14,
    SCORE3=21,
    SCORE4=28,
    SCORE5=35
};//score_view_tag

#define SELF_VIEW_TAG 100



- (id)initWithFrame
{
    //UITableViewCellと同じ大きさ
    int point_x = 0;
    int point_y = 0;
    int size_w = 320;
    int size_h = 50;
    
    CGRect frame = CGRectMake(point_x, point_y, size_w, size_h);
    self = [super initWithFrame:frame];
    if (self) {
        /* 評価マスの設定 */
        for(int i=1;i<=MAX_SCOREVIEW_NUM;i++){
            int start_point = size_w /MAX_SCOREVIEW_NUM *(i-1);
            CGRect score_frame = CGRectMake(start_point, point_y, size_w/MAX_SCOREVIEW_NUM, size_h);
            UIView *score_view = [[UIView alloc]initWithFrame:score_frame];
            score_view.backgroundColor = [UIColor whiteColor];
            score_view.userInteractionEnabled = TRUE;
            
            score_view.tag = i*7;
            
            //下記コードはhttp://ghtech.blog28.fc2.com/blog-entry-18.html参考
            [[score_view layer] setBorderColor:[[UIColor grayColor]CGColor]];
            [[score_view layer] setBorderWidth:1.0];
            
            [self addSubview:score_view];
        }
        
        self.userInteractionEnabled = TRUE;
        self.tag = SELF_VIEW_TAG;
    }
    return self;
}

-(void)setColorTo:(UIView*)score_view withIndex:(NSUInteger)i{
    switch (i) {
        case SCORE1:
            //blue
            //score_view.backgroundColor = [UIColor blackColor];
            //score_view.backgroundColor = [[UIColor alloc]initWithRed:125 green:199 blue:187 alpha:1.0];
            score_view.backgroundColor = [UIColor colorWithRed:0.48f green:0.8f blue:0.75f alpha:1.0];
            
            break;
        case SCORE2:
            //green
            //score_view.backgroundColor = [[UIColor alloc]initWithRed:144 green:205 blue:117 alpha:1.0];
            score_view.backgroundColor = [UIColor colorWithRed:0.55f green:0.8f blue:0.40f alpha:1.0];
            break;
        case SCORE3:
            //yellow
            //score_view.backgroundColor = [[UIColor alloc]initWithRed:235 green:236 blue:137 alpha:1.0];
            score_view.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.5f alpha:1.0];
            break;
        case SCORE4:
            //yellow_orange
            //score_view.backgroundColor = [[UIColor alloc]initWithRed:246 green:224 blue:137 alpha:1.0];
            score_view.backgroundColor = [UIColor colorWithRed:0.95f green:0.9f blue:0.6f alpha:1.0];
            break;
        case SCORE5:
            //orange
            //score_view.backgroundColor = [[UIColor alloc]initWithRed:221 green:157 blue:133 alpha:1.0];
            score_view.backgroundColor = [UIColor colorWithRed:0.88f green:0.6f blue:0.56f alpha:1.0];
            break;
        default:
            score_view.backgroundColor = [UIColor whiteColor];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    /* 下記コードは以下URL参考
     * http://stackoverflow.com/questions/4794005/how-can-i-get-object-from-tag
     * http://kengolab.net/CreApp/wiki/public/tech/ios/uikit/custom_view
     */
    
    /* 
     * 評価３のViewをタッチすると
     * 評価３〜１のすべてのViewが色がつく。
     */
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    
    //最初に全部のViewを真っ白に
    int white = -1;
    for(int i=7;i<=MAX_SCOREVIEW_NUM*7;i+=7)
        [self setColorTo:[self viewWithTag:i] withIndex:white];
    
    //タッチしたViewと、その左側のViewに色をつける.
    if(view.tag > MAX_SCOREVIEW_NUM*7)
        return;
    
    for(int i=view.tag;i>=7;i-=7)
        [self setColorTo:[self viewWithTag:i] withIndex:i];
    
    [self saveScoreWithTag:view.tag];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if(touch.view.tag != SELF_VIEW_TAG){
        NSLog(@"touchesMoved:touch.view.tag != SELF_VIEW_TAG");
        return;
    }
    
	CGPoint oldPoint = [touch previousLocationInView:self];
	CGPoint newPoint = [touch locationInView:self];
    UIView *touchView = [self getTouchedViewFromSelfViewPoint:oldPoint];
    UIView *touchEndView = [self getTouchedViewFromSelfViewPoint:newPoint];
    if(!touchView || !touchEndView){
        NSLog(@"touchesMoved:touchView or touchEndView is nil");
        return;
    }
    
    for(int i=touchView.tag;i<=touchEndView.tag;i++)
        [self setColorTo:[self viewWithTag:i] withIndex:i];
}

-(UIView*)getTouchedViewFromSelfViewPoint:(CGPoint)touchPoint{
    
    int width = self.frame.size.width;
    int point_x = touchPoint.x; // x = 0~320
    for(int i=1;i<=MAX_SCOREVIEW_NUM;i++){
        int point_left = width /MAX_SCOREVIEW_NUM *(i-1);
        int point_right = width /MAX_SCOREVIEW_NUM *i;
        if(point_left <= point_x && point_x <= point_right){
            UIView *touchView = [[UIView alloc]viewWithTag:i];
            return touchView;
        }
    }
    NSLog(@"getTouchedViewFromSelfViewPoint:NULL");
    return nil;
}

-(void)saveScoreWithTag:(NSUInteger)tag{
    
    if(tag > MAX_SCOREVIEW_NUM*7){
        NSLog(@"saveScoreWithTag: Tag is more than MAX_TAG");
        return;
    }
    
    self.score = [[NSNumber alloc]initWithInt:(tag/7)];
    
    if([_delegate isEqual:nil])
        return;
    
    if([_delegate respondsToSelector:@selector(saveReviewScore:indexPath:)])
        [_delegate saveReviewScore:self.score indexPath:self.indexPath];
    
}

/* _score = [1~5] 初期値
 * _scoreの値に応じて,Viewの値を変更する.
 */
-(void)setScore_Color:(NSNumber*)this_score{
    NSLog(@"setScore_Color:%@",[this_score description]);
    self.score = this_score;
    NSInteger s = [self.score integerValue];
    for(int i=s*7;i>=7;i-=7)
        [self setColorTo:[self viewWithTag:i] withIndex:i];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
