//
//  UIAlertView+MyAlertView.h
//  MyLog
//
//  Created by inoue on 2013/10/31.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (MyAlertView)

@property(copy) NSNumber *indexPathSection;

-(void)setSectionWith:(NSInteger)section;

-(NSInteger)getSection;


@end
