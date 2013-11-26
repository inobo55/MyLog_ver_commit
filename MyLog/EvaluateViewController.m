//
//  EvaluateViewController.m
//  MyLog
//
//  Created by inoue on 2013/10/11.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "EvaluateViewController.h"


@interface EvaluateViewController ()

@end

@implementation EvaluateViewController

static NSUInteger QuestionRow = 0;
static NSUInteger AnwerTextRow = 1;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                             target:self
                             action:@selector(moveToResultView:)];
    self.navigationItem.rightBarButtonItem = done;
    

}

-(void)moveToResultView:(id)sender{
    
    //ScoreReviewのtagの取得ができない.
    
    for(int i=1;i<=3;i++){
        NSLog(@"view:%@,%i",[self.view viewWithTag:i*10],i*10);
    }
    
    //遷移処理だけでなく保存処理も兼ねる
    NSMutableArray *log = [[NSMutableArray alloc]init];
    for(int i=1;i<=[[LogConfiguration getLogConfig] count];i++){
        NSString *Qtext = [LogConfiguration getQtextOfConfig:(i-1)];
        NSString *AnswerType = [LogConfiguration getAtype:(i-1)];
        if([AnswerType isEqualToString:@"テキスト"]){
            UITextView *textView = (UITextView*)[self.view viewWithTag:i*10]; //
            NSDictionary *QA = [LogConfiguration createQAWith:Qtext Answer:textView.text];
            [log addObject:QA];
        }else if([AnswerType isEqualToString:@"点数"]){
            ScoreReviewView *review  = (ScoreReviewView*)[self.view viewWithTag:i*10]; //
            NSDictionary *QA = [LogConfiguration createQAWith:Qtext Answer:review.score];
            [log addObject:QA];
        }
    }
    [LogConfiguration addLog:log];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController  *controller = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:controller animated:YES completion:nil];
}

 - (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView


-(UIView*)attachCloseBtnInKeyboardWith:(UITextView*)textView{
    /* 下記コードはhttp://www.toyship.org/archives/82参考*/
    UIView* accessoryView =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
    accessoryView.backgroundColor = [UIColor whiteColor];
    
    // ボタンを作成する
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(260,5,50,20);
    [closeButton setTitle:@"閉じる" forState:UIControlStateNormal];
    [closeButton setConnectedTextView:textView];
    // ボタンを押したときによばれる動作を設定する
    [closeButton addTarget:self
                    action:@selector(closeKeyboard:)
          forControlEvents:UIControlEventTouchUpInside];
    // ボタンをViewに貼る
    [accessoryView addSubview:closeButton];
    return accessoryView;
}

-(void)closeKeyboard:(id)sender{
    UIButton *closeBtn = (UIButton*)sender;
    [closeBtn.connectedTextView resignFirstResponder];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[LogConfiguration getLogConfig]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Qtext and Atext
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(QuestionRow)
        return 30;
    else if(AnwerTextRow)
        return 50;
    
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EvaluteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *AnserType = [LogConfiguration getAtype:indexPath.section];
    if(indexPath.row == QuestionRow){
        //下記コードはhttp://www.hnyssh.net/?p=281参考にした
        cell.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        cell.textLabel.text = [LogConfiguration getQtextOfConfig:indexPath.section];
        
    }else if(indexPath.row == AnwerTextRow && [AnserType isEqualToString:@"テキスト"]){
        //AnserType is text.
        CGRect rect = CGRectMake(10, 5, 300, 40);
        UITextView *textView = [[UITextView alloc]initWithFrame:rect];
        textView.inputAccessoryView = [self attachCloseBtnInKeyboardWith:textView];
        
        textView.tag = (indexPath.section+1)*10;
        
        textView.editable = TRUE;
        textView.text = @"text";
        [cell.contentView addSubview:textView];
        
    }else if(indexPath.row == AnwerTextRow && [AnserType isEqualToString:@"点数"]){
        //AnserType is score. so, build star for setting score.
        //CGRect rect = CGRectMake(0, 0, 320, 50);
        ScoreReviewView *review = [[ScoreReviewView alloc]initWithFrame];
        review.score = [[NSNumber alloc]initWithInt:0];
        
        review.tag = (indexPath.section+1)*10;
        
        [cell.contentView addSubview:review];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
