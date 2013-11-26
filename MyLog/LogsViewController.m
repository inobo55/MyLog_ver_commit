//
//  LogsViewController.m
//  MyLog
//
//  Created by inoue on 2013/10/11.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "LogsViewController.h"
#import "LogDetailViewController.h"
#import "NSMutableArray+MyMutableArray.h"
#import "NSString+MyNSString.h"
#import "LogCell.h"
#import "LogConfiguration.h"


@interface LogsViewController ()

@end

@implementation LogsViewController

@synthesize _filteredIndexes;
@synthesize _hasTableSearched;
static NSString *CellIdentifier = @"LogCell";


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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self._hasTableSearched == TRUE)
        return [self._filteredIndexes count];
    
    return [[LogConfiguration getLogs]count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
        forHeaderFooterViewReuseIdentifier:CellIdentifier];
    
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    /*
     もし検索していて、indexPath.rowが指定の番号でなければreturn nil;
     */
    
    cell.countLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    //truncate処理/
    cell.titleLabel.text = [[NSString alloc]truncate:
                            [LogConfiguration getAnswer:indexPath.row qa_index:0]];
                                             //Logindex=indexPath.row,QAindex=0
    
    NSMutableArray *text_answers = [[NSMutableArray alloc]
                                    initWithArray:[LogConfiguration getTextAnswers:indexPath.row]];
        //truncate処理/表示形式/
    cell.contentLabel.text = [[NSString alloc]truncate:[text_answers joinWith:@"/"]];
    
    
    NSMutableArray *score_answers = [[NSMutableArray alloc]initWithArray:
                                     [LogConfiguration getScoreAnswers:indexPath.row]];
    //truncate処理/表示形式/
    cell.scoreLabel.text = [[NSString alloc]truncate:[score_answers joinWith:@"/"]];
    
    return cell;
}

-(BOOL)matchFilteredIndexPath:(NSIndexPath*)indexPath{
    
    for(NSNumber *row in _filteredIndexes)
        if([row intValue] == indexPath.row)
            return TRUE;
    return FALSE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* 検索キーワードを含んでいなければ、セルの高さを1にする. */
    if(_hasTableSearched == TRUE){
        if([self matchFilteredIndexPath:indexPath])
            return 120;
        else
            return 0;
    }
    
    return 120;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [LogConfiguration rmLog:indexPath.row];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [LogConfiguration replaceLog:fromIndexPath.row to:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    //これを一行追加するだけで、選択したセルを画面の上にもってくる処理になる。
    [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
    
}

#pragma mark - Search Display

/*
 以下のコードはhttp://blog.syuhari.jp/archives/1109を参照.
 */

- (void) searchItem:(NSString *) searchText {
    NSLog(@"searchText-s");
    _filteredIndexes = [[NSMutableArray alloc]init];
    [_filteredIndexes removeAllObjects];
    // 検索処理
    NSArray *titles = [LogConfiguration getTitlesFromLogs];
    for(int i=0;i<[titles count];i++) {
        NSString *label = [titles objectAtIndex:i];
        NSRange range = [label rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(range.length > 0){
            NSNumber *row = [[NSNumber alloc]initWithInt:i];
            NSLog(@"row:%@",[row description]);
            [_filteredIndexes addObject:row];
            NSLog(@"_indexes:%@",[_filteredIndexes debugDescription]);
        }
    }
    /*
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains %@", @"self", searchText];
     self._filtered = (NSMutableArray*)[titles filteredArrayUsingPredicate:predicate];
     */
    self._hasTableSearched = TRUE;
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    [self searchItem:searchBar.text];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *) searchText {
    NSLog(@"serch text=%@", searchText);
    if ([searchText length]!=0) {
        // インクリメンタル検索など
    }else{
        self._hasTableSearched = FALSE;
        [self.tableView reloadData];
    }
    
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    /*
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
     */
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    LogDetailViewController *detailViewController = (LogDetailViewController *)[segue destinationViewController];
    detailViewController.selectedIndexPath = (NSIndexPath *)sender;
    
}

#pragma tableReloadDelegate

-(void)tableReload{
    [self.tableView reloadData];
}




@end
