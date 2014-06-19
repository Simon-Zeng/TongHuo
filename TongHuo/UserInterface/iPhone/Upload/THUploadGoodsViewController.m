//
//  THUploadGoodsViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THUploadGoodsViewController.h"

#import "Goods+Access.h"
#import "Platforms+Access.h"
#import "THAuthorizer.h"
#import "UploadViewModel.h"

#import "LKPopupMenuController.h"

@interface THUploadGoodsViewController () <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, LKPopupMenuControllerDelegate>

@property (nonatomic, strong) UIScrollView * contentView;

@property (nonatomic, strong) UITextField * shopTextField;
@property (nonatomic, strong) UITextField * sellerTextField;
@property (nonatomic, strong) UITextField * priceTextField;
@property (nonatomic, strong) UITextView * titleTextView;

@property (nonatomic, strong) FUIButton * uploadButton;

@property (nonatomic, strong) LKPopupMenuController * popupMenu;
@property (nonatomic, strong) NSArray * tbOptions;

@end

@implementation THUploadGoodsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    
    UIView * view = [[UIView alloc] initWithFrame:windowFrame];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:windowFrame];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentView.contentSize = windowFrame.size;
    
    [view addSubview:self.contentView];
    
    CGFloat offsetY = 20.0;
    
    // Shop
    UILabel * shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, offsetY, 65, 31)];
    shopLabel.backgroundColor = [UIColor clearColor];
    shopLabel.font = [UIFont flatFontOfSize:14];
    shopLabel.textAlignment = NSTextAlignmentRight;
    shopLabel.text = NSLocalizedString(@"选择店铺: ", nil);
    [self.contentView addSubview:shopLabel];
    
    self.shopTextField = [[UITextField alloc] initWithFrame:CGRectMake(82, offsetY, 218, 31)];
    self.shopTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.shopTextField.returnKeyType = UIReturnKeyNext;
    self.shopTextField.delegate = self;
    
    [self.contentView addSubview:self.shopTextField];
    
    offsetY += 45;
    // Seller
    UILabel * sellerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, offsetY, 65, 31)];
    sellerLabel.backgroundColor = [UIColor clearColor];
    sellerLabel.font = [UIFont flatFontOfSize:14];
    sellerLabel.textAlignment = NSTextAlignmentRight;
    sellerLabel.text = NSLocalizedString(@"商家编码: ", nil);
    [self.contentView addSubview:sellerLabel];
    
    self.sellerTextField = [[UITextField alloc] initWithFrame:CGRectMake(82, offsetY, 218, 31)];
    self.sellerTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.sellerTextField.returnKeyType = UIReturnKeyNext;
    self.sellerTextField.delegate = self;
    
    [self.contentView addSubview:self.sellerTextField];
    
    
    offsetY += 45;
    // Price
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, offsetY, 65, 31)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont flatFontOfSize:14];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.text = NSLocalizedString(@"商品价格: ", nil);
    [self.contentView addSubview:priceLabel];
    
    self.priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(82, offsetY, 218, 31)];
    self.priceTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.priceTextField.returnKeyType = UIReturnKeyNext;
    self.priceTextField.delegate = self;
    
    [self.contentView addSubview:self.priceTextField];
    
    offsetY += 45;
    // Title
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, offsetY, 65, 31)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont flatFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = NSLocalizedString(@"商品标题: ", nil);
    [self.contentView addSubview:titleLabel];
    
    self.titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(82, offsetY, 218, 131)];
    self.titleTextView.returnKeyType = UIReturnKeyDefault;
    self.titleTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleTextView.layer.borderWidth = 1;
    self.titleTextView.layer.cornerRadius = 4.0;
    self.titleTextView.layer.masksToBounds = YES;
    self.titleTextView.delegate = self
    ;
    [self.contentView addSubview:self.titleTextView];
    
    offsetY += 150;
    // Upload button
    self.uploadButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    self.uploadButton.frame = CGRectMake(30, offsetY, 260, 37);
    self.uploadButton.buttonColor = [UIColor colorWithRed:242.0/255
                                                    green:39.0/255
                                                     blue:131.0/255
                                                    alpha:1.0];
    self.uploadButton.shadowColor = [UIColor colorWithRed:175.0/255
                                                    green:179.0/255
                                                     blue:190.0/255
                                                    alpha:1.0];
    self.uploadButton.shadowHeight = 2.0f;
    self.uploadButton.highlightedColor = [UIColor colorWithRed:204.0/255
                                                         green:205.0/255
                                                          blue:210.0/255
                                                         alpha:1.0];
    self.uploadButton.cornerRadius = 4.0f;
    self.uploadButton.opaque = YES;
    
    [self.uploadButton setTitle:NSLocalizedString(@"一键上传", nil)
                       forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.uploadButton];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = [NSString stringWithFormat:@"上传——%@", self.viewModel.good.title];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.delegate = self;
    
    [self.contentView addGestureRecognizer:tapRecognizer];
    
    NSArray * platforms = [THAuthorizer sharedAuthorizer].platforms;
    
    NSMutableArray * platformNames = [[NSMutableArray alloc] init];
    for (Platforms * aPlatform in platforms)
    {
        [aPlatform willAccessValueForKey:nil];
        [platformNames addObject:aPlatform.name];
    }
    
    self.tbOptions = platformNames;
    
    self.shopTextField.text = [self.tbOptions firstObject];
    self.priceTextField.text = self.viewModel.price;
    self.titleTextView.text = self.viewModel.title;

    // RAC bindings
    
    RAC(self.viewModel, title) = self.titleTextView.rac_textSignal;
    RAC(self.viewModel, tid) = [self.shopTextField.rac_textSignal map:^id(NSString *tbShop){
        return [[THAuthorizer sharedAuthorizer] authorizenCodeFor:tbShop];
    }];
    RAC(self.viewModel, price) = self.priceTextField.rac_textSignal;
    RACChannelTo(self.sellerTextField,text) = RACChannelTo(self.viewModel,sellerCode);
    
    @weakify(self);
    [self.viewModel.uploadCommand.executing subscribeNext:^(NSNumber * x) {
        @strongify(self);
        if(x.boolValue)
        {
            [self.view endEditing:YES];
            [SVProgressHUD showWithStatus:@"请稍候..." maskType:SVProgressHUDMaskTypeGradient];
        }
    }];
    self.uploadButton.rac_command = self.viewModel.uploadCommand;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    @weakify(self);
    
    
    // When the load command is executed, update our view accordingly
    [self.viewModel.uploadCommand.executionSignals subscribeNext:^(id signal) {
        
        [signal subscribeNext:^(RACTuple * x) {
            AFHTTPRequestOperation * operation = x[0];
            NSLog(@"----- Upload response: %@", operation.responseString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
    
    [self.viewModel.uploadCommand.errors subscribeNext:^(NSError * err) {
        @strongify(self);
        
        [self showUploadFailedAlertWithError:nil];
    }];
}

- (void)showUploadFailedAlertWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
        
        NSString * message = @"上传失败，请稍后再试！";
        if (error)
        {
            message = [NSString stringWithFormat:@"上传失败，错误: %@", error];
        }
        
        AMSmoothAlertView * alertView = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"警告"
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
#pragma mark Actions
- (void)_popupAt:(CGPoint)location arrangementMode:(LKPopupMenuControllerArrangementMode)arrangementMode
{
    if (self.popupMenu.popupmenuVisible) {
        [self.popupMenu dismiss];
    } else {
        if (self.popupMenu == nil) {
            self.popupMenu = [LKPopupMenuController popupMenuControllerOnView:self.view];
            self.popupMenu.textList = self.tbOptions;
            self.popupMenu.delegate = self;
        }
//        self.popupMenu.title = NSLocalizedString(@"选择店铺", nil);
        self.popupMenu.autoresizeEnabled = YES;
        self.popupMenu.autocloseEnabled = YES;
        self.popupMenu.bounceEnabled = NO;
        self.popupMenu.multipleSelectionEnabled = NO;
        self.popupMenu.arrangementMode = arrangementMode;
        self.popupMenu.animationMode = LKPopupMenuControllerAnimationModeSlide;
        self.popupMenu.modalEnabled = YES;
        self.popupMenu.closeButtonEnabled = NO;
        
        LKPopupMenuAppearance* appearance = [LKPopupMenuAppearance defaultAppearanceWithSize:LKPopupMenuControllerSizeMedium
                                                                                       color:LKPopupMenuControllerColorDefault];
        appearance.shadowEnabled = YES;
        appearance.triangleEnabled = YES;
        appearance.separatorEnabled = YES;
        appearance.outlineEnabled = YES;
        appearance.titleHighlighted = YES;
        appearance.titleTextColor = [UIColor whiteColor];
        self.popupMenu.appearance = appearance;
        // test auto resizing
        //        self.popupMenu.appearance.listWidth = 1000.0;
        //        self.popupMenu.appearance.listHeight = 1000.0;
        
        [self.popupMenu presentPopupMenuFromLocation:location];
    }
}

#pragma mark -
- (void)tapped:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    
    [self didEndEditing];
}

- (void)didEndEditing
{
    CGRect windowRect = self.view.bounds;
    
    self.contentView.frame = windowRect;
    self.contentView.contentOffset = CGPointZero;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.shopTextField)
    {
        
        CGSize size = textField.frame.size;
        CGPoint origin = textField.frame.origin;
        CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                       CGRectGetMaxY(textField.frame));
        [self _popupAt:location arrangementMode:LKPopupMenuControllerArrangementModeDown];
        
        return NO;
    }
    
    return YES;
}
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
    [self didEndEditing];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.shopTextField)
    {
        [self.sellerTextField becomeFirstResponder];
    }
    else if(textField == self.sellerTextField)
    {
        [self.priceTextField becomeFirstResponder];
    }
    else if(textField == self.priceTextField)
    {
        [self.titleTextView becomeFirstResponder];
    }
    else
    {
        [self.shopTextField resignFirstResponder];
        [self.sellerTextField resignFirstResponder];
        [self.priceTextField resignFirstResponder];
        [self.titleTextView resignFirstResponder];
    }
    
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         CGRect windowRect = self.view.bounds;
                         
                         self.contentView.frame = CGRectMake(0, 0, windowRect.size.width, windowRect.size.height - 216.0);
                         
                         CGRect visibleRect = textView.frame;
                         visibleRect.origin.y += 65.0;
                         
                         [self.contentView scrollRectToVisible:visibleRect animated:NO];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self didEndEditing];
}

#pragma mark - LKPopupMenuControllerDelegate
/**
 Tell the delegate that the specified row is now selected.
 
 @param popupMenuController The popup menu object requesting this information.
 @param index An index locating the new selected row in popup menu.
 */
- (void)popupMenuController:(LKPopupMenuController*)popupMenuController didSelectRowAtIndex:(NSUInteger)index
{
    NSString * shopName = [self.tbOptions objectAtIndex:index];
    self.shopTextField.text = shopName;
    
//    self.viewModel.tid = [[THAuthorizer sharedAuthorizer] authorizenCodeFor:shopName];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self.contentView];
    
    if (CGRectContainsPoint(self.shopTextField.frame, touchPoint))
    {
        return NO;
    }
    if (CGRectContainsPoint(self.sellerTextField.frame, touchPoint))
    {
        return NO;
    }
    if (CGRectContainsPoint(self.priceTextField.frame, touchPoint))
    {
        return NO;
    }
    if (CGRectContainsPoint(self.titleTextView.frame, touchPoint))
    {
        return NO;
    }
    
    return YES;
}

@end
