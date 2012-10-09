//
//  UIImage+Disk.h
//  Carousel
//
//  Created by Corey Floyd on 12/31/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <UIKit/UIKit.h>


//these methods will overwrite existing files with aplumb!

@interface UIImage(File)

//returns path
- (NSString*)writeToimageDirectory;
- (NSString*)writeToimageCacheDirectory;


// ~/Documents/images/
+ (NSString*)imageDirectoryPath;
+ (UIImage*)imageFromImageDirectoryNamed:(NSString*)fileName;
- (BOOL)writeToImageDirectoryWithName:(NSString*)fileName;

// ~/Caches/images/
+ (NSString*)imageCacheDirectoryPath;
//+ (UIImage*)imageFromImageCacheDirectoryNamed:(NSString*)fileName;
//- (BOOL)writeToImageCacheDirectoryWithName:(NSString*)fileName;

//Write to arbitrary path
- (BOOL)writeToPath:(NSString*)path;

//Delete an item at an arbitrary path
+ (BOOL)deleteImageAtPath:(NSString*)path;


@end





