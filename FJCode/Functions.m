
#import "Functions.h"
#include <sys/xattr.h>
#import <mach/mach_time.h> 

#ifndef TARGET_OS_MAC
#import "LambdaAlert.h"
#endif


BOOL rangesAreContiguous(NSRange first, NSRange second){
    
    NSIndexSet* firstIndexes = [NSIndexSet indexSetWithIndexesInRange:first];
    NSIndexSet* secondIndexes = [NSIndexSet indexSetWithIndexesInRange:second];
    
    NSUInteger endOfFirstRange = [firstIndexes lastIndex];
    NSUInteger beginingOfSecondRange = [secondIndexes firstIndex];
    
    if(beginingOfSecondRange - endOfFirstRange == 1)
        return YES;
    
    return NO;
    
}

NSRange rangeWithFirstAndLastIndexes(NSUInteger first, NSUInteger last){
    
    if(last < first)
        return NSMakeRange(0, 0);
    
    if(first == NSNotFound || last == NSNotFound)
        return NSMakeRange(0, 0);
    
    NSUInteger length = last-first + 1;
    
    NSRange r = NSMakeRange(first, length);
    return r;
    
}


float nanosecondsWithSeconds(float seconds){
    
    return (seconds * 1000000000);
    
}


CGFloat BNRTimeBlock (void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
    
} // BNRTimeBlock

dispatch_time_t dispatchTimeFromNow(float seconds){
    
    return  dispatch_time(DISPATCH_TIME_NOW, nanosecondsWithSeconds(seconds));
    
}



BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL){
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

NSUInteger sizeOfFolderContentsInBytes(NSString* folderPath){
    
    NSError* error = nil;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    
    if (error != nil){
        return NSNotFound;
    }
    
    double bytes = 0.0;
    for(NSString* eachFile in contents){
        
        NSDictionary* meta = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:eachFile] error:&error];
        
        if(error != nil){
            
            break;
        }
        
        NSNumber* fileSize = [meta objectForKey:NSFileSize];
        bytes += [fileSize unsignedIntegerValue];
    } 
    
    if(error != nil){
        
        return NSNotFound;
    }
    
    return bytes;
    
}


double megaBytesWithBytes(long long bytes){
    
    NSNumber* b = [NSNumber numberWithLongLong:bytes];
    
    double bytesAsDouble = [b doubleValue];
    
    double mb = bytesAsDouble/1048576.0;
    
    return mb;
    
}


double gigaBytesWithBytes(long long bytes){
    
    NSNumber* b = [NSNumber numberWithLongLong:bytes];
    
    double bytesAsDouble = [b doubleValue];
    
    double gb = bytesAsDouble/1073741824.0;
    
    return gb;
    
}

NSString* prettySizeStringWithBytesRounded(long long bytes){
    
    NSString* size = nil;
    
    if(bytes <= 524288000){ //smaller than 500 MB
        
        double mb = megaBytesWithBytes(bytes);
        mb = round(mb);
        size = [NSString stringWithFormat:@"%.f MB", mb];
        
    }else{
        
        double gb = gigaBytesWithBytes(bytes);
        gb = round(gb/0.1)*0.1;
        size = [NSString stringWithFormat:@"%.1f GB", gb];
        
    }    
    return size;
    
}

NSString* prettySizeStringWithBytesFloored(long long bytes){
    
    NSString* size = nil;
    
    if(bytes <= 524288000){ //smaller than 500 MB
        
        double mb = megaBytesWithBytes(bytes);
        mb = floor(mb);
        size = [NSString stringWithFormat:@"%.f MB", mb];
        
    }else{
        
        double gb = gigaBytesWithBytes(bytes);
        gb = floor(gb/0.1)*0.1;
        size = [NSString stringWithFormat:@"%.1f GB", gb];
        
    }    
    return size;
    
}




void dispatchOnMainQueue(dispatch_block_t block){
    
    dispatch_async(dispatch_get_main_queue(), block);
}

void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block){
    
    dispatchAfterDelayInSeconds(delay, dispatch_get_main_queue(), block);    
}

