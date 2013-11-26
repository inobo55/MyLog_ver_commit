//
//  UIActionSheet+MyUIActionSheet.m
//  MyLog
//
//  Created by inoue on 2013/10/25.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

/*
 * このサイトを見ながら実装.
 * http://hikaruworld.bitbucket.org/blog/html/2012/11/29/objective_c_category_add_property.html
 */

#import "UIActionSheet+MyUIActionSheet.h"
#import <objc/runtime.h>

@implementation UIActionSheet (MyUIActionSheet)

static char indexPathSectionAddressKey_uiactionsheet;

@dynamic indexPathSection;


-(NSNumber *)indexPathSection{
    return objc_getAssociatedObject(self,&indexPathSectionAddressKey_uiactionsheet);
}

-(void)setIndexPathRow:(NSNumber *)indexPathSection{
    objc_setAssociatedObject(self,&indexPathSectionAddressKey_uiactionsheet,
                             indexPathSection,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)setSectionWith:(NSInteger)section{
    [self setIndexPathRow:[[NSNumber alloc] initWithInteger:section]];
}

-(NSInteger)getSection{
    return [[self indexPathSection] integerValue];
}


@end
