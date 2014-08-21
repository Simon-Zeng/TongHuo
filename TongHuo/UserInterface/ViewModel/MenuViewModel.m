//
//  MenuViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-3.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "MenuViewModel.h"


#import "AppDelegate.h"

#import "Account.h"
#import "THAuthorizer.h"

#import "THProductsViewController.h"
#import "THDeliveriesViewController.h"
#import "THMarketsViewController.h"
#import "THJackpotViewController.h"
#import "THQRCodeViewController.h"

#import "ProductsViewModel.h"
#import "DeliveriesViewModel.h"
#import "MarketsViewModel.h"
#import "JackpotViewModel.h"
#import "QRCodeViewModel.h"

@interface MenuViewModel ()

@end

@implementation MenuViewModel

- (id)init
{
    if (self = [super init])
    {
        [self commandInit];
    }
    
    return self;
}

- (id)initWithModel:(id)model
{
    if (self = [super initWithModel:model])
    {
        [self commandInit];
    }
    
    return self;
}

- (void)commandInit
{
    
}

- (RACSignal *)updateNameSignal
{
    THAuthorizer * authorizer = [THAuthorizer sharedAuthorizer];
    
    return [RACObserve(authorizer, currentAccountID) map:^id(NSManagedObjectID * value) {
        return value;
    }];
}


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
            viewModel = [[ProductsViewModel alloc] initWithModel:self.model];
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
        case 4:
        {
            viewModel = [[QRCodeViewModel alloc] initWithModel:self.model];
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

- (BOOL)presentViewControllerForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3 || indexPath.row == 6)
    {
        return NO;
    }
    
    UIViewController * controller = nil;
    
    switch (indexPath.row)
    {
        case 0:
        {
            THProductsViewController * ordersController = [[THProductsViewController alloc] init];
            ordersController.viewModel = (ProductsViewModel *)[self viewModelForIndexPath:indexPath];
            
            controller = ordersController;
        }
            break;
        case 1:
        {
            THDeliveriesViewController * deliveriesController = [[THDeliveriesViewController alloc] init];
            deliveriesController.viewModel = (DeliveriesViewModel *)[self viewModelForIndexPath:indexPath];
            
            controller = deliveriesController;
        }
            break;
        case 2:
        {
            THMarketsViewController * marketsController = [[THMarketsViewController alloc] init];
            marketsController.viewModel = (MarketsViewModel *)[self viewModelForIndexPath:indexPath];
            
            controller = marketsController;
        }
            break;
            break;
        case 4:
        {
            THQRCodeViewController * qrCodeController = [[THQRCodeViewController alloc] init];
            qrCodeController.viewModel = (QRCodeViewModel *)[self viewModelForIndexPath:indexPath];
            
            controller = qrCodeController;
        }
            break;
        case 5:
        {
            THJackpotViewController * jackpotController = [[THJackpotViewController alloc] init];
            jackpotController.viewModel = (JackpotViewModel *)[self viewModelForIndexPath:indexPath];
            
            controller = jackpotController;
        }
            break;
        default:
            break;
    }

    if (controller)
    {
        controller.title = [self titleAtIndexPath:indexPath];
        
        JASidePanelController * sidePanelController = [(AppDelegate *)[UIApplication sharedApplication].delegate sidePanelController];
        
        UINavigationController * centerPanel = (UINavigationController *)sidePanelController.centerPanel;
        if (centerPanel.topViewController.class != controller.class)
        {
            [centerPanel setViewControllers:@[controller]];
        }
        
        [sidePanelController showCenterPanelAnimated:YES];
        
        return YES;
    }
    
    return NO;
}

@end
