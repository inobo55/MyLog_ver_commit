//
//  LogDetailViewController.m
//  MyLog
//
//  Created by inoue on 2013/10/14.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "LogDetailViewController.h"

@interface LogDetailViewController ()

@end

@implementation LogDetailViewController

@synthesize selectedIndexPath;

const NSString *NSCOLOR_ATTRIBUTES_NAME = @"NSColorAttributes";
const NSString *NSFONT_ATTRIBUTENAME_NAME = @"NSFontAttributes";

float usedY; //複数のTextViewの位置で使用された合計Y

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    
    return self;
}

// http://qiita.com/yusuke_yasuo/items/d881305f46e5b433f9a3
// http://stackoverflow.com/questions/12914788/uilinebreakmodewordwrap-is-deprecated
// http://www.toyship.org/archives/1437
// 下記コードは上記のURLを参考に作成.
-(NSString*)toString:(id)value{
    
    NSString *str;
    if( [[value class]isSubclassOfClass:[str class]] )
        return value;
    else
        return [NSString stringWithFormat:@"%@",value];
    
}

- (CGFloat)getUsedYpoint{
    return usedY;
}

- (void)addUsedYpoint:(CGFloat)height{
    usedY += height;
}

-(void)setZeroToY{
    usedY = 0.0;
}

- (CGRect)setPointIn:(CGRect)frame{
    frame.origin.y += [self getUsedYpoint];
    [self addUsedYpoint:frame.size.height];
    return frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /* scrollViewを設置。
     * 問ラベルと回答ラベルを必要な数だけ設置。
     */
    
    if([selectedIndexPath isEqual:Nil]){
        NSLog(@"No value in selectedIndexPath");
        return;
    }
    
    NSUInteger row = selectedIndexPath.row; //selectedIndexPathにLogCellのインスタンスが代入されるケースが稀にある.
    
    NSUInteger qa_count = [[LogConfiguration getLog:row] count];
    
    CGRect fullsize_rect = CGRectMake(0,70,320,900+qa_count*50);
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:fullsize_rect];
    
    //問いと答えをすべて表示
    for (int i=1; i<=qa_count; i++) {
        
        NSDictionary *attributes = @{  NSForegroundColorAttributeName : [UIColor blackColor],
                                       NSFontAttributeName: [UIFont systemFontOfSize:15] };
        
        NSAttributedString *Qtext = [[NSAttributedString alloc]
                                     initWithString:[LogConfiguration getQtextOfLog:row qa_index:i-1]
                                     attributes:attributes];
        
        NSAttributedString *Atext =[[NSAttributedString alloc]
                                    initWithString:[self toString:[LogConfiguration getAnswer:row qa_index:i-1]]
                                    attributes:attributes];
        
        UITextView *QtextView = [[UITextView alloc]init];
        UITextView *AtextView = [[UITextView alloc]init];
        
        QtextView.attributedText = Qtext;
        AtextView.attributedText = Atext; //TODO:need to check wheather String or Integer.
        
        QtextView.backgroundColor = [UIColor yellowColor];
        AtextView.backgroundColor = [UIColor orangeColor];
        
        QtextView.editable = NO;
        AtextView.editable = NO;
        
        CGSize maxSize = CGSizeMake(300.0, 1000.0);
        
        CGRect frame_q = [self createFrame:frame_q maxSize:maxSize Text:Qtext];
        
        CGRect frame_a = [self createFrame:frame_a maxSize:maxSize Text:Atext];
        
        /*
        NSLog(@"Q.x:%f,y:%f",frame_q.origin.x,frame_q.origin.y);
        NSLog(@"Q.h:%f,w:%f",frame_q.size.height,frame_q.size.width);
        NSLog(@"A.x:%f,y:%f",frame_a.origin.x,frame_a.origin.y);
        NSLog(@"A.h:%f,w:%f",frame_a.size.height,frame_a.size.width);
        */
        QtextView.frame = frame_q;
        AtextView.frame = frame_a;
        
        [scroll addSubview:QtextView];
        [scroll addSubview:AtextView];
        
    }
    
    [self.view addSubview:scroll];
    
    [self setZeroToY];
     
}

- (CGRect)createFrame:(CGRect)frame maxSize:(CGSize)maxSize Text:(NSAttributedString*)Text{
    
    frame = [Text boundingRectWithSize:maxSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                                  context:nil];
    frame = [self extendLayout:frame];
    frame = [self setPointIn:frame];
    
    return frame;
}

- (void)alignFrame:(UITextView*)textView{
    CGRect newFrame = textView.frame;
    newFrame.size.height = textView.contentSize.height;
    textView.frame = newFrame;
}

-(CGRect)extendLayout:(CGRect)frame{
    frame.size.height += 10;
    frame.size.width += 10;
    return frame;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EditLogDetailViewController *viewController =
    (EditLogDetailViewController*)[segue destinationViewController];
    
    viewController.selectedIndexPath = self.selectedIndexPath;
    viewController.reloadDelegate = self;
}

-(void)tableReload{
    [self viewDidLoad];
}

@end
