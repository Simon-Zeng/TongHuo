//
//  THCoreDataStack.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-3.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THCoreDataStack : NSObject

+(instancetype)defaultStack;
+(instancetype)inMemoryStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext *)threadManagedObjectContext;

-(void)saveContext;
-(void)ensureInitialLoad;

@end