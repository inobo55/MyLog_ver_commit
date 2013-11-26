//
//  LogsViewController.h
//  MyLog
//
//  Created by inoue on 2013/10/11.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditLogDetailViewController.h"


@interface LogsViewController : UITableViewController
<UISearchDisplayDelegate, UISearchBarDelegate,tableReloadDelegate>

@property (strong,nonatomic)NSMutableArray *_filteredIndexes;

@property (nonatomic) BOOL _hasTableSearched;

-(void)tableReload;

@end
