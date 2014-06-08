//
//  THBasicViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-3.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

@interface THBasicViewModel () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) RACSubject *updatedContentSignal;

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
        [self.fetchedResultsController performFetch:nil];
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

#pragma mark - THBasicViewModelCoreDataProtocol

- (NSFetchRequest *)fetchRequest
{
    return nil;
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
    return NSStringFromClass([self class]);
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
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.model sectionNameKeyPath:sectionNameKey cacheName:cacheName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
//    // Observe CoreData multithread changes
//    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
//                                                                      object:nil
//                                                                       queue:[NSOperationQueue mainQueue]
//                                                                  usingBlock:^(NSNotification *note) {
//                                                                      NSManagedObjectContext *savedContext = [note object];
//                                                                      
//                                                                      // ignore change notifications for the main MOC
//                                                                      if (aFetchedResultsController.managedObjectContext != savedContext) {
//                                                                          [aFetchedResultsController.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
//                                                                      }
//                                                                  }];
//    

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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [(RACSubject *)self.updatedContentSignal sendNext:nil];
}

@end
