//
//  THZoomPopup.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface THZoomPopup : NSObject


@property (nonatomic) CGFloat borderSize;
@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic) CGFloat shadowRadius;
@property (nonatomic) CGFloat backGroundAlpha;
@property (nonatomic) BOOL showCloseButton;
@property (nonatomic) NSInteger blurRadius;


+ (THZoomPopup*) sharedInstance;


+(void) initWithMainview: (UIView*) mainView andStartRect: (CGRect) rect;
+(void) showPopup: (UIView*) popupView ;
+(void) closePopup;

+(void) setBorderSize: (CGFloat) borderSize;
+(void) setBorderColor: ( UIColor*) borderColor;
+(void) setShadowRadius: ( CGFloat) shadowRadius;
+(void) setBackgroundAlpha: (CGFloat) backGroundAlpha;
+(void) showCloseButton: (BOOL) showCloseButton;


-(id) initWithMainview: (UIView*) mainView andStartRect: (CGRect) rect;
-(void) showPopup: (UIView*) popupView ;
-(void) closePopup;

@end
