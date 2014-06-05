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

@interface THSignInViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView * contentView;

@property (nonatomic, strong) UITextField * usernameField;
@property (nonatomic, strong) UITextField * passwordField;

@property (nonatomic, strong) UIButton * signInButton;

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
#if UIDEBUG
    usernameField.backgroundColor = [UIColor redColor];
#endif
    [contentView addSubview:usernameField];
    
    self.usernameField = usernameField;
    
    // Password field
    UITextField * passwordField = [[UITextField alloc] initWithFrame:CGRectMake(94, middleY+20.0, 180, 30)];
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.delegate = self;
#if UIDEBUG
    passwordField.backgroundColor = [UIColor redColor];
#endif
    [contentView addSubview:passwordField];
    
    self.passwordField = passwordField;
    
    // Sign In button
    UIButton * signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signInButton.frame = CGRectMake(30, middleY + 80, 260, 31.0);
#if UIDEBUG
    [signInButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
#endif
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
    
    RACChannelTo(self.usernameField, text) = RACChannelTo(self.signInViewModel, username);
    RACChannelTo(self.passwordField, text) = RACChannelTo(self.signInViewModel, password);
    
    [self.signInButton setRac_command:self.signInViewModel.signInCommand];
    
//    RAC(self.signInButton, enabled) = self.signInViewModel.modelIsValidSignal;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    @weakify(self);
    
    // When the load command is executed, update our view accordingly
    [self.signInViewModel.signInCommand.executionSignals subscribeNext:^(id signal) {
        
        [signal subscribeNext:^(RACTuple * x) {
            @strongify(self);
            
            RACTupleUnpack(AFHTTPRequestOperation * operation, id response) = x;
            NSLog(@"xxx : %@", response);
        } error:^(NSError *error) {
            @strongify(self);
            
            NSLog(@"---- SignIn Error: %@", error);
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
                         visibleRect.origin.y += 20.0;
                         
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
