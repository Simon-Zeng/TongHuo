//
//  THJackpotViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THJackpotViewController.h"

#import "JackpotViewModel.h"

@interface THJackpotViewController ()

@property (nonatomic, readonly) UIImageView * shakeView;

@end

@implementation THJackpotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"摇一摇   中快递单", nil);
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.shakeView];
    
    @weakify(self);
    [self.viewModel.shakeCommand.executionSignals subscribeNext:^(RACSignal * signal) {
        [signal subscribeNext:^(RACTuple *result) {
            RACTupleUnpack(AFHTTPRequestOperation *httpRequest) = result;
            
            @strongify(self);
            
            NSString * response = httpRequest.responseString;
            
            NSArray * jackpots = [response componentsSeparatedByString:@"-"];
            
            if (2 == jackpots.count)
            {
                [self showJackpotResult:jackpots];
            }
            
            NSLog(@"----- Jackpot Response: %@", httpRequest.responseString);
        } error:^(NSError *error) {
            NSLog(@"----- Jackpot error: %@", error);
        } completed:^{
            
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImageView *)shakeView
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shake"]];
    imageView.center = self.view.center;
    
    [imageView.layer addAnimation:[THHelper shakeAnimationWithDuration:0.5] forKey:@"shake"];
    
    return imageView;
}

#pragma mark - Shake
- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.type == UIEventSubtypeMotionShake)
    {
        [THHelper playSound:@"shake.wav"];
        
        [self.viewModel.shakeCommand execute:nil];
    }
}

#pragma mark -
- (void)showJackpotResult:(NSArray *)result
{
    if (result.count >=2)
    {
//        NSDecimalNumber * total = [NSDecimalNumber decimalNumberWithString:result[0]];
        NSDecimalNumber * last = [NSDecimalNumber decimalNumberWithString:result[1]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
            NSString * title = nil;
            NSString * message = nil;
            
            if (last.intValue > 0)
            {
                title = @"恭喜";
                message = [NSString stringWithFormat:@"您本次摇中了%@个快递单.", last];
            }
            else
            {
                title = @"太遗憾了";
                message = [NSString stringWithFormat:@"您本次没有摇中快递单."];
            }
            
            AMSmoothAlertView * alertView = [[AMSmoothAlertView alloc] initDropAlertWithTitle:title
                                                                                      andText:message
                                                                              andCancelButton:NO
                                                                                 forAlertType:AlertInfo];
            [alertView show];
        });


    }
}

@end
