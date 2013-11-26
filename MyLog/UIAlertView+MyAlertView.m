//
//  UIAlertView+MyAlertView.m
//  MyLog
//
//  Created by inoue on 2013/10/31.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "UIAlertView+MyAlertView.h"
#import <objc/runtime.h>

@implementation UIAlertView (MyAlertView)

#warning 同じコードやねん.
/*
 * これと同じ処理をするクラスが多い。
 * クラス作って他のクラスがそれを継承する形が良いかも.
 */


static char indexPathSectionAddressKey_UIAlertView;

@dynamic indexPathSection;

-(NSNumber *)indexPathSection{
    return objc_getAssociatedObject(self,&indexPathSectionAddressKey_UIAlertView);
}

-(void)setIndexPathRow:(NSNumber *)indexPathSection{
    objc_setAssociatedObject(self,&indexPathSectionAddressKey_UIAlertView,
                             indexPathSection,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



-(void)setSectionWith:(NSInteger)section{
    [self setIndexPathRow:[[NSNumber alloc] initWithInteger:section]];
}

-(NSInteger)getSection{
    return [[self indexPathSection] integerValue];
}


@end
