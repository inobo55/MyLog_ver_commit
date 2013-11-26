//
//  UITableView+MyUITableView.h
//  MyLog
//
//  Created by inoue on 2013/11/02.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (MyUITableView)

/*
 * http://qiita.com/laishin17@github/items/a1f4c3406883a1d6a680
 * 上記を参考にした
 */
+ (UITableViewCell *)findUITableViewCellFromSuperViewsForView:(id)view;

@property (nonatomic)BOOL hasTableSearched;

@end
