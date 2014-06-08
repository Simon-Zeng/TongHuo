//
//  THTableViewGoodCell.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-4.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THTableViewGoodCell.h"

#import "Goods+Access.h"

@interface THTableViewGoodCell ()

@property (nonatomic, strong) UILabel * indexLabel;
@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UILabel * addressLabel;

@end


@implementation THTableViewGoodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MarketCellBackground"]];
        self.selectedBackgroundView.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"MarketCellBackground"]] colorWithAlphaComponent:0.5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 50, 30)];
        self.indexLabel.backgroundColor = [UIColor clearColor];
        self.indexLabel.font = [UIFont boldFlatFontOfSize:24];
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        self.indexLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.indexLabel];
        
        UIImageView * separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Separator"]];
        separatorView.frame = CGRectMake(50.0, 11.0, 1, 35.0);
        
        [self.contentView addSubview:separatorView];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(55, 3, 265, 20)];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.font = [UIFont boldFlatFontOfSize:16];
        self.titleLable.numberOfLines = 1;
        self.titleLable.textColor = [UIColor yellowColor];
        
        [self.contentView addSubview:self.titleLable];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 265, 37)];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.font = [UIFont boldFlatFontOfSize:12];
        self.addressLabel.textColor = [UIColor grayColor];
        
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
    self.indexLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    self.titleLable.text = good.title;
    self.addressLabel.text = [NSString stringWithFormat:@"价格: %@", good.price];
    
    [self layoutSubviews];

}

@end
