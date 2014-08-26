//
//  THTableViewPhoneCell.h
//  TongHuo
//
//  Created by zeng songgen on 14-8-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Orders;

@interface THTableViewPhoneCell : UITableViewCell

- (void)updateWithOrder:(Orders *)anOrder atIndexPath:(NSIndexPath *)indexPath;


@end
