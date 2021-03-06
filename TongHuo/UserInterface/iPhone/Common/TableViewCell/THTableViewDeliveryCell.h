//
//  THTableViewDeliveryCell.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-4.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Orders;

@interface THTableViewDeliveryCell : UITableViewCell

@property (nonatomic, strong, readonly) RACSignal * scanPostSignal;

- (void)updateWithOrder:(Orders *)anOrder atIndexPath:(NSIndexPath *)indexPath;

@end
