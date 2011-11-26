//
//  MapViewController.m
//  SoleSearch
//
//  Created by Dan on 11/07/09.
//  Copyright 2009 Bawtree Software Contracting. All rights reserved.
//

#import "MapViewController.h"
#import "NSObject+Proxy.h"
#import "Functions.h"
#import "MKMapView+extensions.h"

@interface MapViewController()

@property (nonatomic) BOOL animatePinDrop;

@end


@implementation MapViewController
@synthesize mapView;
@synthesize numberOfLocationsToCenterMap;
@synthesize animatePinDrop;
@synthesize pinImage;


#pragma mark -
#pragma mark Cleanup

- (void)dealloc {

    [pinImage release];
    pinImage = nil;
    
    mapView.delegate = nil;
    [mapView release];
    mapView = nil;
    /*
     //Doing this to avoid crash from animations not completing before the view disapears
     dispatch_after(dispatchTimeFromNow(2), dispatch_get_main_queue(), ^{
     
     mapView.delegate = nil;
     //[mapView release];
     mapView = nil;
     
     });
     */
    [super dealloc];

    
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


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.mapView.delegate = nil;	
    
}


- (id)init {
    self = [super init];
    if (self) {
        self.numberOfLocationsToCenterMap = 25;
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.mapView.delegate = self;
    
}


#pragma mark -
#pragma mark MKMapView

- (void)reloadMapWithAnnotations:(NSArray*)annotations animated:(BOOL)animated{
    
    self.animatePinDrop = animated;
    
    [self.mapView removeAnnotations:[self.mapView annotationsWithoutUserAnnotation]];
        
    [self.mapView addAnnotationsSortedByDistanceFromUserLocation:annotations];
    
    [self.mapView smartCenterOnAnnotationsUpToIndex:self.numberOfLocationsToCenterMap withDefaultCenter:nil animated:YES];
    
}


#pragma mark -
#pragma mark Map View Delegate methods

- (MKAnnotationView*)mapView: (MKMapView*)mapView viewForAnnotation: (id <MKAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        
        return nil; 
    }
    

    if(self.pinImage == nil){
        
        MKPinAnnotationView* annotationView = nil;

        annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"locationAnnotation"];
        
        if (annotationView == nil)
        {
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier:@"locationAnnotation"] autorelease];
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.animatesDrop = self.animatePinDrop;
            
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        
        return annotationView;
        
        
    }else{
     
        
        MKAnnotationView* annotationView = nil;
        
        annotationView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"locationAnnotation"];
        
        if (annotationView == nil)
        {
            annotationView = [[[MKAnnotationView alloc]  initWithAnnotation:annotation reuseIdentifier:@"locationAnnotation"] autorelease];
            
            UIImage* i = self.pinImage;
            
            annotationView.image = i;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        
        return annotationView;
    }
        
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    NSArray* myAnnotations = [self.mapView annotationsWithoutUserAnnotation];
    
    if(self.pinImage && self.animatePinDrop){
        
        MKAnnotationView *aV; 
        
        NSUInteger count = [myAnnotations count];
        
        if(count > 20){
            
            for (aV in views) {            
                aV.alpha = 0.0;
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.7];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [aV setAlpha:1.0];
                [UIView commitAnimations];
                
            }
            
        }else{
            
            float offset = 0;
            float delta = 0.05;
            
            for (aV in views) {
                CGRect endFrame = aV.frame;
                
                aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 480.0, aV.frame.size.width, aV.frame.size.height);
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelay:offset];
                [UIView setAnimationDuration:0.7];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [aV setFrame:endFrame];
                [UIView commitAnimations];
                
                offset = offset + delta;
                
            }
        }
        
    }
    
    if([myAnnotations count] == 1){
        
        id<MKAnnotation> a = [myAnnotations firstObject];
        
        dispatchOnMainQueueAfterDelayInSeconds(1.0, ^{
            
            [self.mapView selectAnnotation:a animated:YES];
            
        });
    }
        
    
}



@end