void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block){
    
    dispatch_after(dispatchTimeFromNow(delay), queue, block);
    
}


CGRect rectExpandedByValue(CGRect rect,  float expandRadius){
    
    rect.size.width += (2*expandRadius);
    rect.size.height += (2*expandRadius);
    
    rect.origin.x -= expandRadius;
    rect.origin.y -= expandRadius;
    
    
    return rect;
    
}


CGRect rectContractedByValue(CGRect rect,  float expandRadius){
    
    rect.size.width -= (2*expandRadius);
    rect.size.height -= (2*expandRadius);
    
    rect.origin.x += expandRadius;
    rect.origin.y += expandRadius;
    
    return rect;    
    
}

CGPoint centerOfRect(CGRect rect){
    
    CGPoint c;
    c.x = CGRectGetMidX(rect);
    c.y = CGRectGetMidY(rect);
    return c;
    
}

#ifndef TARGET_OS_MAC


void openGoogleMapsForDirectionsWithLocations(CLLocation* startLocation, CLLocation* endLocation){
    
    CLLocationCoordinate2D start = startLocation.coordinate;
	CLLocationCoordinate2D destination = endLocation.coordinate;        
	
	NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
									 start.latitude, start.longitude, destination.latitude, destination.longitude];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
    
}

void showPromptAndOpenGoogleMapsForDirectionsWithLocations(CLLocation* startLocation, CLLocation* endLocation, void(^block)(BOOL didOpenMap)){
    
    LambdaAlert* a = [[LambdaAlert alloc] initWithTitle:@"Get Directions?" message:@"Close the app and get directions using Google maps?"];
    
    [a addButtonWithTitle:@"Directions" block:^{
        
        //CLLocation* storeLocation = [[CLLocation alloc] initWithLatitude: [annotation coordinate].latitude longitude: [annotation coordinate].longitude];
        
        openGoogleMapsForDirectionsWithLocations(startLocation, endLocation);
        
        block(YES);
        
    }];
    
    [a addButtonWithTitle:@"Cancel" block:^{
        
        block(NO);

    }];
    
    [a show];
    [a autorelease];
}

NSComparisonResult compareAnnotationsByDistanceToLocation(id<MKAnnotation> obj1, id<MKAnnotation> obj2, CLLocation* center){
        
    if(!center)
        return NSOrderedAscending;
    
    CLLocation* l1 = [[CLLocation alloc] initWithLatitude:[obj1 coordinate].latitude longitude:[obj1 coordinate].longitude];
    
    CLLocationDistance d1 = [center distanceFromLocation:l1];
    
    CLLocation* l2 = [[CLLocation alloc] initWithLatitude:[obj2 coordinate].latitude longitude:[obj2 coordinate].longitude];
    
    CLLocationDistance d2 = [center distanceFromLocation:l2];
    
    NSComparisonResult result = NSOrderedDescending;
    
    if(d1 < d2)
        result = NSOrderedAscending;
    if(d1 == d2)
        result = NSOrderedSame;
    
    [l1 release];
    [l2 release];
    
    return result;
    
}

NSComparisonResult compareLocationsByDistanceToLocation(CLLocation* obj1, CLLocation* obj2, CLLocation* center){
        
    if(!center)
        return NSOrderedAscending;
        
    CLLocationDistance d1 = [center distanceFromLocation:obj1];
        
    CLLocationDistance d2 = [center distanceFromLocation:obj2];
    
    if(d1 < d2)
        return NSOrderedAscending;
    if(d1 == d2)
        return NSOrderedSame;
    
    return NSOrderedDescending;
    
}


#endif


Progress progressMake(unsigned long long complete, unsigned long long total){
    
    if(total == 0)
        return kProgressZero;
    
    Progress p;
    
    p.total = total;
    p.complete = complete;
    
    NSNumber* t = [NSNumber numberWithLongLong:total];
    NSNumber* c = [NSNumber numberWithLongLong:complete];
    
    double r = [c doubleValue]/[t doubleValue];
    
    p.ratio = r;
    
    return p;
}


Progress const kProgressZero = {
    0,
    0,
    0.0
};
