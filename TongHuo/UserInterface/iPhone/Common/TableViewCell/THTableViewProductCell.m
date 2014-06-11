//
//  THTableViewOrderCell.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-4.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THTableViewProductCell.h"


#import "Product+Access.h"
#import "THUISwitch.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface THTableViewProductCell ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UILabel * infoLabel;

@property (nonatomic, strong) THUISwitch * deliveredSwitch;

@end

@implementation THTableViewProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TongHuoCellBackground"]];
        self.selectedBackgroundView.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"TongHuoCellBackground"]] colorWithAlphaComponent:0.5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 65, 65)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.backgroundColor = [UIColor clearColor];
        self.iconView.layer.borderColor = [UIColor grayColor].CGColor;
        self.iconView.layer.borderWidth = 1.0;
        self.iconView.layer.cornerRadius = 4;
        self.iconView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.iconView];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 200, 20)];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.font = [UIFont boldFlatFontOfSize:16];
        self.titleLable.numberOfLines = 1;
        
        [self.contentView addSubview:self.titleLable];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 37, 120, 18)];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.font = [UIFont boldFlatFontOfSize:14];
        self.infoLabel.numberOfLines = 1;
        
        [self.contentView addSubview:self.infoLabel];
        
        self.deliveredSwitch  = [[THUISwitch alloc] init];
        self.deliveredSwitch.frame = CGRectMake(self.frame.size.width - 90, 8, 75, 24.0);
        self.deliveredSwitch.onBackgroundColor = [UIColor colorWithRed:224.0/255
                                                                 green:35.0/255
                                                                  blue:122.0/255
                                                                 alpha:1.0];

        self.deliveredSwitch.offBackgroundColor = [UIColor colorWithRed:129.0/255
                                                          green:122.0/255
                                                           blue:161.0/255
                                                          alpha:1.0];
        self.deliveredSwitch.onColor = [UIColor whiteColor];
        self.deliveredSwitch.offColor = [UIColor whiteColor];

        self.deliveredSwitch.switchCornerRadius = 4.0f;
        self.deliveredSwitch.onLabel.text = NSLocalizedString(@"已提货", nil);
        
        self.deliveredSwitch.offLabel.text = NSLocalizedString(@"未提货", nil);

        [self.contentView addSubview:self.deliveredSwitch];
        
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
    
    self.titleLable.text = product.buyer;
    self.infoLabel.text = [NSString stringWithFormat:@"%@, %@", product.color, product.size];
    
    if (1 == product.state.longLongValue)
    {
        self.deliveredSwitch.on = YES;
    }
    else
    {
        self.deliveredSwitch.on = NO;
    }
    
    [self layoutSubviews];
}


@end
