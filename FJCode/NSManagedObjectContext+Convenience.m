#import "NSManagedObjectContext+Convenience.h"
#import "NSArray+extensions.h"

@implementation NSManagedObjectContext (insert)
-(NSManagedObject *) insertNewEntityWithName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}
@end

@interface NSManagedObjectContext (EntitiesPrivate)

//case insensitive
- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key caseInsensitiveLike:(NSString *)value;
- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key caseInsensitiveLike:(NSString *)value;
//------

@end

@implementation NSManagedObjectContext (EntitiesPrivate)


#pragma mark -
#pragma mark Case Insensitive Always

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key caseInsensitiveLike:(NSString *)value{
	
    return [self entityWithName:entityName whereKey:key caseInsensitiveLike:value] != nil;
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key caseInsensitiveLike:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like[c] %@",key , value];
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObjectSafe];
}


@end


@implementation NSManagedObjectContext (Entities)

// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(id)stringOrPredicate, ...
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:newEntityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    
    if (stringOrPredicate)
    {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]])
        {
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                               arguments:variadicArguments];
            va_end(variadicArguments);
        }
        else
        {
            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
                      @"Second parameter passed to %s is of unexpected class %@",
                      sel_getName(_cmd), [[stringOrPredicate class] description]);
            predicate = (NSPredicate *)stringOrPredicate;
        }
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:@"%@", [error description]];
    }
    
    return [NSSet setWithArray:results];
}

//Containing strings
- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value{
    return [self entityWithName:entityName whereKey:key contains:value] != nil;
	
    
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value{
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@",key , value];
    
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObjectSafe];
    
}

- (NSArray*)entitiesWithName:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value{
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
	if ((nil != key)&&(nil != value)) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@",key , value];
		[request setPredicate:predicate];
	}
	
    // predicate to limit size
	
    return [self executeFetchRequest:request error:NULL];
}

#pragma mark -
#pragma mark Case Insensitive Optional

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag{
    
	if(flag)
		return [self entityWithNameExists:entityName whereKey:key caseInsensitiveLike:value];
	else 
		return [self entityWithNameExists:entityName whereKey:key like:value];
	
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag{
	
	if(flag)
		return [self entityWithName:entityName whereKey:key caseInsensitiveLike:value];
	else 
		return [self entityWithName:entityName whereKey:key like:value];
	
    
}


#pragma mark -
#pragma mark Equality

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key equalToObject:(id )value{
	
	return [self entityWithName:entityName whereKey:key equalToObject:value] != nil;
	
}

- (id)entityWithName: (NSString*)entityName whereKey: (NSString*)key equalToObject: (id)value
{
    NSFetchRequest*	request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: entityName inManagedObjectContext: self]];
    
    NSPredicate*	predicate = [NSPredicate predicateWithFormat: @"%K == %@", key, value]; //[NSPredicate predicateWithFormat:@"%K == %@", key, value];
	
	[request setFetchLimit: 1];
	[request setPredicate: predicate];
	//	[predicate release];
	//	predicate = nil;
    
	NSArray*	fetchResults = [self executeFetchRequest: request error: NULL];
	
	[request release];
	request = nil;
	
    //return [[self executeFetchRequest:request error:NULL] firstObjectSafe];
	
	return [fetchResults firstObjectSafe];
}


- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key equalToObject:(id )value
{
    id obj = [self entityWithName:entityName whereKey:key equalToObject:value];
    if (!obj) {
        obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        [obj setValue:value forKey:key];
    }
    return obj;
}


#pragma mark -

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value
{
    return [self entityWithName:entityName whereKey:key like:value] != nil;
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",key , value];
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObjectSafe];
}

- (NSArray *)entitiesWithName:(NSString *)entityName whereKey:(NSString *)key isIn:(id)values
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@",key , values];
    [request setPredicate:predicate];
    
    return [self executeFetchRequest:request error:NULL];
}

