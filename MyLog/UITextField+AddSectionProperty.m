//
//  UITextField+AddSectionProperty.m
//  MyLog
//
//  Created by inoue on 2013/10/26.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "UITextField+AddSectionProperty.h"
#import <objc/runtime.h>

@implementation UITextField (AddSectionProperty)

static char indexPathSectionAddressKey_textField;

@dynamic indexPathSection;

-(NSNumber *)indexPathSection{
    return objc_getAssociatedObject(self,&indexPathSectionAddressKey_textField);
}

-(void)setIndexPathRow:(NSNumber *)indexPathSection{
    objc_setAssociatedObject(self,&indexPathSectionAddressKey_textField,
                             indexPathSection,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



-(void)setSectionWith:(NSInteger)section{
    [self setIndexPathRow:[[NSNumber alloc] initWithInteger:section]];
}

-(NSInteger)getSection{
    return [[self indexPathSection] integerValue];
}




@end
