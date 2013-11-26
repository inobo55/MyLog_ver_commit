//
//  LogDetailViewController.h
//  MyLog
//
//  Created by inoue on 2013/10/14.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogConfiguration.h"
#import "EditLogDetailViewController.h"

@interface LogDetailViewController : UIViewController<tableReloadDelegate>

/*
 * ユーザが選択したセルのrow番号を取得。
 * その番号のデータの詳細を表示。
 * 問と回答の両方をついに表示。
 * 
 */

/*
 * テーブルビュー画面。
 * セルの中に「問い」と「区分けの棒(Gray)」と「答え」を一緒に表示してもいいかな〜。
 *
 */

@property (strong,nonatomic) NSIndexPath *selectedIndexPath;

@end
