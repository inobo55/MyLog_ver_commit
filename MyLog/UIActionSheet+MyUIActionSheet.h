//
//  UIActionSheet+MyUIActionSheet.h
//  MyLog
//
//  Created by inoue on 2013/10/25.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (MyUIActionSheet)

@property(copy) NSNumber *indexPathSection;

-(void)setSectionWith:(NSInteger)section;

-(NSInteger)getSection;


@end
