//
//  RootTabBarController.m
//  MyLog
//
//  Created by inoue on 2013/11/17.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "RootTabBarController.h"

@interface RootTabBarController ()

@end

enum{
    WATCH_LOGS_INDEX=0,
    CREATE_LOG_INDEX,
    SETTING_QUESTION_INDEX,
};

@implementation RootTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITabBarItem *watchItem = [self.tabBar.items objectAtIndex:WATCH_LOGS_INDEX];
    UITabBarItem *createItem = [self.tabBar.items objectAtIndex:CREATE_LOG_INDEX];
    UITabBarItem *settingItem = [self.tabBar.items objectAtIndex:SETTING_QUESTION_INDEX];
    
    watchItem.title = @"記録";
    createItem.title = @"レビュー";
    settingItem.title = @"レビュー設定";
    
    [watchItem setImage:[UIImage imageNamed:@"Search32x32px"]];
    [createItem setImage:[UIImage imageNamed:@"Create32x32px"]];
    [settingItem setImage:[UIImage imageNamed:@"Setting32x32px"]];
    
    [watchItem setSelectedImage:[UIImage imageNamed:@"Search32x32px"]];
    [createItem setSelectedImage:[UIImage imageNamed:@"Create32x32px"]];
    [settingItem setSelectedImage:[UIImage imageNamed:@"Setting32x32px"]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
