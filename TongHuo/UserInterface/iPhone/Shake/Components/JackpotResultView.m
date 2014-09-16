//
//  JackpotResultView.m
//  TongHuo
//
//  Created by zeng songgen on 14-8-18.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "JackpotResultView.h"

@interface JackpotResultView ()

@property (nonatomic, strong) UILabel * lastJackpotLabel;
@property (nonatomic, strong) UILabel * totalLabel;

@end

@implementation JackpotResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.lastJackpotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        self.lastJackpotLabel.backgroundColor = [UIColor clearColor];
        self.lastJackpotLabel.textColor = [UIColor whiteColor];
        self.lastJackpotLabel.font = [UIFont systemFontOfSize:14.0];
        self.lastJackpotLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.lastJackpotLabel];
        
        self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, frame.size.width-60, 40)];
        self.totalLabel.backgroundColor = [UIColor clearColor];
        self.totalLabel.textColor = [UIColor whiteColor];
        self.totalLabel.numberOfLines = 0;
        self.totalLabel.font = [UIFont systemFontOfSize:12.0];
        self.totalLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.totalLabel];
    }
    return self;
}

- (void)updateJackpotResultWithTotal:(NSNumber *)total last:(NSNumber *)last message:(NSString *)format
{
    NSMutableString * message = [[NSMutableString alloc] init];
    
    if (format)
    {
        [message appendString:format];
    }
    
    if(total)
    {
        [message replaceOccurrencesOfString:@"{0}"
                                 withString:[total stringValue]
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, message.length)];
    }
    if(last)
    {
        [message replaceOccurrencesOfString:@"{1}"
                                 withString:[last stringValue]
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, message.length)];
    }

    self.totalLabel.text = message;
    self.lastJackpotLabel.hidden = YES;
    
//    if (total) {
//        self.totalLabel.hidden = NO;
//        self.totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"您有%@个快递单需领取，请到天河女人街D322领取.", nil), total];
//    }
//    else
//    {
//        self.totalLabel.hidden = YES;
//    }
//    
//    if (last) {
//        self.lastJackpotLabel.hidden = NO;
//        self.lastJackpotLabel.text = [NSString stringWithFormat:NSLocalizedString(@"本次摇中%@个", nil), last];
//    }
//    else
//    {
//        self.lastJackpotLabel.hidden = YES;
//    }

}

@end
