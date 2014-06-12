//
//  ShopsViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "ShopsViewModel.h"

#import "Shops+Access.h"
#import "MArkets+Access.h"

@interface ShopsViewModel ()

@end


@implementation ShopsViewModel


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
    [RACObserve(self, searchString) subscribeNext:^(NSString * x) {
        @strongify(self);
        
        THAuthorizer * authorizer = [THAuthorizer sharedAuthorizer];
        
        NSNumber * uid = authorizer.currentAccount.identifier;
        if (uid)
        {
            NSString * s = [x stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\r\t"]];
            
            NSFetchRequest * request = self.fetchedResultsController.fetchRequest;
            
            // Unfault the object before access its properties, otherwise nil will be returneds
            [self.market willAccessValueForKey:nil];
            
            if (s && s.length > 0)
            {
                request.predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND marketId = %@ AND name contains[cd] %@", uid, self.market.identifier, s];
            }
            else
            {
                request.predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND %K = %@", @"marketId", uid, self.market.identifier];
            }
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

- (RACSignal *)refreshSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACSignal * request = [[THAPI apiCenter] getShops];
        
        [request subscribeNext:^(RACTuple * x) {
            NSArray * response = x[1];
            
            if (response && [response isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * aDict in response)
                {
                    [Shops objectFromDictionary:aDict];
                }
            }
            
            [[THCoreDataStack defaultStack] saveContext];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        
        return nil;
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
    Shops *representativeObject = [sectionObjects firstObject];
    
    return representativeObject.marketId.description;
}


#pragma mark - Private Methods

-(Shops *)shopAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - THBasicViewModelCoreDataProtocol

- (NSFetchRequest *)fetchRequest
{
    NSString * entityName = [Shops entityName];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.model];
    [fetchRequest setEntity:entity];
    THAuthorizer * authorizer = [THAuthorizer sharedAuthorizer];
    
    NSNumber * uid = authorizer.currentAccount.identifier;
    if (uid)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND %K = %@", @"marketId", uid, self.market.identifier];
    }
    
    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES];
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


