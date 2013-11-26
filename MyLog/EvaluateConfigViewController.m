//
//  EvaluateConfigViewController.m
//  MyLog
//
//  Created by inoue on 2013/10/11.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "EvaluateConfigViewController.h"
#import "EvaluateConfigViewController.h"
#import "NSMutableArray+MyMutableArray.h"
#import "NSString+MyNSString.h"


@interface EvaluateConfigViewController ()

@end

static NSUInteger QuestionRow = 0;
static NSUInteger AnwerTypeRow = 1;

@implementation EvaluateConfigViewController

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
    
}

-(void)editQAtype{
    /* 消去ボタンと追加ボタンを表示。
     *
     */
    //エディットモード変更
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if(self.tableView.editing){
        self.navigationItem.leftBarButtonItem.title = @"Cancel";
    }else{
        self.navigationItem.leftBarButtonItem.title = @"Edit";
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *anotherPath;
    if(indexPath.row == QuestionRow)
        anotherPath = [NSIndexPath indexPathForRow:AnwerTypeRow inSection:indexPath.section];
    else if(indexPath.row == AnwerTypeRow)
        anotherPath = [NSIndexPath indexPathForRow:QuestionRow inSection:indexPath.section];
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath,anotherPath] withRowAnimation:UITableViewRowAnimationFade];
        [self Alert];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }
}

-(void)Alert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注意"
                                                   message:@"この問いを消してもよろしいですか？"
                                                  delegate:self cancelButtonTitle:@"やっぱダメ"
                                         otherButtonTitles:@"消去", nil];
    [alert show];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == QuestionRow)
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleInsert;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[LogConfiguration getLogConfig] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2; //(sectionTitle)/Question/AnswerType
}

// 下記を参考にヘッダーにViewを付加することも可能
// http://stackoverflow.com/questions/15611374/customize-uitableview-header-section

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%d番目の「問いと回答形式」",section+1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"ConfigCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //color change
    //set text
    if(indexPath.row == QuestionRow){
        cell.backgroundColor = [UIColor yellowColor];
        cell.textLabel.text = [LogConfiguration getQtextOfConfig:indexPath.section];
    }else if(indexPath.row == AnwerTypeRow){
        cell.backgroundColor = [UIColor orangeColor];
        cell.textLabel.text = [LogConfiguration getAtype:indexPath.section];
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma _delegate

-(void)modalViewDidDissmissed{
    NSLog(@"Dissmissed");
    [self.tableView reloadData];
}

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
   
    //通知先として自分を登録
    EditConfigLogTableViewController *modalView = (EditConfigLogTableViewController *)segue.destinationViewController;
    modalView._delegate = self;

}






@end
