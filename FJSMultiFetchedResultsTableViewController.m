#import "FetchQueryContext.h"
#import "FJSMultiFetchedResultsTableViewController.h"

@implementation FJSMultiFetchedResultsTableViewController

@synthesize managedObjectContext;
@synthesize queryContexts;
@synthesize fetchedResultsController;

#pragma mark -
#pragma mark NSObject

- (void)dealloc {
    fetchedResultsController.delegate = nil;
	[managedObjectContext release], managedObjectContext = nil;
	[queryContexts release], queryContexts = nil;
	[fetchedResultsController release], fetchedResultsController = nil;
	
    [super dealloc];
}


- (id) init
{
    if (( self = [super initWithStyle:UITableViewStyleGrouped] )) {
	}
	return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self createQueryContexts];
	
	self.tableView.backgroundColor = [UIColor redColor];
	self.tableView.frame = CGRectMake(0.0f,0.0f,320.0f,460.0f);
	self.tableView.delegate = self;
	
	self.fetchedResultsController = [[[FJSMultiFetchedResultsController alloc] init] autorelease];
	fetchedResultsController.delegate = self;
	
	for(FetchQueryContext* each in self.queryContexts){
		//TODO: Figure out why enabling caching is causing illegal NSFetchResultsController mutation errors
		NSFetchedResultsController* eachFetchedResultsController = [each fetchedResultsControllerWithContext:self.managedObjectContext allowCaching:NO];
		eachFetchedResultsController.delegate = self.fetchedResultsController;
		[self.fetchedResultsController addFetchedResultsController:eachFetchedResultsController];
	}	

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
	
	NSError* error = nil;
	
	if(![fetchedResultsController performFetch:&error]){
        [UIAlertView presentErrorinAlertView:error];
	}
	//[self.tableView reloadData];
	
	[super viewWillAppear:animated];
	
}

- (void)fetchAndReload{
    
    for(FetchQueryContext* each in self.queryContexts){
		//TODO: Figure out why enabling caching is causing illegal NSFetchResultsController mutation errors
		NSFetchedResultsController* eachFetchedResultsController = [each fetchedResultsControllerWithContext:self.managedObjectContext allowCaching:NO];
		eachFetchedResultsController.delegate = self.fetchedResultsController;
		[self.fetchedResultsController addFetchedResultsController:eachFetchedResultsController];
	}	
    
    NSError* error = nil;
    if(![fetchedResultsController performFetch:&error]){

        ALWAYS_ASSERT;
    }
    
    [self.tableView reloadData];

}


- (void)createQueryContexts{
	debugLog(@"override this");
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    NSUInteger count = [[self.fetchedResultsController sections] count];
    /*
    if (count == 0) {
        count = 1;
    } 
     */
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    NSUInteger count = 0;
    if ([sections count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        count = [sectionInfo numberOfObjects];
    }
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	NSManagedObject* o = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
    //NSString *thisCellIdentifier = [NSStringFromClass([o class]) stringByAppendingString:@"TableCell"];	
    NSString *thisCellIdentifier = nil;
    if(thisCellIdentifier == nil)
        thisCellIdentifier = @"GenericEntitiesTableViewCell";	
	
    UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:thisCellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:thisCellIdentifier] autorelease];
    }
	cell.textLabel.text = [o valueForKey:@"firstName"];
    
	//cell.object = o; //This automatically sets the cell labels/buttons
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	//NSManagedObject *selectedObject = (NSManagedObject *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	
	//FetchQueryContext* savedQueryContext = [FetchQueryContext queryContextForEventsForObject:selectedObject];;
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:displayEventListNotification object:savedQueryContext];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

#pragma mark -
#pragma mark Fetched results controller

/*
 // NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */


/*
- (void)controllerWillChangeContent:(FJSMultiFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(FJSMultiFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(FJSMultiFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *tableView = self.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			
			//[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forIndexpath:indexPath];
			
			
			 [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
								   withRowAnimation:UITableViewRowAnimationFade];
			 
			
			break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(FJSMultiFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
*/





@end

