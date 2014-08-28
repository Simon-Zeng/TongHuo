//
//  THPostResultConfirmView.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-19.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THPostResultConfirmView.h"

#import "Orders+Access.h"
#import "LKPopupMenuController.h"

//
//是圆通快递（圆通单号由10位数字组成，目前常见以1**、2**、8**等开头）
//申通单号由12位数字组成，目前常见以268**、58**等开头
//中通单号由12位数字组成，目前常见以2008**、6**等开头
//韵达单号由13位数字组成，目前常见以10*、12*等开头
//顺丰单号由12位数字组成，目前常见以电话区号后三位开头

//
//圆通单号由10位数字组成，目前常见以1**、2**、8**等开头
//申通单号由12位数字组成，目前常见以368**、58**等开头
//中通单号由12位数字组成，目前常见以6800**、2008**等开头
//韵达单号由13位数字组成，目前常见以12*、10*等开头
//顺丰单号由12位数字组成，目前常见以电话区号后三位开头

@interface THPostResultConfirmView ()<UITextFieldDelegate,LKPopupMenuControllerDelegate>

@property (nonatomic, strong) NSString * company;

@property (nonatomic, strong) NSArray * deliveryCompanies;

@property (nonatomic, strong) UILabel * receiverBoxLabel;
@property (nonatomic, strong) UILabel * receiverLabel;
@property (nonatomic, strong) UITextField * companyField;
@property (nonatomic, strong) UILabel * codeValueLabel;
@property (nonatomic, strong) FUIButton * chooseButton;
@property (nonatomic, strong) FUIButton * submitButton;

@property (nonatomic, strong) LKPopupMenuController * popupMenu;

@end

@implementation THPostResultConfirmView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // Initialization code
        _deliveryCompanies = @[@"圆通",@"申通", @"中通", @"韵达", @"顺丰", @"邮政", @"EMS", @"其它"];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        titleLabel.font = [UIFont boldFlatFontOfSize:18.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"快递信息确认";
        
        [self addSubview:titleLabel];
        
        self.receiverBoxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), 80, 40)];
        self.receiverBoxLabel.font = [UIFont flatFontOfSize:14.0];
        self.receiverBoxLabel.backgroundColor = [UIColor clearColor];
        self.receiverBoxLabel.textAlignment = NSTextAlignmentRight;
        self.receiverBoxLabel.text = @"收件人:";
        
        [self addSubview:self.receiverBoxLabel];
        
        self.receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(titleLabel.frame), frame.size.width-90, 40)];
        self.receiverLabel.font = [UIFont flatFontOfSize:14.0];
        self.receiverLabel.backgroundColor = [UIColor clearColor];
        self.receiverLabel.textAlignment = NSTextAlignmentLeft;
        self.receiverLabel.text = nil;
        
        [self addSubview:self.receiverLabel];
        
        UILabel * companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.receiverBoxLabel.frame), 80, 40)];
        companyLabel.font = [UIFont flatFontOfSize:14.0];
        companyLabel.backgroundColor = [UIColor clearColor];
        companyLabel.textAlignment = NSTextAlignmentRight;
        companyLabel.text = @"快递公司:";
        
        [self addSubview:companyLabel];
        
        self.companyField = [[UITextField alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(self.receiverBoxLabel.frame) + 4, frame.size.width-130, 32)];
        self.companyField.delegate = self;
        self.companyField.font = [UIFont flatFontOfSize:14.0];
        self.companyField.returnKeyType = UIReturnKeyDone;
        [self addSubview:self.companyField];
        
        FUIButton * chooseButton = [FUIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake(frame.size.width - 42, CGRectGetMaxY(self.receiverBoxLabel.frame) + 4, 40, 32);
        chooseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        chooseButton.buttonColor = [UIColor colorWithRed:242.0/255
                                                   green:39.0/255
                                                    blue:131.0/255
                                                   alpha:1.0];
        chooseButton.shadowColor = [UIColor colorWithRed:175.0/255
                                                   green:179.0/255
                                                    blue:190.0/255
                                                   alpha:1.0];
        chooseButton.shadowHeight = 2.0f;
        chooseButton.highlightedColor = [UIColor colorWithRed:204.0/255
                                                        green:205.0/255
                                                         blue:210.0/255
                                                        alpha:1.0];
        chooseButton.cornerRadius = 4.0f;
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [chooseButton setTitle:NSLocalizedString(@"修改", nil)
                      forState:UIControlStateNormal];
        [chooseButton addTarget:self
                              action:@selector(chooseCompany:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:chooseButton];
        
        self.chooseButton = chooseButton;


        UILabel * codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(companyLabel.frame), 80, 40)];
        codeLabel.font = [UIFont flatFontOfSize:14.0];
        codeLabel.backgroundColor = [UIColor clearColor];
        codeLabel.textAlignment = NSTextAlignmentRight;
        codeLabel.text = @"快递单号:";
        
        [self addSubview:codeLabel];
        
        self.codeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(companyLabel.frame), frame.size.width-80, 40)];
        _codeValueLabel.font = [UIFont flatFontOfSize:14.0];
        _codeValueLabel.backgroundColor = [UIColor clearColor];
        _codeValueLabel.textAlignment = NSTextAlignmentLeft;
        _codeValueLabel.text = @"";
        
        [self addSubview:_codeValueLabel];

        FUIButton * submitButton = [FUIButton buttonWithType:UIButtonTypeCustom];
        submitButton.frame = CGRectMake(10, CGRectGetMaxY(codeLabel.frame) + 10, frame.size.width - 20, 37);
        submitButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        submitButton.buttonColor = [UIColor colorWithRed:242.0/255
                                                   green:39.0/255
                                                    blue:131.0/255
                                                   alpha:1.0];
        submitButton.shadowColor = [UIColor colorWithRed:175.0/255
                                                   green:179.0/255
                                                    blue:190.0/255
                                                   alpha:1.0];
        submitButton.shadowHeight = 2.0f;
        submitButton.highlightedColor = [UIColor colorWithRed:204.0/255
                                                        green:205.0/255
                                                         blue:210.0/255
                                                        alpha:1.0];
        submitButton.cornerRadius = 4.0f;
        
        [submitButton setTitle:NSLocalizedString(@"确    认", nil)
                      forState:UIControlStateNormal];
        [submitButton addTarget:self
                         action:@selector(confirmPostCode:)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:submitButton];
        
        self.submitButton = submitButton;
    }
    return self;
}

