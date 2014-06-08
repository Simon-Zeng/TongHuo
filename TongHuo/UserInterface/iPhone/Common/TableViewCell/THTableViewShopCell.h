//
//  THTableViewShopCell.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-4.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Shops;

@interface THTableViewShopCell : UITableViewCell

- (void)updateWithShop:(Shops *)shop atIndexPath:(NSIndexPath *)indexPath;

@end
