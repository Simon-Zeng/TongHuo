//
//  UploadViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "UploadViewModel.h"

#import "THAPI.h"
#import "THAuthorizer.h"
#import "Goods+Access.h"
#import "Platforms+Access.h"

@implementation UploadViewModel

- (id)init
{
    if (self = [super init])
    {
        [self commandInit];
    }
    
    return self;
}

- (id)initWithModel:(id)model
{
    if (self = [super initWithModel:model])
    {
        [self commandInit];
    }
    
    return self;
}

- (void)commandInit
{
    @weakify(self);
    
    _uploadCommand = [[RACCommand alloc] initWithEnabled:[self modelIsValidSignal]
                                             signalBlock:^RACSignal *(id input) {
                                                 @strongify(self);
                                                 RACSignal *networkSignal = [[THAPI apiCenter] postTBProduct:self.good
                                                                                                    withCode:self.sellerCode
                                                                                                    toTBShop:self.tid];
                                                 
                                                 return networkSignal;
                                             }];
}

- (void)setGood:(Goods *)goods
{
    if (goods != _good)
    {
        _good = goods;
        
        [goods willAccessValueForKey:nil];
        
        self.title = goods.title;
        self.price = goods.price.description;
        
        @weakify(self);
        [[[THAPI apiCenter] getSellerCodeFor:goods.numIid] subscribeNext:^(id x) {
            @strongify(self);
            
            NSString * responseString = x;
            if ([x isKindOfClass:[NSData class]])
            {
                responseString = [[NSString alloc] initWithData:x encoding:NSUTF8StringEncoding];
            }
            
            NSLog(@"---- Reponse String: %@", responseString);
            
            if (responseString && [responseString isKindOfClass:[NSString class]])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.sellerCode = responseString;
                });            }
        } error:^(NSError *error) {
            NSLog(@"---- error: %@", error);
        }];
    }
}

-(RACSignal *)modelIsValidSignal {
	@weakify(self);
	return [RACSignal
			combineLatest:@[ RACObserve(self,title), RACObserve(self,tid), RACObserve(self, sellerCode), RACObserve(self, price) ]
			reduce:^id(NSString *title, NSNumber *tid, NSString * sellerCode, NSString *price){
				@strongify(self);
                
                BOOL isValid = (title.length > 0 && tid.longLongValue > 0 && sellerCode.length > 0 && price.length > 0);
                
                if (isValid && (isValid = [self validatePrice:price]))
                {
                    
                }
                
                return @(isValid);
			}];
}

- (BOOL)validatePrice:(NSString *)price
{
    return YES;
}


@end
