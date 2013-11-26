//
//  UIButton+MyUIButton.m
//  MyLog
//
//  Created by inoue on 2013/11/12.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "UIButton+MyUIButton.h"
#import <objc/runtime.h>

@implementation UIButton (MyUIButton)

static char textViewAddressKey;

@dynamic connectedTextView;

-(UITextView *)connectedTextView{
    return objc_getAssociatedObject(self,&textViewAddressKey);
}

-(void)setConnectedTextView:(UITextView *)connectedTextView{
    objc_setAssociatedObject(self,&textViewAddressKey,
                             connectedTextView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




@end
