//
//  FJSMultiFetchRequest.h
//  PhillyBeerWeek
//
//  Created by Corey Floyd on 3/23/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FJSMultiFetchRequest : NSObject {

	NSArray* sections;
	NSMutableArray* fetchRequests;
	
}
@property (nonatomic, retain) NSMutableArray *fetchRequests;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, readonly) NSArray *fetchedObjects;


- (NSManagedObject*)objectAtIndexPath:(NSIndexPath*)indexPath;

- (void)addFetchedRequest:(NSFetchRequest*)request;
- (BOOL)fetchInContext:(NSManagedObjectContext*)context error:(NSError **)error;


@end
