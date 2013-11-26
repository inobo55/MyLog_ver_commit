//
//  EditLogDetailViewController.h
//  MyLog
//
//  Created by inoue on 2013/11/01.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogConfiguration.h"
#import "UITableView+MyUITableView.h"
#import "UIActionSheet+MyUIActionSheet.h"
#import "PickerViewController.h"
#import "ScoreReviewView.h"

@protocol tableReloadDelegate <NSObject>

-(void)tableReload;

@end

@interface EditLogDetailViewController : UITableViewController
<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,PickerViewControllerDelegate,ScoreReviewDelegate>

@property (strong,nonatomic)id<tableReloadDelegate>reloadDelegate;

@property (weak,nonatomic) NSIndexPath *selectedIndexPath;

// 呼び出すPickerViewControllerのポインタ　※strongを指定してポインタを掴んでおかないと解放されてしまう
@property (strong, nonatomic) PickerViewController *pickerViewController;


@end

