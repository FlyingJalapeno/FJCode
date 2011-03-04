

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate> {
	IBOutlet MKMapView *mapView;

    NSMutableArray* annotations;
        
    CLLocationCoordinate2D currentCcoordinate;
    CLLocationCoordinate2D defaultCoordinate;
        
    int numberOfLocationsToCenterMap; //default is 100
    BOOL shouldPromptToLaunchDirections;    
    id<MKAnnotation> selectedAnnotation;
    BOOL shouldAnimatePinDrop;
    
}
@property(nonatomic,retain)NSMutableArray *annotations;
@property (nonatomic) CLLocationCoordinate2D defaultCoordinate;

@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property(nonatomic,assign)CLLocationCoordinate2D currentCcoordinate;

@property (nonatomic) int numberOfLocationsToCenterMap;
@property (nonatomic) BOOL shouldPromptToLaunchDirections;
@property (nonatomic, retain) id<MKAnnotation> selectedAnnotation;
@property (nonatomic) BOOL shouldAnimatePinDrop;


//subclasses overide
- (void)selectedAnnotation:(id<MKAnnotation>)anAnnotation;

//NOTE: if you overide this method in your custom subclass, be sure to forward to super if you want directions to work!
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
