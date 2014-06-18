//
//  THTableViewDeliveryCell.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-4.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THTableViewDeliveryCell.h"

#import "Orders+Access.h"
#import "Product+Access.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface THTableViewDeliveryCell ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UILabel * addressLabel;

@property (nonatomic, strong) FUIButton * deliveryButton;

@end

@implementation THTableViewDeliveryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FaHuoCellBackground"]];
        self.selectedBackgroundView.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"FaHuoCellBackground"]] colorWithAlphaComponent:0.5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 55, 55)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.backgroundColor = [UIColor clearColor];
        self.iconView.layer.borderColor = [UIColor grayColor].CGColor;
        self.iconView.layer.borderWidth = 1.0;
        self.iconView.layer.cornerRadius = 4;
        self.iconView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.iconView];

        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(65, 8, 200, 20)];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.font = [UIFont boldFlatFontOfSize:16];
        self.titleLable.numberOfLines = 1;
        
        [self.contentView addSubview:self.titleLable];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 37, 200, 18)];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.font = [UIFont boldFlatFontOfSize:14];
        self.infoLabel.numberOfLines = 1;
        
        [self.contentView addSubview:self.infoLabel];

        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 60, 260, 45)];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.numberOfLines = 2;
        self.addressLabel.font = [UIFont boldFlatFontOfSize:13];
        self.addressLabel.textColor = [UIColor grayColor];
        
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
        
        [self.deliveryButton setTitle:NSLocalizedString(@"去发货", nil)
                      forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font = [UIFont flatFontOfSize:14];
        [self.contentView addSubview:self.deliveryButton];
        
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

- (void)updateWithProduct:(Product *)product atIndexPath:(NSIndexPath *)indexPath
{
    [self.iconView setImageWithURL:[NSURL URLWithString:product.pimage]
                  placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    
    Orders * order = [Orders orderWithId:@(product.pid.longLongValue)];
    
    self.titleLable.text = [NSString stringWithFormat:@"%@ - %@", product.buyer, order.cs];
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@, %@", order.sf, product.color, product.size];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ (%@)", order.address, order.tel];
    
    if (1 == order.state.longLongValue)
    {
        self.deliveryButton.hidden = YES;
    }
    else
    {
        self.deliveryButton.hidden = NO;
    }
    
    [self layoutSubviews];
}


@end
