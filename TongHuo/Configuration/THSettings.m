//
//  THSettings.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THSettings.h"

@implementation THSettings

#pragma mark Class methods

+ (instancetype) sharedSettings
{
    static THSettings * settings = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[self alloc] init];
    });
    
    return settings;
}

#pragma mark - Instance Methods
- (NSString *) documentDirectoryPathString
{
    NSArray * dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([dirs count])
    {
        return [dirs firstObject];
    }
    else
    {
        return nil;
    }
}

- (NSURL *) documentDirectoryPathURL
{
    NSString * pathString = [self documentDirectoryPathString];
    if (pathString)
    {
        return [NSURL fileURLWithPath:pathString isDirectory:YES];
    }
    else
    {
        return nil;
    }
}

- (NSString *) applicationDataSupportDirectoryPathString
{
    NSArray * dirs = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if ([dirs count])
    {
        return [dirs firstObject];
    }
    else
    {
        return nil;
    }

}

- (NSURL *) applicationDataSupportDirectoryPathURL
{
    NSString * pathString = [self applicationDataSupportDirectoryPathString];
    if (pathString)
    {
        return [NSURL fileURLWithPath:pathString isDirectory:YES];
    }
    else
    {
        return nil;
    }
}

- (NSString *) tempDirectoryPathString
{
    return NSTemporaryDirectory();
}

- (NSURL *) tempDirectoryPathURL
{
    NSString * pathString = [self tempDirectoryPathString];
    if (pathString)
    {
        return [NSURL fileURLWithPath:pathString isDirectory:YES];
    }
    else
    {
        return nil;
    }
}


@end
