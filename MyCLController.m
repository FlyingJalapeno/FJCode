#import "MyCLController.h"
#import "SynthesizeSingleton.h"

NSString* const LocationServicesDenied = @"LocationServicesDenied";
CLLocationDistance const kLocationDistanceFilter = 100.0;

@interface MyCLController()

@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic, retain, readwrite)CLLocation *location;

@end


@implementation MyCLController

SYNTHESIZE_SINGLETON_FOR_CLASS(MyCLController)

@synthesize locationManager, location, locationServicesEnabled;
@synthesize updateTimer;
@synthesize lastActiveTime;


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [lastActiveTime release];
    lastActiveTime = nil;
    
    [updateTimer release];
    updateTimer = nil;
    
    [location release];
    location = nil;
    
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
	[locationManager release];
        
	[super dealloc];
}

- (id)init {
	if ((self = [super init])) {
		
		self.locationServicesEnabled = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveWithNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveWithNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        
	}
	return self;
}

- (void)applicationDidBecomeActiveWithNotification:(NSNotification*)note{
    
    if(self.lastActiveTime == nil || [[NSDate date] timeIntervalSinceDate:self.lastActiveTime] > 60.0){
        
        self.location = nil;
        
        debugLog(@"app activated");
        [self startUpdating];
        
        self.lastActiveTime = [NSDate date];
        
    }
    
}

- (void)applicationWillResignActiveWithNotification:(NSNotification*)note{
    
    debugLog(@"app resigned");
    //[self stopUpdating];
}



#pragma mark -
#pragma mark [self class]


- (void)startUpdating {
    
	if (!self.locationServicesEnabled)
		return;
    
    //start timer if needed
    if(self.updateTimer == nil){
        
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(startUpdating) userInfo:nil repeats:YES];
        
    }
    
    //create location manager if needed
    if (self.locationManager == nil) {
        
        debugLog(@"creating location manager");
        [self printDescription];
        
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self; 
		locationManager.distanceFilter = kLocationDistanceFilter;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        debugLog(@"location manager created");
        [self printDescription];
        
    }
    
    //if we are denied, then wtf
	if (![CLLocationManager locationServicesEnabled]) {
		self.locationServicesEnabled = NO;
        NSLog(@"location services disabled");
        [self printDescription];
        self.location = nil;
		return;
        
	}else{
        
        self.locationServicesEnabled = YES;
    }
    
    //stop updating, ensures there will in fact be an update.
    [self.locationManager stopUpdatingLocation];
    self.location = nil;
    
    debugLog(@"starting location manager");
    [self printDescription];
    
    [self.locationManager startUpdatingLocation];
    
    debugLog(@"location manager started");
    [self printDescription];
	
}

- (void)stopUpdating {
    
    debugLog(@"stoping location manager");
    [self printDescription];
    
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
	self.locationManager = nil;
    
    debugLog(@"location manager stopped");
    [self printDescription];
    
    
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    self.location = newLocation;
    
    if(self.location != nil){
        
    }
    
    debugLog(@"location found");
    [self printDescription];
    
	debugLog(@"%@", [newLocation description]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
	if ([error code] == kCLErrorDenied) {
                
        NSLog(@"Location services denied");
        
		[self stopUpdating];
		self.locationManager = nil;
		self.locationServicesEnabled = NO;
        
        [self printDescription];
        
	}else{
        
        
    }
    
    self.location = nil;
    
    NSLog(@"location updates failed for reason: %@", [error description]);
    [self printDescription];
    
}


- (void)printDescription{
    
    debugLog(@"%@", [self description]);
    
}

- (NSString*)description{
    
    NSMutableString* desc = [NSMutableString string];    
    
    [desc appendString:@"\n +++++++++++++++++++++++++++++++++ \n\n"];
    
    
    [desc appendString:@"-------- Application Settings --------  \n"];
    [desc appendString:@"\n"];
    
    
    if([CLLocationManager locationServicesEnabled])
        [desc appendString:@"Location Servecies Enabled! \n"];
    else
        [desc appendString:@"Location Servecies Disabled! \n"];
    
    
    [desc appendString:@"\n"];
    [desc appendString:@"-------- Location Manager Delegate--------  \n"];
    [desc appendString:@"\n"];
    
    
    if([self location] != nil)
        [desc appendFormat:@"Current Location: %@ \n", [self.location description]];
    else
        [desc appendString:@"Location Manager Delegate has no Current Location! \n"];
    
    
    [desc appendString:@"\n"];
    [desc appendString:@"-------- Location Manager --------  \n"];
    [desc appendString:@"\n"];
    
    if(self.locationManager != nil){
        
        [desc appendFormat:@"Location Manager: %@ \n", [self.locationManager description]];
        
        [desc appendFormat:@"Distance Filter: %f meters \n", self.locationManager.distanceFilter];
        [desc appendFormat:@"Desired Accuracy : %f meters \n", self.locationManager.desiredAccuracy];
        
        
        if([self.locationManager location] != nil)
            [desc appendFormat:@"Current Location: %@ \n", [self.locationManager.location description]];
        else
            [desc appendString:@"Location Manager has no Current Location! \n"];
        
    }
    else{
        
        [desc appendString:@"Location Manager is nil! \n"];
        
    }
    
    [desc appendString:@"\n +++++++++++++++++++++++++++++++++ \n"];
    
    return desc;
    
}

@end