- (void)setPostCode:(NSString *)postCode
{
    if (_postCode != postCode)
    {
        _postCode = postCode;
        
        // Try to guess the company
        NSInteger length = postCode.length;
        
        switch (length) {
            case 10:
            {
                self.company = @"圆通";
            }
            break;
            
            case 12:
            {
                if ([postCode hasPrefix:@"268"] ||
                    [postCode hasPrefix:@"368"] ||
                    [postCode hasPrefix:@"58"])
                {
                    self.company = @"申通";
                }
                else if ([postCode hasPrefix:@"6800"] || [postCode hasPrefix:@"2008"])
                {
                    self.company = @"中通";
                }
                else
                {
                    self.company = @"顺丰";
                }
            }
            break;

            case 13:
            {
                self.company = @"韵达";
            }
            break;

            default:
            {
                self.company = @"其它";
            }
            break;
        }
        
        self.companyField.text = self.company;
        self.codeValueLabel.text = postCode;
    }
}

- (void)setAnOrder:(Orders *)anOrder
{
    if (_anOrder != anOrder)
    {
        _anOrder = anOrder;
        
        self.receiverLabel.text = anOrder.name;
    }
}

#pragma mark - IBAction

- (void)chooseCompany:(id)sender
{
    if (sender == self.chooseButton)
    {
        CGSize size = _chooseButton.frame.size;
        CGPoint origin = _chooseButton.frame.origin;
        CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                       CGRectGetMaxY(_chooseButton.frame));
        [self _popupAt:location arrangementMode:LKPopupMenuControllerArrangementModeLeft];
    }
}

- (void)confirmPostCode:(id)sender
{
    if (sender == self.submitButton)
    {
        if (self.resultBlock)
        {
            self.resultBlock(self.company, self.postCode);
        }
    }
}

- (void)_popupAt:(CGPoint)location arrangementMode:(LKPopupMenuControllerArrangementMode)arrangementMode
{
    if (self.popupMenu.popupmenuVisible) {
        [self.popupMenu dismiss];
    } else {
        if (self.popupMenu == nil) {
            self.popupMenu = [LKPopupMenuController popupMenuControllerOnView:self];
            self.popupMenu.textList = self.deliveryCompanies;
            self.popupMenu.delegate = self;
        }
        //        self.popupMenu.title = NSLocalizedString(@"选择店铺", nil);
        self.popupMenu.autoresizeEnabled = YES;
        self.popupMenu.autocloseEnabled = YES;
        self.popupMenu.bounceEnabled = NO;
        self.popupMenu.multipleSelectionEnabled = NO;
        self.popupMenu.arrangementMode = arrangementMode;
        self.popupMenu.animationMode = LKPopupMenuControllerAnimationModeSlide;
        self.popupMenu.modalEnabled = NO;
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
/**
 Tell the delegate that the specified row is now selected.
 
 @param popupMenuController The popup menu object requesting this information.
 @param index An index locating the new selected row in popup menu.
 */
- (void)popupMenuController:(LKPopupMenuController*)popupMenuController didSelectRowAtIndex:(NSUInteger)index
{
    self.company = [self.deliveryCompanies objectAtIndex:index];
    self.companyField.text = self.company;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

@end
