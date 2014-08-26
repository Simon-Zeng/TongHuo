//
//  THTableViewPhoneCell.m
//  TongHuo
//
//  Created by zeng songgen on 14-8-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THTableViewPhoneCell.h"

#import "Orders+Access.h"
#import "Product+Access.h"

@interface THTableViewPhoneCell ()

@property (nonatomic, strong) Orders * anOrder;

@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UILabel * addressLabel;

@property (nonatomic, strong) FUIButton * deliveryButton;

@end

@implementation THTableViewPhoneCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FaHuoCellBackground"]];
        self.selectedBackgroundView.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"FaHuoCellBackground"]] colorWithAlphaComponent:0.5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 20)];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.font = [UIFont boldFlatFontOfSize:16];
        self.titleLable.numberOfLines = 1;
        self.titleLable.textColor = [UIColor colorWithRed:248.0/255
                                                    green:254.0/255
                                                     blue:183.0/255
                                                    alpha:1.0];
        
        [self.contentView addSubview:self.titleLable];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, 260, 20)];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.numberOfLines = 2;
        self.addressLabel.font = [UIFont boldFlatFontOfSize:13];
        self.addressLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.addressLabel];
        
        self.deliveryButton  = [FUIButton buttonWithType:UIButtonTypeCustom];
        self.deliveryButton.frame = CGRectMake(self.frame.size.width - 63, 8, 55, 31.0);
        self.deliveryButton.buttonColor = [UIColor colorWithRed:242.0/255
                                                          green:39.0/255
                                                           blue:131.0/255
                                                          alpha:1.0];
        self.deliveryButton.shadowColor = [UIColor colorWithRed:175.0/255
                                                          green:179.0/255
                                                           blue:190.0/255
                                                          alpha:1.0];
        self.deliveryButton.shadowHeight = 2.0f;
        self.deliveryButton.highlightedColor = [UIColor colorWithRed:204.0/255
                                                               green:205.0/255
                                                                blue:210.0/255
                                                               alpha:1.0];
        self.deliveryButton.cornerRadius = 4.0f;
        
        [self.deliveryButton setTitle:NSLocalizedString(@"打电话", nil)
                             forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font = [UIFont flatFontOfSize:14];
        [self.contentView addSubview:self.deliveryButton];
        
        [self.deliveryButton addTarget:self
                                action:@selector(call:)
                      forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.superview.backgroundColor = [UIColor clearColor]; // ScrollView is added in iOS7
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateWithOrder:(Orders *)anOrder atIndexPath:(NSIndexPath *)indexPath
{
    self.anOrder = anOrder;
    
    Product * product = [Product productWithCourier:anOrder.tno create:NO];
    
    self.titleLable.text = [NSString stringWithFormat:@"%@ - %@", anOrder.name, anOrder.cs];
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@", product.no, anOrder.color, anOrder.size];
    
    [self layoutSubviews];
}

- (void)call:(id)sender
{
    NSString * tel = [NSString stringWithFormat:@"tel://%@", self.anOrder.tel];
    
    NSURL * url = [NSURL URLWithString:tel];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        NSString * message = [NSString stringWithFormat:NSLocalizedString(@"电话号码%@是一个无效号码", nil), self.anOrder.tel];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                             message:message
                                                            delegate:nil
                                                   cancelButtonTitle:@"知道了"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
}

@end
