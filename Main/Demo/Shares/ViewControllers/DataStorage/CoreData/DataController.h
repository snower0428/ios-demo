    //
//  DataController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

//  Based from Apple's provided Navigation-Controller CoreData template

#import "NSManagedObjectContext+Utility.h"
#import "SynthesizeSingleton.h"

#define MANAGED_OBJECT_CONTEXT [[DataController sharedInstance] managedObjectContext]

@interface DataController : NSObject {
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;	    
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(DataController);

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

/**
 Print a log message and exit the application.  Called whenever a CoreData related method fails.
 @parm error NSError object describing the issue
 @param sourceString NSString describing where in code it was called from
 */
- (void) handleError:(NSError *)error fromSource:(NSString *)sourceString;

/** 
 Save the ManagedObjectContext
 @param source String describing where in code the save takes place
 */
- (void) saveFromSource:(NSString *)source;

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory;

+ (void) deleteAllObjects: (NSString *)entityDescription;
+ (void) dumpError:(NSError *) error;

@end
