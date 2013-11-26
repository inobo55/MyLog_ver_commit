//
//  UITableView+MyUITableView.m
//  MyLog
//
//  Created by inoue on 2013/11/02.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "UITableView+MyUITableView.h"

@implementation UITableView (MyUITableView)


/*
 * http://qiita.com/laishin17@github/items/a1f4c3406883a1d6a680
 * 上記を参考にした
 */
+ (UITableViewCell *)findUITableViewCellFromSuperViewsForView:(id)view {
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    UIView *superView = view;
    while (superView) {
        if ([superView isKindOfClass:[UITableViewCell class]]) {
            break;
        }
        superView = [superView superview];
    }
    return (UITableViewCell *)superView;
}




@end
