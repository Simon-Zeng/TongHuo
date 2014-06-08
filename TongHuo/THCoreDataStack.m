//
//  THCoreDataStack.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-3.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THCoreDataStack.h"

@interface THCoreDataStack ()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readwrite, strong, nonatomic) NSManagedObjectContext * writerManagerObjectContext;

@end

@implementation THCoreDataStack

+(instancetype)defaultStack {
    static THCoreDataStack *stack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [[self alloc] init];
    });
    return stack;
}

+(instancetype)inMemoryStack {
    static THCoreDataStack *stack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [[self alloc] init];
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[stack managedObjectModel]];
        NSError *error;
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
        stack.persistentStoreCoordinator = persistentStoreCoordinator;
    });
    
    return stack;
}

- (id)init
{
    if (self = [super init])
    {
        NSNotificationCenter * notficationCenter = [NSNotificationCenter defaultCenter];
        
        [notficationCenter addObserver:self
                              selector:@selector(managedObjectContextDidSaveNotification:)
                                  name:NSManagedObjectContextDidSaveNotification
                                object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)saveContext {
    @autoreleasepool {
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext = self.threadManagedObjectContext;
        if (managedObjectContext != nil) {
            //        [managedObjectContext processPendingChanges];
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application[ to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setParentContext:[self writerManagerObjectContext]];
        
        [[[NSThread currentThread] threadDictionary] setObject:_managedObjectContext forKey:@"managedObjectContext"];
    }
    return _managedObjectContext;
}


- (NSManagedObjectContext *)threadManagedObjectContext
{
    NSManagedObjectContext * context = [[[NSThread currentThread] threadDictionary] objectForKey:@"managedObjectContext"];
    
    if (!context)
    {
        @synchronized(self)
        {
            if (!context)
            {
                context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                [context setParentContext:[self managedObjectContext]];
                
                [[[NSThread currentThread] threadDictionary] setObject:context forKey:@"managedObjectContext"];
            }
        }
    }
    
    return context;
}


- (NSManagedObjectContext *)writerManagerObjectContext
{
    if (_writerManagerObjectContext != nil) {
        return _writerManagerObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _writerManagerObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_writerManagerObjectContext setPersistentStoreCoordinator:coordinator];
        
//        [[[NSThread currentThread] threadDictionary] setObject:_writerManagerObjectContext forKey:@"writerManagerObjectContext"];
    }
    return _writerManagerObjectContext;
}



// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return self.managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TongHuo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Public Methods

-(void)ensureInitialLoad {
    NSString *initialLoadKey = @"Initial Load";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL hasInitialLoad = [userDefaults boolForKey:initialLoadKey];
    if (hasInitialLoad == NO) {
        [userDefaults setBool:YES forKey:initialLoadKey];
        

        
        [[THCoreDataStack defaultStack] saveContext];
    }
}

#pragma mark - Notification
- (void)managedObjectContextDidSaveNotification:(NSNotification *)note
{
    if (note.object != self.writerManagerObjectContext)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSError *error = nil;
                NSManagedObjectContext * managedObjectContext = [self writerManagerObjectContext];
                
                if (managedObjectContext != nil) {
                    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application[ to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
            }
        });
    }
}

@end

