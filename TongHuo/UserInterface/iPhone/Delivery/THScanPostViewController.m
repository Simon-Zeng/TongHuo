//
//  THScanPostViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-17.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THScanPostViewController.h"

#import <ZXingObjC/ZXingObjC.h>
#import "ScanPostViewModel.h"

@interface THScanPostViewController () <ZXCaptureDelegate>

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong)  UIView *scanRectView;


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
#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    self.scanRectView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view bringSubviewToFront:self.scanRectView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
        return @"Aztec";
        
        case kBarcodeFormatCodabar:
        return @"CODABAR";
        
        case kBarcodeFormatCode39:
        return @"Code 39";
        
        case kBarcodeFormatCode93:
        return @"Code 93";
        
        case kBarcodeFormatCode128:
        return @"Code 128";
        
        case kBarcodeFormatDataMatrix:
        return @"Data Matrix";
        
        case kBarcodeFormatEan8:
        return @"EAN-8";
        
        case kBarcodeFormatEan13:
        return @"EAN-13";
        
        case kBarcodeFormatITF:
        return @"ITF";
        
        case kBarcodeFormatPDF417:
        return @"PDF417";
        
        case kBarcodeFormatQRCode:
        return @"QR Code";
        
        case kBarcodeFormatRSS14:
        return @"RSS 14";
        
        case kBarcodeFormatRSSExpanded:
        return @"RSS Expanded";
        
        case kBarcodeFormatUPCA:
        return @"UPCA";
        
        case kBarcodeFormatUPCE:
        return @"UPCE";
        
        case kBarcodeFormatUPCEANExtension:
        return @"UPC/EAN extension";
        
        default:
        return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    [self.capture stop];
    
    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    
    NSLog(@"%@", display);
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    // Search for shop and open.
    if (![self.viewModel isPostValid:display])
    {
        AMSmoothAlertView * alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:NSLocalizedString(@"错误", nil)
                                                                              andText:NSLocalizedString(@"未能解析快递单号", nil)
                                                                      andCancelButton:NO
                                                                         forAlertType:AlertFailure];
        [alert show];
    }
    else
    {
#warning TODO: Handle delivery
    }
}

@end
