//
//  FJSMultiFetchedResultsController.h
//  PhillyBeerWeek
//
//  Created by Corey Floyd on 3/23/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol FJSMultiFetchedResultsControllerDelegate;


@interface FJSMultiFetchedResultsController : NSObject <NSFetchedResultsControllerDelegate> {
	
	NSMutableArray*	fetchedResultsControllers;
	id<FJSMultiFetchedResultsControllerDelegate> delegate;
	
}

@property (nonatomic, readonly) NSArray *fetchedObjects;
@property (nonatomic, readonly) NSArray *sectionIndexTitles;
@property (nonatomic, readonly) NSArray *sections;

@property(nonatomic,assign)id<FJSMultiFetchedResultsControllerDelegate> delegate;

+ (void)deleteCacheWithName: (NSString*)cacheName;

- (NSManagedObject*)objectAtIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)indexPathForObject: (id)object;


- (void)addFetchedResultsController:(NSFetchedResultsController*)controller;
- (void)addFetchedResultsControllers:(NSArray*)controllers;

- (BOOL)performFetch:(NSError **)error;

@end


//Implement these how you would for an NSFetchedResultsControllerDelegate
@protocol FJSMultiFetchedResultsControllerDelegate <NSObject>

@optional
- (void)controller:(FJSMultiFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;

- (void)controllerWillChangeContent:(FJSMultiFetchedResultsController *)controller;

- (void)controllerDidChangeContent:(FJSMultiFetchedResultsController *)controller;

- (void)controller:(FJSMultiFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;

@end
