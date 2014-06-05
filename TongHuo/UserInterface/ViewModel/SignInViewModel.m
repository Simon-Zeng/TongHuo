//
//  SignInViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "SignInViewModel.h"

#import "THAuthorizer.h"

@implementation SignInViewModel

@synthesize username = _username;
@synthesize password = _password;

@synthesize signInCommand = _signInCommand;

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
    
    _signInCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *networkSignal = [[THAuthorizer sharedAuthorizer] signInWithUsername:self.username
                                                                              password:self.password];
        
        return networkSignal;
    }];
}

-(RACSignal *)forbiddenNameSignal {
	@weakify(self);
	return [RACObserve(self,username) filter:^BOOL(NSString *newName) {
		@strongify(self);
		return ![self validateEmail:newName];
	}];
}

-(RACSignal *)modelIsValidSignal {
	@weakify(self);
	return [RACSignal
			combineLatest:@[ RACObserve(self,username), RACObserve(self,password) ]
			reduce:^id(NSString *name, NSString *pass){
				@strongify(self);
				return @((name.length > 0) &&
				([self validateEmail:name]) &&
				(pass.length > 0));
			}];
}

- (BOOL)validateEmail:(NSString *)email
{
    return YES;
}


@end
