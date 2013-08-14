//
//  NSManagedObjectContext+insert.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext(Utility)

/**
 Easy accessor method to add a new object.
 */
- (NSManagedObject *) insertNewObjectForEntityForName:(NSString *)name;

- (NSArray *) findOne:(NSPredicate *)predicate inEntity:(NSString *)inEntity;

// git://github.com/MattNewberry/NSManagedObjectContext-Utility.git
- (NSArray *) find:(NSPredicate *)predicate inEntity:(NSString *)inEntity sortBy:(NSArray *)sortBy;
- (NSManagedObject *) add:(NSDictionary *)row inEntity:(NSString *)inEntity;
- (NSManagedObject *) update:(NSDictionary *)row inEntity:(NSString *)inEntity forObjectID:(NSManagedObjectID *)forObjectID;

- (void) deleteEntry:(NSPredicate *)predicate inEntity:(NSString *)inEntity;

@end
