#import <UIKit/UIKit.h>
#import "FJSMultiFetchedResultsController.h"
#import <CoreData/CoreData.h>

@class EntityTableViewCell;

@interface FJSMultiFetchedResultsTableViewController : UITableViewController<FJSMultiFetchedResultsControllerDelegate> {
	
	NSManagedObjectContext *managedObjectContext;
	
	NSArray* queryContexts;
	FJSMultiFetchedResultsController* fetchedResultsController;
}
@property(nonatomic,retain)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain)NSArray *queryContexts;
@property(nonatomic,retain)FJSMultiFetchedResultsController *fetchedResultsController;

- (void)createQueryContexts;

- (void)fetchAndReload;

@end
