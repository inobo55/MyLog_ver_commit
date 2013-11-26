//
//  UITextField+AddSectionProperty.h
//  MyLog
//
//  Created by inoue on 2013/10/26.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (AddSectionProperty)

@property(copy) NSNumber *indexPathSection;

-(void)setSectionWith:(NSInteger)section;

-(NSInteger)getSection;


@end
