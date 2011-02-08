//
//  FJSMultiFetchedResultsController.m
//  PhillyBeerWeek
//
//  Created by Corey Floyd on 3/23/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import "FJSMultiFetchedResultsController.h"


@interface FJSMultiFetchedResultsController()

@property(nonatomic,retain)NSMutableArray *fetchedResultsControllers;

- (NSIndexPath*)adjustIndexPath:(NSIndexPath*)indexPath forFetchedResultsController:(NSFetchedResultsController*)frc;
- (int)adjustSection:(int)section forFetchedResultsController:(NSFetchedResultsController*)frc;


@end

@implementation FJSMultiFetchedResultsController

@synthesize delegate;


@synthesize fetchedResultsControllers;

- (void) dealloc
{
	delegate = nil;
	[fetchedResultsControllers release], fetchedResultsControllers = nil;
	[super dealloc];
}


- (id) init
{
	self = [super init];
	if (self != nil) {
		self.fetchedResultsControllers = [NSMutableArray array];
	}
	return self;
}

- (NSIndexPath*)indexPathForObject: (id)object
{
	NSIndexPath*	result = nil;
	
	if (nil == object)
	{
		debugLog(@"object was nil");
		return nil;
	}
	
	for (NSFetchedResultsController* eachFRC in self.fetchedResultsControllers)
	{
		@try
		{
			result = [eachFRC indexPathForObject: object];
			
			if (nil != result)
			{
				return [self adjustIndexPath:result forFetchedResultsController:eachFRC];
			}
		}
		@catch (NSException* e)
		{
			debugLog(@"Couldn't find object in one of %@'s fetch controllers", NSStringFromClass([self class]));
			continue;
		}
	}
	
	return nil;
}

- (NSManagedObject*)objectAtIndexPath:(NSIndexPath*)indexPath{
	
	int section = indexPath.section;
	
	id<NSFetchedResultsSectionInfo> sectionData = [[self sections] objectAtIndex:section];
	
	int row = indexPath.row;
	
	if(row >= [[sectionData objects] count])
		return nil;
	
	NSManagedObject* o = [[sectionData objects] objectAtIndex:row];
	
	return o;
	
}

+ (void)deleteCacheWithName: (NSString*)cacheName
{
	[NSFetchedResultsController deleteCacheWithName: cacheName];
}

- (void)addFetchedResultsController:(NSFetchedResultsController*)controller{
	
    if(![controller isKindOfClass:[NSFetchedResultsController class]])
        return;
    
//	controller.delegate = self;
	[self.fetchedResultsControllers addObject:controller];
	
}

- (void)addFetchedResultsControllers:(NSArray*)controllers{
    
    for (id each in controllers)
        [self addFetchedResultsController:each];
}

- (BOOL)performFetch:(NSError **)error{
	
	BOOL success = YES;
	
	for(NSFetchedResultsController* eachController in self.fetchedResultsControllers){
		
		NSError* eachError = nil;
		
		if(![eachController performFetch:&eachError]){
			
			success = NO;
			
			if (error != NULL) {
				*error = eachError;
			}
			
			break;
		}
	}
	
	return success;
}

- (NSArray*)fetchedObjects{
	
	NSMutableArray* array = [NSMutableArray array];
	
	for(NSFetchedResultsController* eachController in self.fetchedResultsControllers){
		
		[array addObjectsFromArray:eachController.fetchedObjects];
		
	}
	return array;
}


- (NSArray*)sectionIndexTitles{
	
	NSMutableArray* array = [NSMutableArray array];
	
	for(NSFetchedResultsController* eachController in self.fetchedResultsControllers){
		
		[array addObjectsFromArray:eachController.sectionIndexTitles];
		
	}
	return array;
}


- (NSArray*)sections{
	
	NSMutableArray* array = [NSMutableArray array];
	
	for(NSFetchedResultsController* eachController in self.fetchedResultsControllers){
		
		[array addObjectsFromArray:eachController.sections];
		
	}
	return array;
	
}


- (int)adjustSection:(int)section forFetchedResultsController:(NSFetchedResultsController*)frc{
	
	int numberOfSections = 0;
	
	for(NSFetchedResultsController* eachController in self.fetchedResultsControllers){
		
		if(frc == eachController)
			break;
		
		numberOfSections += [[eachController sections] count];
	}
	
	return numberOfSections + section;
	
}

- (NSIndexPath*)adjustIndexPath:(NSIndexPath*)indexPath forFetchedResultsController:(NSFetchedResultsController*)frc{
	
	int section = [self adjustSection:[indexPath section] forFetchedResultsController:frc];
	return [NSIndexPath indexPathForRow:indexPath.row inSection:section];	 
}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    if([delegate respondsToSelector:@selector(controllerWillChangeContent:)])
        [delegate controllerWillChangeContent:self];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
		
    if([delegate respondsToSelector:@selector(controller:didChangeSection:atIndex:forChangeType:)])
        [delegate controller:self didChangeSection:sectionInfo atIndex:[self adjustSection:sectionIndex forFetchedResultsController:controller] forChangeType:type];
	
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{

    if([delegate respondsToSelector:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)])
        [delegate controller:self didChangeObject:anObject atIndexPath:[self adjustIndexPath:indexPath forFetchedResultsController:controller] forChangeType:type newIndexPath:[self adjustIndexPath:newIndexPath forFetchedResultsController:controller]];
	
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    if([delegate respondsToSelector:@selector(controllerDidChangeContent:)])
        [delegate controllerDidChangeContent:self];
	
}

@end
