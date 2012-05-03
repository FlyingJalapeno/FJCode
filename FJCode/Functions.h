
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#pragma mark -
#pragma mark paths

static inline NSString* documentsDirectory(){
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
}

static inline NSString* cachesDirectory(){
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
}

static inline NSString* tempDirectory(){
    
    return [NSSearchPathForDirectoriesInDomains(NSTemporaryDirectory, NSUserDomainMask, YES) lastObject];
    
}

static inline NSString* fileNameBasedOnCurrentTime() {
	NSString* fileName = [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"png"];
	return fileName;
}


BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL);

#pragma mark -
#pragma mark size

NSUInteger sizeOfFolderContentsInBytes(NSString* folderPath);
double megaBytesWithBytes(long long bytes);
double gigaBytesWithBytes(long long bytes);
NSString* prettySizeStringWithBytesRounded(long long bytes); //includes MB or GB in string
NSString* prettySizeStringWithBytesFloored(long long bytes); //same

#pragma mark -
#pragma mark time

float nanosecondsWithSeconds(float seconds);
dispatch_time_t dispatchTimeFromNow(float seconds);

static inline NSString* timeZoneString(){
    NSTimeZone* ltz = [NSTimeZone localTimeZone];
    NSString* abbreviation = [ltz abbreviation];
    return abbreviation;
}

CGFloat BNRTimeBlock (void (^block)(void));


#pragma mark -
#pragma mark NSRange

BOOL rangesAreContiguous(NSRange first, NSRange second);

NSRange rangeWithFirstAndLastIndexes(NSUInteger first, NSUInteger last);


#pragma mark -
#pragma mark Dispatch Help

void dispatchOnMainQueue(dispatch_block_t block);
void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block);

void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block);


#define degreesToRadians(x) (M_PI * x / 180.0)

#pragma mark -
#pragma mark CG

CGRect rectExpandedByValue(CGRect rect,  float expandRadius);
CGRect rectContractedByValue(CGRect rect,  float expandRadius);
CGPoint centerOfRect(CGRect rect);


#pragma mark -
#pragma mark Location

void openGoogleMapsForDirectionsWithLocations(CLLocation* startLocation, CLLocation* endLocation);

void showPromptAndOpenGoogleMapsForDirectionsWithLocations(CLLocation* startLocation, CLLocation* endLocation, void(^block)(BOOL didOpenMap));

NSComparisonResult compareAnnotationsByDistanceToLocation(id<MKAnnotation> obj1, id<MKAnnotation> obj2, CLLocation* center);

NSComparisonResult compareLocationsByDistanceToLocation(CLLocation* obj1, CLLocation* obj2, CLLocation* center);



#pragma mark -
#pragma mark Progress

typedef struct {
    unsigned long long complete;
    unsigned long long total;
    double ratio;
} Progress;

Progress progressMake(unsigned long long complete, unsigned long long total);
extern Progress const kProgressZero;

