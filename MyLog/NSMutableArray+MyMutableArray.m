//
//  NSMutableArray+MyMutableArray.m
//  MyLog
//
//  Created by inoue on 2013/10/13.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "NSMutableArray+MyMutableArray.h"

@implementation NSMutableArray (MyMutableArray)

static NSString* TYPE_NSString = @"__NSCFConstantString";
static NSString* TYPE_NSUInteger = @"NSUInteger";

-(NSString*)joinWith:(NSString *)comma{
    NSString *result = [[NSString alloc]init];
    for (id element in self) {
        NSString *str_element;
        if([NSStringFromClass([element class]) isEqualToString:TYPE_NSUInteger])
            str_element = [NSString stringWithFormat:@"%i",(int)element];
        else if([NSStringFromClass([element class]) isEqualToString:TYPE_NSString])
            str_element = [NSString stringWithString:element];
        else
            str_element = [NSString stringWithFormat:@"%@",element];
        
        result = [[result stringByAppendingString:str_element] stringByAppendingString:comma];
    }
    return result;
}

@end
