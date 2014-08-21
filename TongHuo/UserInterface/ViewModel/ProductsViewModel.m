//
//  TongHuoViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "ProductsViewModel.h"

#import "Orders+Access.h"
#import "Product+Access.h"

@interface ProductsViewModel ()

@end

@implementation ProductsViewModel

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
    self.state = @0;
    
    @weakify(self);
    [[RACSignal merge:@[
                        RACObserve(self, state),
                        RACObserve(self, searchString)
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


- (RACSignal *)refreshSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSNumber * uid = self.uid;
        
        if (uid)
        {
            RACSignal * request = [[THAPI apiCenter] postAndGetOrders:[NSArray array]];
            
            return [request subscribeNext:^(id x) {
                NSDictionary * response = x;
                
                if (response && [response isKindOfClass:[NSDictionary class]])
                {
                    NSArray * ordersInfo = [response objectForKey:@"fh"];
                    NSArray * productsInfo = [response objectForKey:@"pro"];
                    
                    for (NSDictionary * aDict1 in ordersInfo)
                    {
                        [Orders objectFromDictionary:aDict1];
                    }
                    
                    for (NSDictionary * aDict2 in productsInfo)
                    {
                        [Product objectFromDictionary:aDict2];
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
        }
        else
        {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
            return nil;
        }
    }];
}

- (RACSignal *)synchronizeSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
     
        NSNumber * uid = self.uid;
        
        if (uid)
        {
            NSArray * changedProducts = [Product getAllOrdersWithCriteria:(@{
                                                                             @"uid": uid,
                                                                             @"state": @1,
                                                                             })];
            
            RACSignal * request = [[THAPI apiCenter] postAndGetOrders:changedProducts];
            
            return [request subscribeNext:^(id x) {
                NSDictionary * response = x;
                
                if (response && [response isKindOfClass:[NSDictionary class]])
                {
                    NSArray * ordersInfo = [response objectForKey:@"fh"];
                    NSArray * productsInfo = [response objectForKey:@"pro"];
                    
                    NSManagedObjectContext * mainContext = [THCoreDataStack defaultStack].managedObjectContext;
                    
                    [mainContext performBlock:^{
                        for (NSDictionary * aDict1 in ordersInfo)
                        {
                            [Orders objectFromDictionary:aDict1];
                        }
                        
                        for (NSDictionary * aDict2 in productsInfo)
                        {
                            [Product objectFromDictionary:aDict2];
                        }
                        
                        [[THCoreDataStack defaultStack] saveContext];
                    }];
                }
                
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
        }
        else
        {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
            return nil;
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
    Product *representativeObject = [sectionObjects firstObject];
    
    return representativeObject.shopName;
}

#pragma mark - Private Methods

-(Product *)productAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - THBasicViewModelCoreDataProtocol

- (NSFetchRequest *)fetchRequest
{
    NSString * entityName = [Product entityName];
    
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
    NSString * s = [self.searchString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\r\t"]];
    
    NSMutableDictionary * criteria = [[NSMutableDictionary alloc] init];
    
    NSNumber * uid = self.uid;
    if (uid)
    {
        [criteria setObject:uid forKey:@"uid"];
    }
    
    if (self.state)
    {
        [criteria setObject:self.state forKey:@"state"];
    }
    
    if (s && s.length > 0)
    {
        NSArray * r = @[s, @"CONTAINS[cd]"];
        [criteria setObject:r forKey:@"buyer"];
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
