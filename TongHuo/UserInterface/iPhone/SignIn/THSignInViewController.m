//
//  THSignInViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THSignInViewController.h"

#import "SignInViewModel.h"
#import "THCoreDataStack.h"
#import "THAuthorizer.h"

@interface THSignInViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView * contentView;

@property (nonatomic, strong) UITextField * usernameField;
@property (nonatomic, strong) UITextField * passwordField;

@property (nonatomic, strong) FUIButton * signInButton;

@property (nonatomic, readwrite) SignInViewModel * signInViewModel;

@end

@implementation THSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.signInViewModel = [[SignInViewModel alloc] initWithModel:[THCoreDataStack defaultStack].managedObjectModel];
        
    }
    return self;
}

- (void)loadView
{
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    
    UIView * view = [[UIView alloc] initWithFrame:windowFrame];
    
    UIScrollView * contentView = [[UIScrollView alloc] initWithFrame:windowFrame];
    contentView.contentSize = windowFrame.size;
    [view addSubview:contentView];
    
    self.contentView = contentView;
    
    UIImageView * backgroundView = [[UIImageView alloc] initWithFrame:windowFrame];
    backgroundView.contentMode = UIViewContentModeCenter;
    backgroundView.image = [UIImage imageNamed:@"SignInBackground"];
    [contentView addSubview:backgroundView];
    
    CGFloat middleY = windowFrame.size.height/2;
    
    // Username field
    UITextField * usernameField = [[UITextField alloc] initWithFrame:CGRectMake(94, middleY - 22.0, 180, 30)];
    usernameField.borderStyle = UITextBorderStyleNone;
    usernameField.returnKeyType = UIReturnKeyNext;
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameField.delegate = self;

    [contentView addSubview:usernameField];
    
    self.usernameField = usernameField;
    
    // Password field
    UITextField * passwordField = [[UITextField alloc] initWithFrame:CGRectMake(94, middleY+20.0, 180, 30)];
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.secureTextEntry = YES;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.delegate = self;
    
    [contentView addSubview:passwordField];
    
    self.passwordField = passwordField;
    
    // Sign In button
    FUIButton * signInButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    signInButton.frame = CGRectMake(15, middleY + 80, 290, 31.0);
    signInButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    signInButton.buttonColor = [UIColor colorWithRed:242.0/255
                                               green:39.0/255
                                                blue:131.0/255
                                               alpha:1.0];
    signInButton.shadowColor = [UIColor colorWithRed:175.0/255
                                               green:179.0/255
                                                blue:190.0/255
                                               alpha:1.0];
    signInButton.shadowHeight = 2.0f;
    signInButton.highlightedColor = [UIColor colorWithRed:204.0/255
                                                    green:205.0/255
                                                     blue:210.0/255
                                                    alpha:1.0];
    signInButton.cornerRadius = 4.0f;

    [signInButton setTitle:NSLocalizedString(@"登   录", nil)
                  forState:UIControlStateNormal];
    [contentView addSubview:signInButton];
    
    self.signInButton = signInButton;
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RAC(self.signInViewModel, username) = self.usernameField.rac_textSignal;
    RAC(self.signInViewModel, password) = self.passwordField.rac_textSignal;
//    RACChannelTo(self.usernameField, text) = RACChannelTo(self.signInViewModel, username);
//    RACChannelTo(self.passwordField, text) = RACChannelTo(self.signInViewModel, password);
    @weakify(self);
    [self.signInViewModel.signInCommand.executing subscribeNext:^(NSNumber * x) {
        @strongify(self);
        if(x.boolValue)
        {
            [self.view endEditing:YES];
            [SVProgressHUD showWithStatus:@"请稍候..." maskType:SVProgressHUDMaskTypeGradient];
        }
    }];
    [self.signInButton setRac_command:self.signInViewModel.signInCommand];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    @weakify(self);
    

    // When the load command is executed, update our view accordingly
    [self.signInViewModel.signInCommand.executionSignals subscribeNext:^(id signal) {
        
        [signal subscribeNext:^(RACTuple * x) {
            AFHTTPRequestOperation * operation = x[0];
            NSLog(@"----- Sign in response: %@", operation.responseString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [SVProgressHUD dismiss];
                if ([THAuthorizer sharedAuthorizer].isLoggedIn)
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        }];
    }];
    
    [self.signInViewModel.signInCommand.errors subscribeNext:^(NSError * err) {
        @strongify(self);
        if (![THAuthorizer sharedAuthorizer].isLoggedIn)
        {
            [self showLoginFailedAlertWithError:err];
        }
    }];
}

- (void)showLoginFailedAlertWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
        
        NSString * message = @"您输入的用户名或者密码不正确，请重新输入后再试！";
        if (error && [error.domain isEqual:NSURLErrorDomain])
        {
            message = [NSString stringWithFormat:@"错误: %@", error.localizedDescription];
        }
        
        AMSmoothAlertView * alertView = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"登录失败"
                                                                                  andText:message
                                                                          andCancelButton:NO
                                                                             forAlertType:AlertFailure];
        [alertView show];
    });
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         CGRect windowRect = self.view.bounds;
                         
                         self.contentView.frame = CGRectMake(0, 0, windowRect.size.width, windowRect.size.height - 216.0);
                         
                         CGRect visibleRect = textField.frame;
                         visibleRect.origin.y += 65.0;
                         
                         [self.contentView scrollRectToVisible:visibleRect animated:NO];

                     }
                     completion:^(BOOL finished) {
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect windowRect = self.view.bounds;
    
    self.contentView.frame = windowRect;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField)
    {
        [self.passwordField becomeFirstResponder];
    }
    else
    {
        [self.usernameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }
    
    return NO;
}

@end
