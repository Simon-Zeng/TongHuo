//
//  THTableViewGoodCell.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-4.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THTableViewGoodCell.h"

#import "Goods+Access.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface THTableViewGoodCell ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * addressLabel;

@end


@implementation THTableViewGoodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TongHuoCellBackground"]];
        self.selectedBackgroundView.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"TongHuoCellBackground"]] colorWithAlphaComponent:0.5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7, 65, 65)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.backgroundColor = [UIColor clearColor];
        self.iconView.layer.borderColor = [UIColor grayColor].CGColor;
        self.iconView.layer.borderWidth = 1.0;
        self.iconView.layer.cornerRadius = 4;
        self.iconView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.iconView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 3, 235, 18)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.textColor = [UIColor colorWithRed:248.0/255
                                                    green:254.0/255
                                                     blue:183.0/255
                                                    alpha:1.0];
        
        [self.contentView addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 22, 150, 15)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [UIFont flatFontOfSize:12];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:self.priceLabel];

        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 34, 230, 43)];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.font = [UIFont flatFontOfSize:12];
        self.addressLabel.textColor = [UIColor grayColor];
        self.addressLabel.numberOfLines = 2;
        
        [self.contentView addSubview:self.addressLabel];
        
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

- (void)updateWithGood:(Goods *)good atIndexPath:(NSIndexPath *)indexPath
{
    [self.iconView setImageWithURL:[NSURL URLWithString:good.picUrl]
                  placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    
    self.titleLabel.text = good.numIid.description;
    self.priceLabel.text = [NSString stringWithFormat:@"(%@)", good.price];
    self.addressLabel.text = good.title;
    
    [self layoutSubviews];

}

@end
