//
//  MenuViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-3.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "MenuViewModel.h"

#import "OrdersViewModel.h"
#import "DeliveriesViewModel.h"
#import "MarketsViewModel.h"
#import "JackpotViewModel.h"

@interface MenuViewModel ()

@end

@implementation MenuViewModel


-(NSInteger)numberOfSections
{
    return 1;
}
-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return 7;
}
-(NSString *)titleForSection:(NSInteger)section
{
    return nil;
}

-(NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * title = nil;
    
    switch (indexPath.row)
    {
        case 0:
        {
            title = NSLocalizedString(@"统货中心", nil);
        }
            break;
        case 1:
        {
            title = NSLocalizedString(@"发货中心", nil);
        }
            break;
        case 2:
        {
            title = NSLocalizedString(@"一键上传", nil);
        }
            break;
        case 3:
        {
            title = NSLocalizedString(@"分享朋友", nil);
        }
            break;
        case 4:
        {
            title = NSLocalizedString(@"扫描商家", nil);
        }
            break;
        case 5:
        {
            title = NSLocalizedString(@"摇一摇", nil);
        }
            break;
        case 6:
        {
            title = NSLocalizedString(@"退出账户", nil);
        }
            break;
        default:
            break;
    }
    
    return title;
}

-(NSString *)subtitleAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(THBasicViewModel *)viewModelForIndexPath:(NSIndexPath *)indexPath
{
    THBasicViewModel * viewModel = nil;
    
    switch (indexPath.row)
    {
        case 0:
        {
            viewModel = [[OrdersViewModel alloc] initWithModel:self.model];
        }
            break;
        case 1:
        {
            viewModel = [[DeliveriesViewModel alloc] initWithModel:self.model];
        }
            break;
        case 2:
        {
            viewModel = [[MarketsViewModel alloc] initWithModel:self.model];
        }
            break;
        case 5:
        {
            viewModel = [[JackpotViewModel alloc] initWithModel:self.model];
        }
            break;
        default:
            break;
    }

    
    return viewModel;
}

-(void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
