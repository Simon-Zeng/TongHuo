//
//  THTableViewOrderCell.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-4.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THTableViewProductCell.h"

#import "Orders+Access.h"
#import "Product+Access.h"
#import "THUISwitch.h"
#import "THZoomPopup.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface THTableViewProductCell ()

@property (nonatomic, strong) Product * product;

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UILabel * countLabel;

@property (nonatomic, strong) FUIButton * deliveredButton;
@property (nonatomic, strong) FUIButton * undeliveredButton;

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
        self.iconView.userInteractionEnabled = YES;
        
        // Tap
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(showDetailImage:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [self.iconView addGestureRecognizer:tapRecognizer];
        
        
        [self.contentView addSubview:self.iconView];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 200, 20)];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.font = [UIFont boldFlatFontOfSize:16];
        self.titleLable.numberOfLines = 1;
        self.titleLable.userInteractionEnabled = YES;
        
        self.titleLable.textColor = [UIColor colorWithRed:248.0/255
                                                    green:254.0/255
                                                     blue:183.0/255
                                                    alpha:1.0];
        
        [self.contentView addSubview:self.titleLable];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 37, 120, 18)];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.font = [UIFont boldFlatFontOfSize:14];
        self.infoLabel.numberOfLines = 1;
        self.infoLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.infoLabel];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 90, 8, 75, 20)];
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.textAlignment = NSTextAlignmentRight;
        self.countLabel.font = [UIFont flatFontOfSize:13];
        self.countLabel.textColor = [UIColor colorWithRed:139/255.0
                                                    green:17/255.0
                                                     blue:1/255.0
                                                    alpha:1.0];
        self.countLabel.numberOfLines = 1;
        
        [self.contentView addSubview:self.countLabel];
        
        self.deliveredButton  = [FUIButton buttonWithType:UIButtonTypeCustom];
        self.deliveredButton.frame = CGRectMake(self.frame.size.width - 118, 35, 55, 31.0);
        self.deliveredButton.buttonColor = [UIColor colorWithRed:242.0/255
                                                          green:39.0/255
                                                           blue:131.0/255
                                                          alpha:1.0];
        self.deliveredButton.shadowColor = [UIColor colorWithRed:175.0/255
                                                          green:179.0/255
                                                           blue:190.0/255
                                                          alpha:1.0];
        self.deliveredButton.shadowHeight = 2.0f;
        self.deliveredButton.highlightedColor = [UIColor colorWithRed:204.0/255
                                                               green:205.0/255
                                                                blue:210.0/255
                                                               alpha:1.0];
        self.deliveredButton.cornerRadius = 4.0f;
        
        [self.deliveredButton setTitle:NSLocalizedString(@"已提货", nil)
                             forState:UIControlStateNormal];
        self.deliveredButton.titleLabel.font = [UIFont flatFontOfSize:14];
        [self.deliveredButton addTarget:self
                                 action:@selector(deliveredProduct:)
                       forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deliveredButton];

        
        self.undeliveredButton  = [FUIButton buttonWithType:UIButtonTypeCustom];
        self.undeliveredButton.frame = CGRectMake(self.frame.size.width - 63, 35, 55, 31.0);
        self.undeliveredButton.buttonColor = [UIColor colorWithRed:131.0/255
                                                          green:139.0/255
                                                           blue:131.0/255
                                                          alpha:1.0];
        self.undeliveredButton.shadowColor = [UIColor colorWithRed:175.0/255
                                                          green:179.0/255
                                                           blue:190.0/255
                                                          alpha:1.0];
        self.undeliveredButton.shadowHeight = 2.0f;
        self.undeliveredButton.highlightedColor = [UIColor colorWithRed:204.0/255
                                                               green:205.0/255
                                                                blue:210.0/255
                                                               alpha:1.0];
        self.undeliveredButton.cornerRadius = 4.0f;
        
        [self.undeliveredButton setTitle:NSLocalizedString(@"未提货", nil)
                             forState:UIControlStateNormal];
        self.undeliveredButton.titleLabel.font = [UIFont flatFontOfSize:14];
        [self.undeliveredButton addTarget:self
                                 action:@selector(delayDeliveryProduct:)
                       forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.undeliveredButton];

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
    self.product = product;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:product.pimage]
                  placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    
    self.titleLable.text = product.no;
    self.infoLabel.text = [NSString stringWithFormat:@"%@, %@", product.color, product.size];
    self.countLabel.text = [NSString stringWithFormat:@"%@ 件", product.count];
    
    if (product.state.longLongValue == 1)
    {
        self.undeliveredButton.hidden = YES;
    }
    else
    {
        self.undeliveredButton.hidden = NO;
    }
    
    [self layoutSubviews];
}

- (void)showDetailImage:(UITapGestureRecognizer *)recognizer
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 84, 280, self.window.bounds.size.height - 104)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.product.pimage]
              placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    
    CGRect startRect = [self.iconView convertRect:self.iconView.frame toView:self.window];
    
    [THZoomPopup initWithMainview:self.window andStartRect:startRect];
    [THZoomPopup showPopup:imageView];
}

- (void)deliveredProduct:(id)sender
{
    NSManagedObjectContext * mainContext = [THCoreDataStack defaultStack].managedObjectContext;
    
    [mainContext performBlock:^{
        self.product.state = @2;
        
        [[THCoreDataStack defaultStack] saveContext];
    }];
}
- (void)delayDeliveryProduct:(id)sender
{
    NSManagedObjectContext * mainContext = [THCoreDataStack defaultStack].managedObjectContext;
    
    [mainContext performBlock:^{
        self.product.state = @1;
        
        [[THCoreDataStack defaultStack] saveContext];
    }];
}

@end
