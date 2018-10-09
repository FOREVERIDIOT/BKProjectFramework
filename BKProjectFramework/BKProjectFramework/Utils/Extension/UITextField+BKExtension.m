//
//  UITextField+BKExtension.m
//  BKProjectFramework
//
//  Created by BIKE on 2018/10/9.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "UITextField+BKExtension.h"

@implementation UITextField (BKExtension)

-(NSRange)selectedRange
{
    // 文首的位置
    UITextPosition * beginning = self.beginningOfDocument;
    
    // 内容为(start,end),无论是否有选取区域,start都描述了光标的位置
    UITextRange * selectedRange = self.selectedTextRange;
    UITextPosition * selectionStart = selectedRange.start;
    UITextPosition * selectionEnd = selectedRange.end;
    
    // 获取以from为基准的to的偏移
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

-(void)setSelectedRange:(NSRange)range // 备注:UITextField必须为第一响应者才有效
{
    UITextPosition * beginning = self.beginningOfDocument;
    
    UITextPosition * startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition * endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    
    // 创建一个UITextRange
    UITextRange * selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end
