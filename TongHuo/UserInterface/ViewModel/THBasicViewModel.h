//
//  THBasicViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-3.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "RVMViewModel.h"

#import <CoreData/CoreData.h>

@protocol THBasicViewModelCoreDataProtocol <NSObject>

@optional

- (NSFetchRequest *)fetchRequest;

- (NSString *)sectionNameKeyForEntity;
- (NSString *)chacheName;

@end

@interface THBasicViewModel : RVMViewModel<THBasicViewModelCoreDataProtocol>


@property (nonatomic, readonly) RACSignal *updatedContentSignal;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly, nonatomic) NSManagedObjectContext *model;


// Calls -initWithModel: with a nil model.
- (instancetype)init;

// Creates a new view model with the given model.
//
// model - The model to adapt for the UI. This argument may be nil.
//
// Returns an initialized view model, or nil if an error occurs.
- (instancetype)initWithModel:(id)model;

@end
