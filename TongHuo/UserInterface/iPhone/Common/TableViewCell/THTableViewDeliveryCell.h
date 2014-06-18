//
//  THTableViewDeliveryCell.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-4.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface THTableViewDeliveryCell : UITableViewCell

- (void)updateWithProduct:(Product *)product atIndexPath:(NSIndexPath *)indexPath;

@end
