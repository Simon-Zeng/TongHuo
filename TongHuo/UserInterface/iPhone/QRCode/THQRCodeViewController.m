//
//  THQRCodeViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THQRCodeViewController.h"

#import <ZBarSDK.h>

#import "QRCodeViewModel.h"

#import "Shops+Access.h"
#import "GoodsViewModel.h"
#import "THGoodsViewController.h"

@interface THQRCodeViewController () <ZBarReaderViewDelegate>
{
    ZBarReaderView *readerView;
    
    ZBarCameraSimulator *cameraSim;
}

@end

@implementation THQRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    cameraSim = nil;
    
    readerView.readerDelegate = nil;
    readerView = nil;
}
#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize viewSize = self.view.frame.size;
    
    ZBarCaptureReader * captureScanner = [ZBarCaptureReader new];
    [captureScanner.scanner setSymbology: ZBAR_I25
                                  config: ZBAR_CFG_ENABLE
                                      to: 0];
    
    readerView = [[ZBarReaderView alloc] initWithImageScanner:captureScanner.scanner];
    readerView.readerDelegate = self;
    readerView.tracksSymbols = YES;
    readerView.frame =CGRectMake(0, 0, viewSize.width, viewSize.height);
    readerView.torchMode = 0;

    // the delegate receives decode results
    readerView.readerDelegate = self;
    
    [self.view addSubview:readerView];
    
    // ensure initial camera orientation is correctly set
    UIApplication *app = [UIApplication sharedApplication];
    [readerView willRotateToInterfaceOrientation: app.statusBarOrientation
                                        duration: 0];
    
    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerView;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // run the reader when the view is visible
    [readerView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [readerView stop];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    // auto-rotation is supported
    return(YES);
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // compensate for view rotation so camera preview is not rotated
    [readerView willRotateToInterfaceOrientation: orient
                                        duration: duration];
}

- (void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) orient
                                          duration: (NSTimeInterval) duration
{
    // perform rotation in animation loop so camera preview does not move
    // wrt device orientation
    [readerView setNeedsLayout];
}

#pragma mark - ZXCaptureDelegate Methods


- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    NSString * resultString = nil;
    
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        resultString = sym.data;
        break;
    }

    NSLog(@"%@", resultString);
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    NSNumber * shopId = @(resultString.longLongValue);
    
    // Search for shop and open.
    if (![self.viewModel canOpenShop:shopId])
    {
        AMSmoothAlertView * alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:NSLocalizedString(@"错误", nil)
                                                                              andText:NSLocalizedString(@"未找到符合要求的商家", nil)
                                                                      andCancelButton:NO
                                                                         forAlertType:AlertFailure];
        [alert show];
    }
    else
    {
        GoodsViewModel * goodsViewModel = [[GoodsViewModel alloc] initWithModel:self.viewModel.model];
        goodsViewModel.shop = [Shops shopWithId:shopId];
        
        THGoodsViewController * goodsViewController = [[THGoodsViewController alloc] init];
        goodsViewController.viewModel = goodsViewModel;
        
        [self.navigationController pushViewController:goodsViewController animated:YES];
    }
}


@end
