//
//  ShopsViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "ShopsViewModel.h"

@interface ShopsViewModel ()

-(Shops *)shopAtIndexPath:(NSIndexPath *)indexPath;

@end


@implementation ShopsViewModel


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
    Shops *representativeObject = [sectionObjects firstObject];
    
    return representativeObject.marketId.description;
}

-(NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    Shops *shop = [self shopAtIndexPath:indexPath];
    return [shop valueForKey:@keypath(shop, name)];
}

-(NSString *)subtitleAtIndexPath:(NSIndexPath *)indexPath {
    Shops *shop = [self shopAtIndexPath:indexPath];
    return [shop valueForKey:@keypath(shop, address)];
}


#pragma mark - Private Methods

-(Shops *)shopAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - THBasicViewModelCoreDataProtocol

- (NSFetchRequest *)fetchRequest
{
    NSString * entityName =  NSStringFromClass([Shops class]);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.model];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createtime" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
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


