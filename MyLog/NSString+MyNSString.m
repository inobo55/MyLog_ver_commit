//
//  NSString+MyNSString.m
//  MyLog
//
//  Created by inoue on 2013/10/13.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "NSString+MyNSString.h"

@implementation NSString (MyNSString)

/*
 * http://stackoverflow.com/questions/2952298/how-can-i-truncate-an-nsstring-to-a-set-length
 *
 * メソッド名:truncateは上記のURLから参照したコード
 */

-(NSString *)truncate:(NSString *)string{
    
    NSUInteger str_size = [string actualUtf8StringSize:string];
    //NSUInteger str_size = [string length];
    NSLog(@"str_size:%d",str_size);
    NSRange stringRange = {0, MIN(str_size, 20)};
    
    // adjust the range to include dependent chars
    stringRange = [string rangeOfComposedCharacterSequencesForRange:stringRange];
    
    // Now you can create the short string
    NSString *shortString = [string substringWithRange:stringRange];
    
    return shortString;
}

/*
 * http://tips.crosslaboratory.com/post/length_of_nsstring_with_emoji/
 *
 * メソッド名:acturlUtf8StringSizeは上記のURLから参照したコード。
 */

- (NSUInteger) actualUtf8StringSize:(NSString*) str {
    const char* cstr = [str UTF8String];
    int len = strlen(cstr);
    NSUInteger count = 0;
    unsigned char c;
    for (int i = 0; i < len; i++) {
        c = (unsigned char)cstr[i];
        if (0x00 <= c && c <= 0x7F) {
            ;
        }
        else if (0xC2 <= c && c <= 0xDF) {
            i += 1;
        }
        else if (0xE0 <= c && c <= 0xEF) {
            i += 2;
        }
        else if (0xF0 <= c && c <= 0xF7) {
            i += 3;
        }
        else {
            continue;
        }
        ++count;
    }
    return count;
}

@end
