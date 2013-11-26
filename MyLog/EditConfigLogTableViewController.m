//
//  EditConfigLogTableViewController.m
//  MyLog
//
//  Created by inoue on 2013/10/22.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "EditConfigLogTableViewController.h"

#import "UIActionSheet+MyUIActionSheet.h"
#import "UITextField+AddSectionProperty.h"
#import "UIAlertView+MyAlertView.h"
#import "UITableView+MyUITableView.h"

#import "EvaluateConfigViewController.h"
#import "EvaluateViewController.h"

#import "RootTabBarController.h"



@interface EditConfigLogTableViewController ()

@end

@implementation EditConfigLogTableViewController

@synthesize _delegate;

const NSUInteger QuestionRow = 0;
const NSUInteger AnwerTypeRow = 1;

NSUInteger SectionInChangingValue; //TextFieldやPickerViewの値を変更している時のセクション番号

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = editDoneBtn;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma textField

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    /*　フォーカスが外れたときに呼ばれるメソッド. */
    [textField resignFirstResponder];
    
    UITableViewCell *cell = [UITableView findUITableViewCellFromSuperViewsForView:textField];
    NSInteger diff = [self diffBetweenMaxSectionAndCell:cell];
    if(diff < 2){
        NSLog(@"DOWN");
        [self cellDown:cell];
    }
    
    return YES;
}