/*
- (NSArray*)entitiesWithName: (NSString*)entityName whereKey: (NSString*)key isIn: (id)collection
{
	NSArray*		result = nil;
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
		
	[request setEntity: [NSEntityDescription entityForName: entityName inManagedObjectContext: self]];
	[request setFetchLimit: [collection count]];
	
	//[request setResultType: NSManagedObjectIDResultType];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat: @"%K in %@", key, collection];
	
	[request setPredicate:predicate];
	
	result = [self executeFetchRequest: request error: NULL];
	
	[request release];
	request = nil;
	
	return result;
}
*/

- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value
{
    id obj = [self entityWithName:entityName whereKey:key like:value];
    if (!obj) {
        obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        [obj setValue:value forKey:key];
    }
    return obj;
}


- (id)createEntity:(NSString *)entityName withUniqueValueForKey:(NSString *)key defaultValue:(NSString *)def
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                            inManagedObjectContext:self];
    NSString *baseName      = def;
    NSString *suggestedName = baseName;
    int counter             = 1;
    
    //find a unique name for the New Collection
    BOOL go = YES;
    while (go) {
        NSFetchRequest *request  = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"%K like %@",key,suggestedName]];
        int count = [self countForFetchRequest:request error:NULL];
        if (count != 0) {
            suggestedName = [NSString stringWithFormat:@"%@ %i",baseName,counter];
            counter++;
        } else
            go = NO;
    }
    [object setValue:suggestedName forKey:key];
    return object;
}

- (int)numberOfEntitiesWithName:(NSString *)entityName
{
    NSFetchRequest *request  = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    return [self countForFetchRequest:request error:NULL];
}


- (NSArray *)entitiesWithName:(NSString *)entityName predicate:(NSPredicate*)predicate sortedByKey:(NSString*)key ascending:(BOOL)ascending{
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];

    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]]];
    [request setPredicate:predicate];
    
    return [self executeFetchRequest:request error:NULL];
	
	
}
- (NSArray *)entitiesWithName:(NSString *)entityName predicate:(NSPredicate*)predicate{
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    [request setPredicate:predicate];
    
    return [self executeFetchRequest:request error:NULL];
	
	
}
- (NSArray *)entitiesWithName:(NSString *)entityName
{
    NSFetchRequest *request  = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
	
    return[self executeFetchRequest:request error:NULL];
}

- (int)numberOfEntitiesWithName:(NSString *)entityName where:(NSString *)key like:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",key , value];
    [request setPredicate:predicate];
    
    return [self countForFetchRequest:request error:NULL];
}

- (NSArray *)entitiesWithName:(NSString *)entityName where:(NSString *)key like:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",key , value];
    [request setPredicate:predicate];
    
    return [self executeFetchRequest:request error:NULL];
}


- (NSArray*)objectsWithObjectIDs:(NSArray*)originalObjectIDs{
    
    NSMutableArray* newObjects = [NSMutableArray arrayWithCapacity:[originalObjectIDs count]];
    
    [originalObjectIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSManagedObject* newObj = [self objectWithID:(NSManagedObjectID*)obj];
        
        [newObjects addObject:newObj];
        
    }];
    
    return newObjects;
}

- (NSArray*)objectsWithObjectsFromOtherContext:(NSArray*)originalObjects{
    
    NSMutableArray* newObjects = [NSMutableArray arrayWithCapacity:[originalObjects count]];
    
    [originalObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSManagedObjectID* anID = [(NSManagedObject*)obj objectID];
        
        NSManagedObject* newObj = [self objectWithID:anID];
        
        [newObjects addObject:newObj];
        
    }];
    
    return newObjects;
}

- (NSManagedObject*)objectWithObjectFromOtherContext:(NSManagedObject*)originalObject{
    
    NSManagedObjectID* anID = [(NSManagedObject*)originalObject objectID];
    
    NSManagedObject* newObj = [self objectWithID:anID];
    
    return newObj;
    
}

@end



@implementation NSManagedObjectContext (DictionaryExtensions)

- (NSMutableDictionary*) mutableDictionaryForEntityWithName:(NSString*)entityName keyedBy:(NSString*)keyName
{
	NSArray* entities = [self entitiesWithName:entityName];
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[entities count]];
	for( NSManagedObject* obj in entities ) 
	{
		[dict setObject:obj forKey:[obj valueForKey:keyName]];
	}
	return dict;
}

@end




