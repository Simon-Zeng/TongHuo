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

@property (nonatomic, strong) NSNumber * marketID;

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
        RACSignal * request = [[THAPI apiCenter] getShops];
        
        [request subscribeNext:^(id x) {
            NSDictionary * response = x;
            
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

- (void)setMarket:(Markets *)market
{
    if (_market != market)
    {
        self.marketID = market.identifier;
        
        _market = market;
    }
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

    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                    ascending:YES
                                                                     selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"address"
                                                                    ascending:YES
                                                                     selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}

- (void)updateFetchRequest
{
    NSString * s = [self.searchString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\r\t"]];
    
    NSMutableDictionary * criteria = [[NSMutableDictionary alloc] init];
    
    if (self.marketID)
    {
        [criteria setObject:self.marketID forKey:@"marketId"];
    }
    
    if (s && s.length > 0)
    {
        NSMutableDictionary * subOr1 = [[NSMutableDictionary alloc] init];
        
        NSArray * r1 = @[s, @"CONTAINS[cd]"];
        [subOr1 setObject:r1 forKey:@"name"];
        
        
        NSMutableDictionary * subOr2 = [[NSMutableDictionary alloc] init];

        NSArray * r2 = @[s, @"CONTAINS[cd]"];
        [subOr2 setObject:r2 forKey:@"address"];

        
        NSMutableSet * or = [[NSMutableSet alloc] init];
        
        [or addObject:subOr1];
        [or addObject:subOr2];
        
        [criteria setObject:or forKey:@"SearchOr"];
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


