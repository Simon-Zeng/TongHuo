//
//  THPostResultConfirmView.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-19.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Orders;

typedef void (^DidGetPostResultBlock) (NSString * company, NSString * code);

@interface THPostResultConfirmView : UIView

@property (nonatomic, strong) NSString * postCode;
@property (nonatomic, strong) Orders * anOrder;
@property (nonatomic, copy) DidGetPostResultBlock resultBlock;

@end
