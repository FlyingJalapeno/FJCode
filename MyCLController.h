

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MyCLController : NSObject <CLLocationManagerDelegate>  {	
    
	CLLocationManager *locationManager;
            	
	BOOL locationServicesEnabled;
    
    NSTimer* updateTimer;
    
    NSDate* lastActiveTime;
	
}

@property(nonatomic, retain, readonly)CLLocation *location;
@property(nonatomic, readwrite)BOOL locationServicesEnabled;
@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, copy) NSDate *lastActiveTime;

+ (MyCLController *)sharedMyCLController;

- (void)startUpdating;
- (void)stopUpdating;

- (void)printDescription;

@end
