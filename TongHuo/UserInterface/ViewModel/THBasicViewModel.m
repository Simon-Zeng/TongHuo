//
//  THBasicViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-3.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

#import "THCoreDataStack.h"

@interface THBasicViewModel () <NSFetchedResultsControllerDelegate>

@property (nonatomic, readwrite, strong) RACSubject *updatedContentSignal;

@property (nonatomic, readwrite, strong) NSNumber * uid;

@property (nonatomic, strong) id observer;

@end

@implementation THBasicViewModel

@synthesize model = _model;

- (id)init {
	return [self initWithModel:nil];
}

- (id)initWithModel:(id)model {
	self = [super init];
	if (self == nil) return nil;
    
	_model = model;
    
    self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"%@ updatedContentSignal",NSStringFromClass([self class])];
    
    @weakify(self)
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        if(self.fetchedResultsController)
        {
            [self updateFetchRequest];
        }
        
        [self.fetchedResultsController performFetch:nil];
    }];
    
    THAuthorizer * authorizer = [THAuthorizer sharedAuthorizer];
    
    [authorizer.updateSignal subscribeNext:^(NSManagedObjectID * x) {
        @strongify(self);
        
        Account * account = nil;
        
        if (x)
        {
            account = (Account *)[[THCoreDataStack defaultStack].threadManagedObjectContext objectWithID:x];
        }
        
        self.uid = account.identifier;
    }];
    
	return self;
}

- (void)dealloc
{
    if (_observer)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:_observer];
    }
}

- (void)updateFetchRequest
{
    NSAssert(NO, @"This method should be override in subclass");
}

- (void)updateFetchRequestWithCriteria:(NSDictionary *)criteria
{
    NSFetchRequest * fetchRequest = self.fetchedResultsController.fetchRequest;
    
    if (fetchRequest)
    {
        NSMutableArray * predicates = [[NSMutableArray alloc] init];
        
        for (NSString * key in criteria)
        {
            NSPredicate * predicate = nil;
            
            id value = [criteria objectForKey:key];
            
            if ([value isKindOfClass:[NSArray class]])
            {
                id realValue = [value firstObject];
                NSString * relation = [value lastObject];
                
                if (realValue == relation) // default = used
                {
                    predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, realValue];
                }
                else
                {
                    NSString * format = [NSString stringWithFormat:@"%%K %@ %%@", relation];
                    predicate = [NSPredicate predicateWithFormat:format, key, realValue];
                }
            }
            else
            {
                predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
            }
            
            [predicates addObject:predicate];
        }
        
        NSCompoundPredicate * compoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                                              subpredicates:predicates];
#if DEBUG
        NSLog(@"+++++ Query %@ using: %@", fetchRequest.entityName, compoundPredicate);
#endif
        fetchRequest.predicate = compoundPredicate;
    }
}

#pragma mark - THBasicViewModelCoreDataProtocol

- (NSFetchRequest *)fetchRequest
{
    return nil;
}

- (void)updateFetchWithCriteria:(NSDictionary *)criteria
{
    
}

- (NSString *)sectionNameKeyForEntity
{
    return nil;
}


- (NSString *)sortByNameKeyForEntity
{
    return nil;
}

- (NSString *)chacheName
{
    return nil;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest * fetchRequest = [self fetchRequest];
    
    if (!fetchRequest) {
        return nil;
    }
    NSString * sectionNameKey = [self sectionNameKeyForEntity];
    NSString * cacheName = [self chacheName];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.model
                                                                                                  sectionNameKeyPath:sectionNameKey
                                                                                                           cacheName:cacheName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    // Delete previous cache
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSError * error = nil;
    if(![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"---- Fetch error : %@", error);
    }
    
    [(RACSubject *)self.updatedContentSignal sendNext:nil];
}

@end
