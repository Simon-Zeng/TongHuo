//
//  PhonesViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-8-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "PhonesViewModel.h"

#import "Orders+Access.h"
#import "Product+Access.h"
#import "ModelService.h"

@interface PhonesViewModel ()

@end

@implementation PhonesViewModel
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
    [[RACSignal merge:@[
                        RACObserve(self, product)
                        ]]
     subscribeNext:^(id x) {
         @strongify(self);
         NSNumber * uid = self.uid;
         if (uid)
         {
             [self updateFetchRequest];
             
             [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
             
             NSError *error = nil;
             if (![self.fetchedResultsController performFetch:&error]) {
                 // Replace this implementation with code to handle the error appropriately.
                 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                 abort();
             }
             
             [(RACSubject *)self.updatedContentSignal sendNext:nil];
             
         }
     }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSections {
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

-(void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:object];
    
    NSError *error = nil;
    if ([context save:&error] == NO) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(NSString *)titleForSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSArray *sectionObjects = [sectionInfo objects];
    Orders *representativeObject = [sectionObjects firstObject];
    
    return representativeObject.pid.stringValue;
}

#pragma mark - Private Methods

-(Orders *)orderAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - THBasicViewModelCoreDataProtocol

- (NSFetchRequest *)fetchRequest
{
    NSString * entityName = [Orders entityName];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.model];
    [fetchRequest setEntity:entity];
    
    
    // Set the batch size to a suitable number.
    //    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createtime" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}

- (void)updateFetchRequest
{
    NSMutableDictionary * criteria = [[NSMutableDictionary alloc] init];
    
    NSNumber * uid = self.uid;
    if (uid)
    {
        [criteria setObject:uid forKey:@"uid"];
    }
    
    if (self.product)
    {
        [criteria setObject:self.product.courier forKey:@"tno"];
    }
    
    [self updateFetchRequestWithCriteria:criteria];
}

- (NSString *)sectionNameKeyForEntity
{
    return nil;
}


- (NSString *)sortByNameKeyForEntity
{
    return nil;
}

@end