-(void)saveLogConfig:(UITextField*)textField{
    
    /* textField編集直後に呼ばれるメソッド.まだフォーカスは外れていない.
     * LogConfigにある値とこのテキストフィールドのテキストの値を入れ替える。
     * 何番目のROWになんのテキストをぶっこむか
     */
    NSDictionary *QAtype = [LogConfiguration createQtext_Atype:textField.text
                                                         Atype:[LogConfiguration getAtype:[textField getSection]]];
    [LogConfiguration renewLogConfig:[textField getSection] Qtext_Atype:QAtype];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    /* この書き方でindexPathSectionを取得できるじゃないか! */
    UITableViewCell *cell = [UITableView findUITableViewCellFromSuperViewsForView:textField];
    
    /*
     * 一番したと下から二番目の要素は、画面真ん中に要素をセットできないぞ！
     */

    NSInteger diff = [self diffBetweenMaxSectionAndCell:cell];
    if(diff < 2){
        [self cellUp:cell diff:diff];
    }else{
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell]
                              atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

-(NSUInteger)diffBetweenMaxSectionAndCell:(UITableViewCell*)cell{
    NSLog(@"config_c:%i",[[LogConfiguration getLogConfig] count]);
    NSLog(@"cell:%i",[self.tableView indexPathForCell:cell].section+1);
    return [[LogConfiguration getLogConfig]count] - ([self.tableView indexPathForCell:cell].section+1);
}

- (void)cellUp:(UITableViewCell*)cell diff:(NSUInteger)diff
{
#warning offsetYの値を適切な値にする必要がある。
    /*
     * セルのセクション番号からoffsetYの値を決めた方が良さそう.
     *
     */
    
    NSInteger offsetY;
    if(diff == 0){
        //セクション一番したをクリックしたら
        offsetY = 300;
    }else{
        //セクションに番目に下をクリックしたら
        offsetY = 350;
    }
    
    UIScrollView *scroll = (UIScrollView*)[[cell superview] superview];
    CGPoint scrollPoint = CGPointMake(0,offsetY);
    [scroll setContentOffset:scrollPoint animated:YES];
}

- (void)cellDown:(UITableViewCell*)cell{
    
    UIScrollView *scroll = (UIScrollView*)[[cell superview] superview];
    [scroll setContentOffset:CGPointZero animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[LogConfiguration getLogConfig]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2; // textField + pickerView
}

-(void)initCell:(UITableViewCell*)cell{
    
    // サブビューを取り除く
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    cell.textLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EditConfigCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //文字重なり防止メソッド
    [self initCell:cell];

    if(indexPath.row == QuestionRow){
        //TextField展開
        UITextField *tf= [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
        tf.text = [LogConfiguration getQtextOfConfig:indexPath.section];
        tf.delegate = self;
        
        tf.placeholder = @"例:問いを入力しましょう";
        tf.returnKeyType = UIReturnKeyDone;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [tf addTarget:self action:@selector(saveLogConfig:)
                    forControlEvents:UIControlEventEditingDidEnd];
        [tf setSectionWith:indexPath.section];
        [cell.contentView addSubview:tf];
        
    }else if(indexPath.row == AnwerTypeRow){

        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.textLabel.text = [LogConfiguration getAtype:indexPath.section];
        
    }
    
    return cell;
}

#pragma UIActionSheet

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //TextFieldやラベルのcontentViewに触れる＝セルを選択すると
    NSLog(@"didSelectSection:%i",indexPath.section);
    if(indexPath.row == AnwerTypeRow){
        UIActionSheet *as = [[UIActionSheet alloc] init];
        as.delegate = self;
        [as setSectionWith:indexPath.section];
        as.title = @"回答形式を選択してください.";
        [as addButtonWithTitle:@"テキスト"];
        [as addButtonWithTitle:@"点数"];
        [as addButtonWithTitle:@"キャンセル"];
        as.cancelButtonIndex = 2;
        [as showInView:self.view.window];//タブがあるときようのアクションシート表示方法
    }
}




// アクションシートのボタンが押された時に呼ばれるデリゲート例文
-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(!actionSheet)return;
    NSString *Qtext = [LogConfiguration getQtextOfConfig:[actionSheet getSection]];
    NSDictionary *newQAtype;
    
    /* 発見
     * [self.tableView reloadData]をすると
     * textFieldの上にラベルっぽいのが付与されてしまう
     * ただ、ラベルの更新は可能.
     */
    
    const NSUInteger TypeTextRow = 0;
    const NSUInteger TypeScoreRow = 1;
    
    switch (buttonIndex) {
        case TypeTextRow:{
            // １番目のボタンが押されたときの処理を記述する
            newQAtype = [LogConfiguration createQtext_Atype:Qtext Atype:@"テキスト"];
            [LogConfiguration renewLogConfig:[actionSheet getSection] Qtext_Atype:newQAtype];
            break;
        }
        case TypeScoreRow:{
            // ２番目のボタンが押されたときの処理を記述する
            newQAtype = [LogConfiguration createQtext_Atype:Qtext Atype:@"点数"];
            [LogConfiguration renewLogConfig:[actionSheet getSection] Qtext_Atype:newQAtype];
            break;
        }
        case 2:{
            // ３番目のボタン「キャンセル」が押されたときの処理を記述する.
            break;
        }
    }
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:AnwerTypeRow inSection:[actionSheet getSection]], nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma toolbar

- (IBAction)EvaluateConfigViewReturnActionForSegue:(UIStoryboardSegue *)segue{
    NSLog(@"Return!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma _delegate
- (void)viewWillDisappear:(BOOL)animated
{
    //EvaluateConfigViewControllerのテーブルとEvaluateViewControllerのテーブルを更新.
    if ([_delegate respondsToSelector:@selector(modalViewDidDissmissed)]){
        [_delegate modalViewDidDissmissed];
        
        UINavigationController *navi = [[(RootTabBarController*)self.presentingViewController viewControllers]objectAtIndex:1];
        EvaluateViewController *evaluate = [[navi viewControllers]objectAtIndex:0];
        [evaluate.tableView reloadData];
        
        
    }else
        NSLog(@"can not call modalViewDidDissmissed");
    
    NSLog(@"willDisapper");
}

-(IBAction)addNewQAcell:(id)sender{
    
    [LogConfiguration addLogConfig:[LogConfiguration createQtext_Atype:@"" Atype:@"テキスト"]];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:[self.tableView numberOfSections]];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
}

/*
 * didSelectedしたら
 * そのセルが画面のやや上に来るように設定しましょうか。
 */

#pragma alertView

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertView *deleteAlert = [[UIAlertView alloc]initWithTitle:@"注意!"
                                                         message:@"選択した項目を消去しますが\nよろしいですか？"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"消去",@"キャンセル",nil];
    [deleteAlert setSectionWith:indexPath.section];
    [deleteAlert show];
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    const NSInteger YES_DELETE = 0;
    const NSInteger CANCEL = 1;
    
    switch (buttonIndex) {
        case YES_DELETE:
            NSLog(@"DELETE");
            [self deleteQAcellWith:[alertView getSection]];
            break;
        case CANCEL:
            
            break;
    }
}

-(void)deleteQAcellWith:(NSUInteger)section{
    
    [LogConfiguration rmLogConfig:section];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:section];
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationTop];

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

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

#pragma delegate
//デリゲートがメソッドに応答できるかチェックしてから呼び出す



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

