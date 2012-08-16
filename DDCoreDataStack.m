/*
 * Copyright (c) 2007-2008 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "DDCoreDataStack.h"
#import "DDCoreDataException.h"

NSString* const kDefaultStoreName = @"storedata";

NSString* const kStoreExtension = @"sqlite";


@implementation DDCoreDataStack

@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize mainStore = _mainStore;
@synthesize mainContext = _mainContext;

#pragma mark NSObject

- (void)dealloc
{
    [self destroyFullStack];
    [super dealloc];
}


#pragma mark DDCoreDataStack

+ (NSString*)defaultStoreDirectory{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

}

+ (NSURL*)defaultStoreURL{
    
    NSString* fileName = [kDefaultStoreName stringByAppendingPathExtension:kStoreExtension];
    NSString* path = [[DDCoreDataStack defaultStoreDirectory] stringByAppendingPathComponent:fileName];
    
    NSURL* url = [NSURL fileURLWithPath:path];
    
    return url;
}

+ (NSURL*)modelURL{
    
    NSArray* urls = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"mom" subdirectory:nil];
   
    if([urls count] > 1){
        
        return nil;
    }
    
    if([urls count] == 0){
        
        return nil;
    }
    
    return [urls objectAtIndex:0];
    
}

+ (NSURL*)versionedModelURL{
    
    return [self versionedModelURLInBundle:[NSBundle mainBundle]];
}


+ (NSURL*)versionedModelURLInBundle:(NSBundle*)bundle{
    
    NSArray* urls = [bundle URLsForResourcesWithExtension:@"momd" subdirectory:nil];
    
    if([urls count] > 1){
        
        return nil;
    }
        
    if([urls count] == 0){
        
        return nil;
    }
    
    return [urls objectAtIndex:0];
        
}

+ (NSArray*)versionedModeURLS{
    
    return [self versionedModeURLSInBundle:[NSBundle mainBundle]];
}


+ (NSArray*)versionedModeURLSInBundle:(NSBundle*)bundle{
    
    NSURL* momd = [self versionedModelURLInBundle:bundle];
    NSString* path = [momd path];
    NSString* momdFileName = [path lastPathComponent];
    
    NSArray* urls = [bundle URLsForResourcesWithExtension:@"mom" subdirectory:momdFileName];
    
    return urls;
    
}

+ (NSURL*)bundledStoreURLInBundle:(NSBundle*)bundle{
    
    NSArray* urls = [bundle URLsForResourcesWithExtension:kStoreExtension subdirectory:nil];
    
    if([urls count] > 1){
        
        return nil;
    }
    
    if([urls count] == 0){
        
        return nil;
    }
    
    return [urls objectAtIndex:0];
    
    
}

+ (BOOL)copyStoreFromURL:(NSURL*)bundledStoreURL toStoreLocation:(NSURL*)storeLocation overwriteExistingStore:(BOOL)overwrite{
          
    if(!overwrite && [[NSFileManager defaultManager] fileExistsAtPath:[storeLocation path]]){
        
        //not overwriting exiting store
        return NO;
        
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:storeLocation error:nil];
    
    NSError* error = nil;
    [[NSFileManager defaultManager] copyItemAtURL:bundledStoreURL 
                                            toURL:storeLocation
                                            error:&error];
    
    if(error != nil)
        return NO;
    
    return YES;
    
}

+ (NSMutableDictionary*)automaticMigrationOptions{
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    return options;
}

#pragma mark -
#pragma mark Accessors

- (NSURL*)mainStoreURL{
    
    return [[self mainStore] URL];
    
}


- (BOOL)createFullSQLiteStackWithDefaultSettingsAtURL:(NSURL*)url{
     
    return [self createFullStackWithStoreType:NSSQLiteStoreType URL:url];

}       

- (BOOL)createFullStackWithInMemoryStore{
        
    return [self createFullStackWithStoreType:NSInMemoryStoreType URL:nil];
    
}


#pragma mark -
#pragma mark Full Stack

- (BOOL)createFullStackWithStoreType:(NSString *)storeType
                                 URL:(NSURL *)url;
{
   return [self createFullStackFromModelsInBundles:nil
                                   storeType:storeType
                                         URL:url];
}


- (BOOL)createFullStackFromModelsInBundles:(NSArray *)bundles
                                 storeType:(NSString *)storeType
                                       URL:(NSURL *)url;
{
    
   return [self createFullStackFromModelsInBundles:bundles 
                                   storeType:storeType 
                                         URL:url 
                                       error:nil];
}


- (BOOL)createFullStackFromModelsInBundles:(NSArray *)bundles
                                 storeType:(NSString *)storeType
                                       URL:(NSURL *)url
                                     error:(NSError **)error
{
    [self createMergedModelFromBundles:bundles];
    [self createCoordinator];
    if (![self addMainStoreWithType:storeType
                      configuration:nil
                                URL:url
                            options:nil
                              error:error])
    {
        [self destroyCoordinator];
        [self destroyModel];
        return NO;
    }
    
    [self createMainContext];
    return YES;
}

- (BOOL)createFullStackFromModelAtURL:(NSURL *)modelURL
                            storeType:(NSString *)storeType
                                  URL:(NSURL *)url
                              options:(NSDictionary*)options
                                error:(NSError **)error{
    
    [self createModelFromFromURL:modelURL];
    [self createCoordinator];
    if (![self addMainStoreWithType:storeType
                      configuration:nil
                                URL:url
                            options:options
                              error:error])
    {
        [self destroyCoordinator];
        [self destroyModel];
        return NO;
    }
    
    [self createMainContext];
    return YES;
    
}


- (void)destroyFullStack;
{
    [self destroyMainContext];
    [self removeMainStore];
    [self destroyCoordinator];
    [self destroyModel];
}

- (void)destroyFullStackAndDeleteStoreFromDisk:(BOOL)flag{
    
    [self destroyMainContext];
    [self removeMainStoreDeleteFromDisk:flag];
    [self destroyCoordinator];
    [self destroyModel];
    
}

#pragma mark -
#pragma mark Model

- (void)createMergedModelFromMainBundle;
{
    [self createMergedModelFromBundles:nil];
}

- (void)createMergedModelFromBundles:(NSArray *)bundles;
{
    NSAssert(_model == nil, @"Model is already created");
    _model = [[NSManagedObjectModel mergedModelFromBundles:bundles] retain];
    NSAssert(_model != nil, @"Created model is nil");
}

- (void)createModelFromFromURL:(NSURL *)url{
    
    NSAssert(_model == nil, @"Model is already created");
    _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    NSAssert(_model != nil, @"Created model is nil");
}

- (void)destroyModel
{
    [_model release];
    _model = nil;
}

- (void)createCoordinator;
{
    NSAssert(_coordinator == nil, @"Coordinator is already created");
    NSAssert(_model != nil, @"Model should not be nil");
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    NSAssert(_coordinator != nil, @"Created coordinator is nil");
}

- (void)destroyCoordinator
{
    [_coordinator release];
    _coordinator = nil;
}

- (void)addMainStoreWithType:(NSString *)storeType
               configuration:(NSString *)configuration
                         URL:(NSURL *)url
                     options:(NSDictionary *)options;
{
    NSError * error = nil;
    if (![self addMainStoreWithType:storeType
                      configuration:configuration
                                URL:url
                            options:options
                              error:&error])
    {
        @throw [DDCoreDataException exceptionWithReason:@"Could not addPersistent store"
                                                  error:error];
    }
}

- (BOOL)addMainStoreWithType:(NSString *)storeType
               configuration:(NSString *)configuration
                         URL:(NSURL *)url
                     options:(NSDictionary *)options
                       error:(NSError **)error;
{
    NSAssert(_mainStore == nil, @"Main store is already created");
    NSAssert(_coordinator != nil, @"Coordinator should not be nil");
    
    [self checkForMigration:configuration];
    _mainStore = [_coordinator addPersistentStoreWithType:storeType
                                            configuration:configuration
                                                      URL:url
                                                  options:options
                                                    error:error];
    [_mainStore retain];
    if (_mainStore == nil)
        return NO;
    else
        return YES;
}

- (void)checkForMigration:(NSString *)configuration {
    NSURL *storeSourceUrl = [DDCoreDataStack defaultStoreURL];
    NSError *error = nil;       
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator
                                    metadataForPersistentStoreOfType:NSSQLiteStoreType
                                    URL:storeSourceUrl
                                    error:&error];
    
    if (sourceMetadata) {
        NSManagedObjectModel *destinationModel = [_coordinator managedObjectModel];
        BOOL pscCompatible = [destinationModel isConfiguration:configuration compatibleWithStoreMetadata:sourceMetadata];
        if (pscCompatible == NO) {
            [self performMigrationWithSourceMetadata:sourceMetadata toDestinationModel:destinationModel];
        }
        
    }
}
- (void)performMigrationWithSourceMetadata :(NSDictionary *)sourceMetadata
                         toDestinationModel:(NSManagedObjectModel *)destinationModel {
    BOOL migrationSuccess = NO;
    //Initialise a Migration Manager...
    NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
    //Perform the migration...
    if (sourceModel) {
        NSMigrationManager *standardMigrationManager = [[NSMigrationManager alloc]
                                                        initWithSourceModel:sourceModel
                                                        destinationModel:destinationModel];
        
        NSError *error = nil;
        
        NSString *storeFileName = [kDefaultStoreName stringByAppendingPathExtension:kStoreExtension];    
        NSString *storeSourcePath = [[DDCoreDataStack defaultStoreDirectory] stringByAppendingPathComponent:storeFileName];
        NSURL *storeSourceUrl = [NSURL fileURLWithPath: storeSourcePath];
        
        NSString *destFileName = [storeFileName stringByReplacingOccurrencesOfString:@".sqlite" withString:@"_temp.sqlite"];
        NSString *storeDestPath = [[DDCoreDataStack defaultStoreDirectory] stringByAppendingPathComponent:destFileName];
        NSURL *storeDestUrl = [NSURL fileURLWithPath:storeDestPath];
        
        //Pass nil here because we don't want to use any of these options:
        //NSIgnorePersistentStoreVersioningOption, NSMigratePersistentStoresAutomaticallyOption, or NSInferMappingModelAutomaticallyOption
        NSDictionary *sourceStoreOptions = nil;
        NSDictionary *destinationStoreOptions = nil;
        
        
        NSURL *migrationFileURL = [[NSBundle mainBundle] URLForResource:@"MigrationModelV10" withExtension:@"cdm"];            
        NSMappingModel *mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:migrationFileURL];
        if (mappingModel) {
            
            migrationSuccess = [standardMigrationManager migrateStoreFromURL:storeSourceUrl
                                                                        type:NSSQLiteStoreType
                                                                     options:sourceStoreOptions
                                                            withMappingModel:mappingModel
                                                            toDestinationURL:storeDestUrl
                                                             destinationType:NSSQLiteStoreType
                                                          destinationOptions:destinationStoreOptions
                                                                       error:&error];
            NSLog(@"MIGRATION SUCCESSFUL? %@", (migrationSuccess==YES)?@"YES":@"NO");
        } 
        if (migrationSuccess) {
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSLog(@"remove item at path: %@",storeSourcePath);
            if ([fileMgr removeItemAtPath:storeSourcePath error:&error] != YES)
                NSLog(@"Unable to delete file: %@", [error localizedDescription]);
            
            NSLog(@"move item at path: %@ to path: %@",storeDestPath,storeSourcePath);
            if ([fileMgr moveItemAtPath:storeDestPath toPath:storeSourcePath error:&error] != YES)
                NSLog(@"Unable to move file: %@", [error localizedDescription]);
        }
    }else {
        //TODO: Error to user...
        NSLog(@"checkForMigration FAIL - No Mapping Model found!");
        abort();   
    }
}

- (void)removeMainStore
{
    if (_mainStore != nil)
    {
        [_coordinator removePersistentStore:_mainStore error:nil];
        [_mainStore release];
        _mainStore = nil;
    }
}

- (void)removeMainStoreDeleteFromDisk:(BOOL)flag{

    [self deleteMainStoreFromDisk];
   
    if (_mainStore != nil)
    {
        [_coordinator removePersistentStore:_mainStore error:nil];
        [_mainStore release];
        _mainStore = nil;
    }
    
}

- (void)createMainContext;
{
    NSAssert(_mainContext == nil, @"Main context is already created");
    _mainContext = [self newContext];
}

- (NSManagedObjectContext*)newContext{
    
    NSAssert(_coordinator != nil, @"Coordinator should not be nil");
    NSManagedObjectContext * context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:_coordinator];
    return context;
    
}


- (void)destroyMainContext
{
    [_mainContext release];
    _mainContext = nil;
}


- (NSManagedObjectContext *)scratchpadContext{
	
    NSAssert(_coordinator != nil, @"Coordinator should not be nil");
    NSManagedObjectContext * context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:_coordinator];
    return [context autorelease];
    
}

- (void)deleteMainStoreFromDisk{
    
    [[NSFileManager defaultManager] removeItemAtPath:[[self mainStoreURL] path] error:nil];
    
}




@end
