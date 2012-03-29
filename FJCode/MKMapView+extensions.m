//
//  MKMapView+extensions.m
//  Congress
//
//  Created by Corey Floyd on 11/22/11.
//  Copyright (c) 2011 Flying Jalapeño. All rights reserved.
//

#import "MKMapView+extensions.h"
#import "NSArray+extensions.h"

@implementation MKMapView (extensions)


- (void)addAnnotationsSortedByDistanceFromUserLocation:(NSArray *)someAnnotations{
    
    NSArray* sorted = [someAnnotations sortedArrayUsingComparator:^NSComparisonResult(id<MKAnnotation> obj1, id<MKAnnotation> obj2) {
        
        CLLocation* user = [self userLocation].location;
        
        return compareAnnotationsByDistanceToLocation(obj1, obj2, user);
        
    }];
    
	[self addAnnotations:sorted];	

}


- (NSArray*)annotationsWithoutUserAnnotation{
    
    NSArray* myAnnotations = [self.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"!(self isKindOfClass: %@)", [MKUserLocation class]]];
   
    return myAnnotations;
}

- (void)centerOnAnnotations:(NSArray*)someAnnotations animated:(BOOL)animated{
    
    if([someAnnotations count] == 0)
        return;
    
    if([someAnnotations count] == 1){
        
        [self centerOnLocation:[someAnnotations firstObject] animated:animated];
    }
    
    
    CLLocationCoordinate2D	minCoord;
	CLLocationCoordinate2D	maxCoord;
    
    minCoord.latitude = 90.0f;
	minCoord.longitude = 180.0f;
    maxCoord.latitude = -90.0f;
	maxCoord.longitude = -180.0f;
	
    int i = 1;
    
	for (id<MKAnnotation> annotation in someAnnotations)
	{
        
        if(i == 1){
            
            minCoord.latitude = annotation.coordinate.latitude;
            minCoord.longitude = annotation.coordinate.longitude;
            maxCoord.latitude = annotation.coordinate.latitude;
            maxCoord.longitude = annotation.coordinate.longitude;
            
        }else{
            
            if (annotation.coordinate.latitude < minCoord.latitude)
            {
                minCoord.latitude = annotation.coordinate.latitude;
            }
            
            if (annotation.coordinate.longitude < minCoord.longitude)
            {
                minCoord.longitude = annotation.coordinate.longitude;
            }
            
            if (annotation.coordinate.latitude > maxCoord.latitude)
            {
                maxCoord.latitude = annotation.coordinate.latitude;
            }
            
            if (annotation.coordinate.longitude > maxCoord.longitude)
            {
                maxCoord.longitude = annotation.coordinate.longitude ;
            }
        }
        
        i++;
	}
	
	MKCoordinateRegion	locationsRegion;
	
	locationsRegion.center.latitude = (CLLocationDegrees)((maxCoord.latitude + minCoord.latitude) / 2.0f);
	locationsRegion.center.longitude = (CLLocationDegrees)((maxCoord.longitude + minCoord.longitude) / 2.0f);
	
	locationsRegion.span.latitudeDelta = (maxCoord.latitude - minCoord.latitude) + 0.001;
	locationsRegion.span.longitudeDelta = (maxCoord.longitude - minCoord.longitude) + 0.001f;
	
	[self setRegion:locationsRegion animated:animated];
}

- (void)centerOnAllAnnotationsAnimated:(BOOL)animated{
    
    [self centerOnAnnotations:self.annotations animated:animated];
    
}

- (void)centerOnAnnotationsUpToIndex:(NSUInteger)index animated:(BOOL)animated{
    
    NSArray* enough = [self annotationsWithoutUserAnnotation];
    
    if([enough count] > index)
        enough = [enough objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index-1)]];

    [self centerOnAnnotations:enough animated:animated];
  
    
}

- (void)smartCenterOnAnnotationsUpToIndex:(NSUInteger)index withDefaultCenter:(CLLocation*)center animated:(BOOL)animated{
    
    NSArray* myAnnotations = [self annotationsWithoutUserAnnotation];

    //center on defualt if no locations
    if([myAnnotations count] == 0){
        
        if([self userLocation].location){
            
            [self centerOnLocation:[self userLocation].location animated:animated];

        }else{
         
            [self centerOnLocation:center animated:animated];

        }
        
        return;
    }
            
    [self centerOnAnnotationsUpToIndex:index animated:animated];

}

- (void)centerOnCoordinate:(CLLocationCoordinate2D)coord animated:(BOOL)animated{
    
    MKCoordinateRegion	locationsRegion;
	
	locationsRegion.center.latitude = coord.latitude;
	locationsRegion.center.longitude = coord.longitude;
	
	locationsRegion.span.latitudeDelta = 0.01f;
	locationsRegion.span.longitudeDelta = 0.01f;
	
	[self setRegion:locationsRegion animated:animated];
}

- (void)centerOnLocation:(CLLocation*)aLocation animated:(BOOL)animated{
    
    if(aLocation == nil)
        return;
    
    CLLocationCoordinate2D coord = [aLocation coordinate];
    
    [self centerOnCoordinate:coord animated:animated];

}

- (void)centerOnAnnotation:(id<MKAnnotation>)anAnnotation animated:(BOOL)animated{
    
    if(anAnnotation == nil)
        return;
    
    CLLocationCoordinate2D coord = [anAnnotation coordinate];
    
    [self centerOnCoordinate:coord animated:animated];
}

@end
