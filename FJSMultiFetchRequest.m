//
//  FJSMultiFetchRequest.m
//  PhillyBeerWeek
//
//  Created by Corey Floyd on 3/23/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import "FJSMultiFetchRequest.h"


@implementation FJSMultiFetchRequest

@synthesize sections;
@synthesize fetchRequests;


- (void) dealloc
{
	[sections release], sections = nil;
	[fetchRequests release], fetchRequests = nil;
	[super dealloc];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.fetchRequests = [NSMutableArray array];
	}
	return self;
}


- (NSManagedObject*)objectAtIndexPath:(NSIndexPath*)indexPath{
	
	if(self.sections == nil)
		return nil;
	
	if(indexPath == nil)
		return nil;
	
	if(indexPath.section >= [self.sections count])
		return nil;
		
	NSArray* sectionObjects = [[self sections] objectAtIndex:indexPath.section];
	
	if(sectionObjects == nil)
		return nil;
		
	if(indexPath.row >= [sectionObjects count])
		return nil;
	
	NSManagedObject* o = [sectionObjects objectAtIndex:indexPath.row];
	
	return o;
	
}

- (void)addFetchedRequest:(NSFetchRequest*)request{
	
	[self.fetchRequests addObject:request];
	
}
- (BOOL)fetchInContext:(NSManagedObjectContext*)context error:(NSError **)error{
	
	BOOL success = YES;
	
	NSMutableArray* newSections = [NSMutableArray array];

	for(NSFetchRequest* eachReq in self.fetchRequests){
		
		NSError* eachError = nil;
		
		NSArray* a = [context executeFetchRequest:eachReq error:&eachError];
		
		 if((a != nil) && ([a count] > 0)){
	
			 [newSections addObject:a];
			 
		 }else if(error != nil){
			 
			 success = NO;
			 
			 *error = eachError;
			 
			 break;
		 }
	}
	
	self.sections = newSections;
	
	return success;
	
}

- (NSArray*)fetchedObjects{
	
	NSMutableArray* array = [NSMutableArray array];
	
	for(NSArray* each in self.sections){
		
		[array addObjectsFromArray:each];
		
	}
	return array;
}


@end
