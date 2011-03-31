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


@interface DDCoreDataStack : NSObject
{
    NSManagedObjectModel * _model;
    NSPersistentStoreCoordinator * _coordinator;
    NSPersistentStore * _mainStore;
    NSManagedObjectContext * _mainContext;
}
@property (readonly, retain) NSManagedObjectModel * model;
@property (readonly, retain) NSPersistentStoreCoordinator * coordinator;
@property (readonly, retain) NSPersistentStore * mainStore;
@property (readonly, retain) NSManagedObjectContext * mainContext;
@property (readonly, readonly) NSURL * mainStoreURL; 



#pragma mark -
#pragma mark Defaults

extern NSString* const kDefaultStoreName; //storedata
extern NSString* const kStoreExtension; //sqlite

+ (NSString*)defaultStoreDirectory; //documents

+ (NSURL*)defaultStoreURL; //documents/storedata.sqlite

+ (NSURL*)modelURL; //get the MOM URL in the main bundle

+ (NSURL*)versionedModelURL; //get the versioned MOMD URL
+ (NSURL*)versionedModelURLInBundle:(NSBundle*)bundle; //get the versioned MOMD URL in the specified bundle

+ (NSArray*)versionedModeURLS; //get the versioned MOM URLs within MOMD bundle
+ (NSArray*)versionedModeURLSInBundle:(NSBundle*)bundle; //get the versioned MOM URLs within MOMD bundle in the specified bundle

+ (NSURL*)bundledStoreURLInBundle:(NSBundle*)bundle; //get the bundled Store URL in the bundle, must be .sqlite, can be any name

+ (BOOL)copyStoreFromURL:(NSURL*)bundledStoreURL toStoreLocation:(NSURL*)storeLocation overwriteExistingStore:(BOOL)overwrite;

+ (NSMutableDictionary*)automaticMigrationOptions;


#pragma mark -
#pragma mark Convienence Methods

//merging from bundles, creates store at URL
- (BOOL)createFullSQLiteStackWithDefaultSettingsAtURL:(NSURL*)url;

//in memory store merging from bundles
- (BOOL)createFullStackWithInMemoryStore;


#pragma mark -
#pragma mark Create Full Stack 

- (BOOL)createFullStackWithStoreType:(NSString *)storeType
                                 URL:(NSURL *)url;

- (BOOL)createFullStackFromModelsInBundles:(NSArray *)bundles
                                 storeType:(NSString *)storeType
                                       URL:(NSURL *)url;

- (BOOL)createFullStackFromModelsInBundles:(NSArray *)bundles
                                 storeType:(NSString *)storeType
                                       URL:(NSURL *)url
                                     error:(NSError **)error;

//use for specific model or versioning
- (BOOL)createFullStackFromModelAtURL:(NSURL *)modelURL
                            storeType:(NSString *)storeType
                                  URL:(NSURL *)url
                              options:(NSDictionary*)options
                                error:(NSError **)error;
    


- (void)destroyFullStack;

- (void)destroyFullStackAndDeleteStoreFromDisk:(BOOL)flag;



//So you want to do it all yourself?

//(1) model

- (void)createMergedModelFromMainBundle;

- (void)createMergedModelFromBundles:(NSArray *)bundles;

- (void)createModelFromFromURL:(NSURL *)url; 

- (void)destroyModel;




//(2) coordinator

- (void)createCoordinator; //model must exist!!

- (void)destroyCoordinator;


//(3) store

- (void)addMainStoreWithType:(NSString *)storeType
               configuration:(NSString *)configuration
                         URL:(NSURL *)url
                     options:(NSDictionary *)options; //coordinator must exist!!

- (BOOL)addMainStoreWithType:(NSString *)storeType
               configuration:(NSString *)configuration
                         URL:(NSURL *)url
                     options:(NSDictionary *)options
                       error:(NSError **)error; //coordinator must exist!!

- (void)removeMainStore; //does not remove from disk

- (void)removeMainStoreDeleteFromDisk:(BOOL)flag;

- (void)deleteMainStoreFromDisk;



//(4) context

- (void)createMainContext;

- (void)destroyMainContext;



- (NSManagedObjectContext *)scratchpadContext; //autoreleased

- (NSManagedObjectContext*)newContext; //+1


@end
