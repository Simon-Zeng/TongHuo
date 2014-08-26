//
//  THScanPostViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-17.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THScanPostViewController.h"

#import <ZBarSDK.h>

#import "Orders+Access.h"
#import "Product+Access.h"
#import "ScanPostViewModel.h"
#import "THZoomPopup.h"
#import "THPostResultConfirmView.h"

@interface THScanPostViewController () <ZBarReaderViewDelegate>
{
    ZBarReaderView *readerView;
    
    ZBarCameraSimulator *cameraSim;
}



@end

@implementation THScanPostViewController

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
    
    if (TARGET_IPHONE_SIMULATOR)
    {
        readerView = [[ZBarReaderView alloc] init];
    }
    else
    {
        ZBarCaptureReader * captureScanner = [ZBarCaptureReader new];
        [captureScanner.scanner setSymbology: ZBAR_I25
                                      config: ZBAR_CFG_ENABLE
                                          to: 0];
        
        readerView = [[ZBarReaderView alloc] initWithImageScanner:captureScanner.scanner];
    }
    
    readerView.readerDelegate = self;
    readerView.tracksSymbols = YES;
    readerView.frame =CGRectMake(0, 0, viewSize.width, viewSize.height);
    readerView.torchMode = 0;
    
    // the delegate receives decode results
    readerView.readerDelegate = self;
    
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
    [view stop];
    
    NSString * resultString = nil;
    
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        resultString = sym.data;
        break;
    }
    
    NSLog(@"%@", resultString);
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    // Search for shop and open.
    if (![self.viewModel isPostValid:resultString])
    {
        AMSmoothAlertView * alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:NSLocalizedString(@"错误", nil)
                                                                              andText:NSLocalizedString(@"未能解析快递单号", nil)
                                                                      andCancelButton:NO
                                                                         forAlertType:AlertFailure];
        [alert show];
    }
    else
    {
        THPostResultConfirmView * confirmView = [[THPostResultConfirmView alloc] initWithFrame:CGRectMake(20, 84, 280, 200)];
        confirmView.postCode = resultString;
        
        THZoomPopup * popup = [[THZoomPopup alloc] initWithMainview:self.view andStartRect:self.view.bounds];
        popup.showCloseButton = NO;
        
        [confirmView setResultBlock:^(NSString * company, NSString * code){
            NSManagedObjectContext * mainContext = [THCoreDataStack defaultStack].managedObjectContext;
            
            [mainContext performBlock:^{
                Orders * order = self.viewModel.order;
//                Product * product = [Product productWithCourier:order.tno create:NO];
//                
//                product.state = @3;
                
                order.kno = code;
                order.ktype = company;
                order.state = @1;
                
                [[THCoreDataStack defaultStack] saveContext];
            }];
            
            [popup closePopup];
        }];
        
        [popup showPopup:confirmView];
    }
}

@end
