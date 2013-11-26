//
//  EditLogDetailViewController.m
//  MyLog
//
//  Created by inoue on 2013/11/01.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "EditLogDetailViewController.h"
#import "AppDelegate.h"
#import "LogsViewController.h"
#import "RootTabBarController.h"

@interface EditLogDetailViewController ()

@end

@implementation EditLogDetailViewController

@synthesize reloadDelegate;

enum{
    QTEXT_ROW=0,
    ATEXT_ROW=1
};

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%d番目の\n問いと回答形式",section+1];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditLogDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self initCell:cell];
    
    if(indexPath.row == QTEXT_ROW){
        cell.backgroundColor = [UIColor yellowColor];
        cell.textLabel.text = [LogConfiguration getQtextOfLog:self.selectedIndexPath.row qa_index:indexPath.section];
        
    }else if(indexPath.row == ATEXT_ROW){
        id answer = [LogConfiguration getAnswer:self.selectedIndexPath.row qa_index:indexPath.section];
        NSString* type_str= [LogConfiguration getTypeStringFromClass:NSStringFromClass([answer class])]; //点数orテキスト
        if([type_str isEqualToString:@"テキスト"]){
            cell.backgroundColor = [UIColor orangeColor];
            CGRect rect = CGRectMake(10, 0, 300, 50);
            #warning ここはTextViewに変えること.
            UITextField *tf = [[UITextField alloc]initWithFrame:rect];
            tf.delegate = self;
            tf.placeholder = @"回答を入力しましょう.";
            tf.text = (NSString*)answer;
            tf.returnKeyType = UIReturnKeyDone;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            [tf addTarget:self action:@selector(saveAnswer:)forControlEvents:UIControlEventEditingDidEnd];
            [cell.contentView addSubview:tf];
        }else{
            ScoreReviewView *review = [[ScoreReviewView alloc]initWithFrame];
            review._delegate = self;
            review.indexPath = indexPath;
            [review setScore_Color:(NSNumber*)answer];
            [cell.contentView addSubview:review];
            
        }
        
    }
    return cell;
}

-(void)initCell:(UITableViewCell*)cell{
    
    // サブビューを取り除く
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    cell.textLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
}

-(void)saveAnswer:(UITextField*)textField{
    
    UITableViewCell *cell = (UITableViewCell*)[UITableView findUITableViewCellFromSuperViewsForView:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger log_index = self.selectedIndexPath.row;
    NSInteger qa_index = indexPath.section;
    
    NSDictionary *QAtext = [LogConfiguration createQAWith:
                            [LogConfiguration getQtextOfLog:log_index qa_index:qa_index] Answer:textField.text];
    
    [LogConfiguration renewQAtext:QAtext log_index:log_index qa_index:qa_index];
}

#pragma PickerView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == QTEXT_ROW){
        // PickerViewControllerのインスタンスをStoryboardから取得し
        self.pickerViewController = [[self storyboard]
                                     instantiateViewControllerWithIdentifier:@"PickerViewController"];
        self.pickerViewController.delegate = self;
        self.pickerViewController.log_index = self.selectedIndexPath.row;
        self.pickerViewController.qa_index = indexPath.section;

        // アニメーション完了時のPickerViewの位置を計算
        UIView *pickerView = self.pickerViewController.view;
        CGPoint middleCenter = pickerView.center;
        
        // アニメーション開始時のPickerViewの位置を計算
        UIWindow* mainWindow = (((AppDelegate*) [UIApplication sharedApplication].delegate).window);
        CGSize offSize = [UIScreen mainScreen].bounds.size;
        CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
        pickerView.center = offScreenCenter;
        
        [mainWindow addSubview:pickerView];
        
        // アニメーションを使ってPickerViewをアニメーション完了時の位置に表示されるようにする
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        pickerView.center = middleCenter;
        [UIView commitAnimations];
    }
}

// PickerViewのある行が選択されたときに呼び出されるPickerViewControllerDelegateプロトコルのデリゲートメソッド
- (void)applySelectedString:(NSString *)Qtext log_index:(NSUInteger)log_index qa_index:(NSUInteger)qa_index
{
    id answer = [LogConfiguration getAnswer:log_index qa_index:qa_index];
    NSDictionary *qa = [LogConfiguration createQAWith:Qtext Answer:answer];
    [LogConfiguration renewQAtext:qa log_index:log_index qa_index:qa_index];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:qa_index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

// PickerViewController上にある透明ボタンがタップされたときに呼び出されるPickerViewControllerDelegateプロトコルのデリゲートメソッド
- (void)closePickerView:(PickerViewController *)controller
{
   
    // PickerViewをアニメーションを使ってゆっくり非表示にする
    UIView *pickerView = controller.view;
    
    // アニメーション完了時のPickerViewの位置を計算
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    
    [UIView beginAnimations:nil context:(void *)pickerView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    // アニメーション終了時に呼び出す処理を設定
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    pickerView.center = offScreenCenter;
    [UIView commitAnimations];
}

// 単位のPickerViewを閉じるアニメーションが終了したときに呼び出されるメソッド
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // PickerViewをサブビューから削除
    UIView *pickerView = (__bridge UIView *)context;
    [pickerView removeFromSuperview];
}


#pragma textField

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    /*　フォーカスが外れたときに呼ばれるメソッド. */
    [textField resignFirstResponder];

    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    UITableViewCell *cell = [UITableView findUITableViewCellFromSuperViewsForView:textField];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell]
                          atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    return YES;
}

- (IBAction)LogDetailViewReturnActionForSegue:(UIStoryboardSegue *)segue{
    NSLog(@"Return!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma _delegate

-(void)saveReviewScore:(NSNumber *)this_score indexPath:(NSIndexPath *)indexPath{
    
    NSInteger log_index = self.selectedIndexPath.row;
    NSInteger qa_index = indexPath.section;
    
    NSDictionary *QAtext = [LogConfiguration createQAWith:
                            [LogConfiguration getQtextOfLog:log_index qa_index:qa_index] Answer:this_score];
    
    [LogConfiguration renewQAtext:QAtext log_index:log_index qa_index:qa_index];

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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"test");
    
}

#pragma reloadDelegate
- (void)viewWillDisappear:(BOOL)animated
{
    
    // LogDetailViewController と LogsViewControllerを更新.
    if ([reloadDelegate respondsToSelector:@selector(tableReload)]){
        [reloadDelegate tableReload];
        
        UINavigationController *navi = [[(RootTabBarController*)self.presentingViewController viewControllers]objectAtIndex:0];
        LogsViewController *logsView = [[navi viewControllers]objectAtIndex:0];
        [logsView.tableView reloadData];

    }else
        NSLog(@"can not call tableReload");
    
    NSLog(@"willDisapper");
}


@end
