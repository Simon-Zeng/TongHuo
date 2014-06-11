//
//  THUISwitch.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-12.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THUISwitch.h"

@implementation THUISwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) updateBackground {
    if (self.on)
    {
        self.backgroundColor = self.onBackgroundColor;
    }
    else
    {
        self.backgroundColor = self.offBackgroundColor;
    }
//    
//    UIColor *contentColor = [UIColor blendedColorWithForegroundColor:self.onColor
//                                                     backgroundColor:self.offColor
//                                                        percentBlend:self.percentOn];

    self.onLabel.textColor = self.onColor;
    self.offLabel.textColor = self.offColor;
}

@end
