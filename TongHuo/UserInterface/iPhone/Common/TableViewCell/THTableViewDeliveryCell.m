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

@property (nonatomic, strong, readwrite) RACSubject * scanPostSignal;

@property (nonatomic, strong) Orders * anOrder;

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UILabel * stateLabel;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UILabel * expressLabel;
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
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 65, 65)];
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
        self.titleLable.textColor = [UIColor colorWithRed:248.0/255
                                                    green:254.0/255
                                                     blue:183.0/255
                                                    alpha:1.0];
        
        [self.contentView addSubview:self.titleLable];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 8, 60, 20)];
        self.stateLabel.backgroundColor = [UIColor clearColor];
        self.stateLabel.font = [UIFont boldFlatFontOfSize:16];
        self.stateLabel.numberOfLines = 1;
        self.stateLabel.textColor = [UIColor redColor];
        
        [self.contentView addSubview:self.stateLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 200, 18)];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.font = [UIFont boldFlatFontOfSize:14];
        self.infoLabel.numberOfLines = 1;
        self.infoLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.infoLabel];
        
        self.expressLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 50, 200, 18)];
        self.expressLabel.backgroundColor = [UIColor clearColor];
        self.expressLabel.font = [UIFont boldFlatFontOfSize:14];
        self.expressLabel.numberOfLines = 1;
        self.expressLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.expressLabel];

        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 68, 260, 35)];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.numberOfLines = 2;
        self.addressLabel.font = [UIFont boldFlatFontOfSize:13];
        self.addressLabel.textColor = [UIColor colorWithRed:248.0/255
                                                    green:254.0/255
                                                     blue:183.0/255
                                                    alpha:1.0];
        
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
        
        [self.deliveryButton addTarget:self
                                action:@selector(deliveryOrder:)
                      forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.superview.backgroundColor = [UIColor clearColor]; // ScrollView is added in iOS7
        
        _scanPostSignal = [RACSubject subject];

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
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:product.pimage]
                  placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    
    self.titleLable.text = [NSString stringWithFormat:@"%@ - %@", anOrder.name, anOrder.cs];
    self.infoLabel.text = [NSString stringWithFormat:@"%@, %@, %@", anOrder.sf, anOrder.color, anOrder.size];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ (%@)", anOrder.address, anOrder.tel];
    
    if (1 == anOrder.state.longLongValue)
    {
        if (anOrder.tb.longLongValue == 1)
        {
            self.stateLabel.text = NSLocalizedString(@"已同步", nil);
            self.stateLabel.textColor = [UIColor greenColor];
        }
        else
        {
            self.stateLabel.text = NSLocalizedString(@"未同步", nil);
            self.stateLabel.textColor = [UIColor redColor];
        }
        self.stateLabel.hidden = NO;
        self.expressLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@: %@", nil), anOrder.ktype, anOrder.kno];
        self.deliveryButton.hidden = YES;
    }
    else
    {
        self.stateLabel.hidden = YES;
        self.expressLabel.hidden = YES;
        self.deliveryButton.hidden = NO;
    }
    
    [self layoutSubviews];
}

- (void)deliveryOrder:(UIButton *)sender
{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    [(RACSubject *)_scanPostSignal sendNext:self.anOrder];
}


@end
