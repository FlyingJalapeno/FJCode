#import "FetchQueryContext.h"

NSArray* sortDescriptorsWithKeys(NSArray* keys){
    
    NSMutableArray* a = [NSMutableArray arrayWithCapacity:[keys count]];
    
    for(NSString* eachKey in keys){
        
        NSSortDescriptor* s = [[NSSortDescriptor alloc] initWithKey:eachKey ascending:YES];
        
        [a addObject:s];
        
        [s release];
    }
    
    return a;
}


@interface FetchQueryContext()

@property (nonatomic,copy) NSString* cacheName;

@end


@implementation FetchQueryContext

@synthesize predicate,focusedObject;
@synthesize sectionKey;
@synthesize entityName;
@synthesize entityLabel;
@synthesize cacheName = _cacheName;
@synthesize fetchLimit;
@synthesize sortKeys;
@synthesize sortDescriptors;


- (id)init
{
	self = [super init];
	
	if (self)
	{
		predicate = nil;
		focusedObject = nil;
		sectionKey = nil;
		entityName = nil;
		entityLabel = nil;
		_cacheName = nil;
		sortKeys = nil;
		fetchLimit = 0;
	}
	
	return self;
}

- (void) dealloc
{
    [sortKeys release], sortKeys = nil;
	[_cacheName release];
	_cacheName = nil;
	[entityName release], entityName = nil;
	[entityLabel release], entityLabel = nil;
	[predicate release], predicate = nil;
    [sectionKey release], sectionKey = nil;
    [focusedObject release], focusedObject = nil;
	[super dealloc];
}


- (NSFetchedResultsController*)fetchedResultsControllerWithContext:(NSManagedObjectContext*)context allowCaching:(BOOL)allowCaching {
	
	NSFetchRequest* fetchRequest = [self fetchRequestWithContext:context];
	
	if (allowCaching) {
		if (nil == self.cacheName) {
			self.cacheName = [NSString GUIDString];
		}
	} else {
		self.cacheName = nil;
	}

	NSFetchedResultsController *thisFetchedResultsController =	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:self.sectionKey cacheName:self.cacheName];
			
	return [thisFetchedResultsController autorelease];
	
}


- (NSFetchRequest*)fetchRequestWithContext:(NSManagedObjectContext*)context{

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:self.entityName inManagedObjectContext:context]];
	[fetchRequest setFetchBatchSize:20];
    
	if (sortDescriptors != nil) {
		[fetchRequest setSortDescriptors:sortDescriptors];
	} else {
		[fetchRequest setSortDescriptors:sortDescriptorsWithKeys(self.sortKeys)];
	}
    	
	if(self.predicate != nil)
	{
		[fetchRequest setPredicate:self.predicate];
	}
	
	self.fetchLimit = 20;
	if(self.fetchLimit > 0)
	{
		[fetchRequest setFetchLimit:fetchLimit];
	}
	
	
	return [fetchRequest autorelease];
	
}

- (NSArray*)executeFetchRequestWithContext:(NSManagedObjectContext*)context error:(NSError**)error{
	
	return [context executeFetchRequest:[self fetchRequestWithContext:context] error:error];
	
}

- (id)copyWithZone:(NSZone *)zone{
    
    FetchQueryContext* copy = [[[self class] allocWithZone:zone] init];
    
    copy.entityName = self.entityName;
	copy.entityLabel = self.entityLabel;
    copy.predicate = [[self.predicate copy] autorelease];
    copy.sortKeys = [[self.sortKeys copy] autorelease];
    copy.sectionKey = self.sectionKey;
    copy.focusedObject = self.focusedObject;
    copy.fetchLimit = self.fetchLimit;

    return copy;    
    
}

- (NSString*)description{
	
	return [NSString stringWithFormat:
			@"Entity name: %@\n"
			"Entity label: %@\n"
			"Predicate: %@\n"
			"sectionKey: %@\n"
			"Focus Object: %@"
            "Fetch Limit: %i",
			self.entityName,
			self.entityLabel,
			[self.predicate description],
			self.sectionKey,
			[self.focusedObject description],
            self.fetchLimit,
			nil];
}

- (void)deleteFRCCacheForQuery {
	if (self.cacheName != nil) {
		[NSFetchedResultsController deleteCacheWithName:self.cacheName];
	}
}

@end