//
//  EditConfigLogTableViewController.h
//  MyLog
//
//  Created by inoue on 2013/10/22.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogConfiguration.h"


@protocol ModalDelegate <NSObject>

- (void)modalViewDidDissmissed;

@end


@interface EditConfigLogTableViewController : UITableViewController
<UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    id<ModalDelegate>_delegate;
}

@property(nonatomic,strong)id<ModalDelegate> _delegate;



@end
