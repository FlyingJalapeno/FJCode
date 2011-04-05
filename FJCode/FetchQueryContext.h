#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FetchQueryContext : NSObject <NSCopying> {
	NSString* entityName;
	NSString* entityLabel;
	NSPredicate* predicate;
	NSString* sectionKey; //TODO: consider changing to BOOL and using first sort key as sectionKey
	NSManagedObject* focusedObject;
	int fetchLimit; 

	NSString* _cacheName;
		    
    NSArray* sortKeys; 
	NSArray* sortDescriptors; // either sortKeys or sortDescriptors (to support descending sort)
	
}
@property (nonatomic,copy) NSString *entityName;
@property (nonatomic,copy) NSString *entityLabel;
@property (nonatomic,retain) NSPredicate* predicate;
@property (nonatomic,copy) NSString *sectionKey;
@property (nonatomic,retain) NSManagedObject* focusedObject;
@property (nonatomic,assign) int fetchLimit;

//Use one or the other, precedence is given to sortDescriptors
@property (nonatomic,retain)NSArray* sortDescriptors;
@property (nonatomic,retain)NSArray* sortKeys; //just the key to sort on, always ascending


- (NSFetchedResultsController*)fetchedResultsControllerWithContext:(NSManagedObjectContext*)context allowCaching:(BOOL)allowCaching;
- (NSFetchRequest*)fetchRequestWithContext:(NSManagedObjectContext*)context;

- (NSArray*)executeFetchRequestWithContext:(NSManagedObjectContext*)context error:(NSError**)error; //convienence

- (void)deleteFRCCacheForQuery;

@end
