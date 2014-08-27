//
//  ScanPostViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-17.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "ScanPostViewModel.h"

@implementation ScanPostViewModel

- (BOOL)isPostValid:(NSString *)post
{
    BOOL isValid = ([post isKindOfClass:[NSString class]] && ([post length] > 0));
    
    return isValid;
}

@end
