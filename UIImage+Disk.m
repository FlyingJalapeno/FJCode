//
//  UIImage+Disk.m
//  Carousel
//
//  Created by Corey Floyd on 12/31/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "UIImage+Disk.h"
#import "NSOperationQueue+Shared.h"
#import "NSString+extensions.h"


NSString* const FJSImageNotFoundKey = @"FJSimageNotFound";
NSString* const FJSImageKey = @"FJSImage";

NSString* const ImageWriteNotification = @"FJSimageWriteNotification";
NSString* const FJSImageWriteFailedKey = @"FJSimageWriteFailed";

NSString* const ImageFetchedAtPathNotification = @"FJSimageFetchedFromDisk";

static NSString* folderName = @"Images";
//static NSString* fetching = @"imageInCue";

createImagesDirectory()
{
	
	BOOL isDirectory;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[UIImage imageDirectoryPath] isDirectory:&isDirectory]) {
        
        if(!isDirectory){
            [[NSFileManager defaultManager] removeItemAtPath:[UIImage imageDirectoryPath] error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:[UIImage imageDirectoryPath] withIntermediateDirectories:NO attributes:nil error:nil];

        }
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[UIImage imageDirectoryPath]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[UIImage imageDirectoryPath] withIntermediateDirectories:NO attributes:nil error:nil];
        
    } 
    
    [[NSFileManager defaultManager] fileExistsAtPath:[UIImage imageDirectoryPath]];
    
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[UIImage imageCacheDirectoryPath] isDirectory:&isDirectory]) {
        
        if(!isDirectory){
            [[NSFileManager defaultManager] removeItemAtPath:[UIImage imageCacheDirectoryPath] error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:[UIImage imageCacheDirectoryPath] withIntermediateDirectories:NO attributes:nil error:nil];
            
        }
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[UIImage imageCacheDirectoryPath]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[UIImage imageCacheDirectoryPath] withIntermediateDirectories:NO attributes:nil error:nil];
        
    } 
    
    [[NSFileManager defaultManager] fileExistsAtPath:[UIImage imageCacheDirectoryPath]];

}



@implementation UIImage(File)

+ (NSString*)imageDirectoryPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
    NSString *fullPath = [directory stringByAppendingPathComponent:folderName];   
    return fullPath;
}

+ (NSString*)imageCacheDirectoryPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
    NSString *fullPath = [directory stringByAppendingPathComponent:folderName];   
    return fullPath;
}


+ (UIImage*)imageFromImageDirectoryNamed:(NSString*)fileName {
	
    NSString *fullPath = [[UIImage imageDirectoryPath] stringByAppendingPathComponent:fileName];
	UIImage *res = [UIImage imageWithContentsOfFile:fullPath];
    
	return res;
}

+ (UIImage*)imageFromImageCacheDirectoryNamed:(NSString*)fileName{
    
    NSString *fullPath = [[UIImage imageCacheDirectoryPath] stringByAppendingPathComponent:fileName];
    UIImage *res = [UIImage imageWithContentsOfFile:fullPath];
    
	return res;
    
}

- (BOOL)writeToImageDirectoryWithName:(NSString*)fileName{
    
    NSString *fullPath = [[UIImage imageDirectoryPath] stringByAppendingPathComponent:fileName];
    return [self writeToPath:fullPath];
}

- (BOOL)writeToImageCacheDirectoryWithName:(NSString*)fileName{
    
    NSString *fullPath = [[UIImage imageCacheDirectoryPath] stringByAppendingPathComponent:fileName];
    return [self writeToPath:fullPath];

}

- (NSString*)writeToimageDirectory{
    
    NSString* fileName = [[NSString GUIDString] stringByAppendingPathExtension:@"png"];    
    NSString *fullPath = [[UIImage imageDirectoryPath] stringByAppendingPathComponent:fileName];

    if([self writeToPath:fullPath])
        return fullPath;
    else
        return nil;
    
}
                                   
                            
- (NSString*)writeToimageCacheDirectory{
    
    NSString* fileName = [[NSString GUIDString] stringByAppendingPathExtension:@"png"];
    NSString *fullPath = [[UIImage imageCacheDirectoryPath] stringByAppendingPathComponent:fileName];
    
    if([self writeToPath:fullPath])
        return fullPath;
    else
        return nil;

}

- (BOOL)writeToPath:(NSString*)path{
	
    createImagesDirectory();
    
	NSData* imageData = UIImagePNGRepresentation(self); 
	
	[UIImage deleteImageAtPath:path];
	
    NSError* error = nil;
    BOOL success = [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
    	
    //debugLog([error description]);
    
	NSDictionary* userInfo = nil;
	
	if(success)
		userInfo = [NSDictionary dictionaryWithObject:path forKey:FJSImageWriteFailedKey];
	
	
	NSNotification* note = [NSNotification notificationWithName:ImageWriteNotification 
														 object:path 
													   userInfo:userInfo];
	
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) 
														   withObject:note 
														waitUntilDone:NO];
	
	
	return success; 
}



+ (BOOL)deleteImageAtPath:(NSString*)path{
	
	NSError* error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
	
	if(error!=nil)
		return NO;

	return YES;
}




@end





#pragma mark -
#pragma mark Hash

/*
 - (NSString*)imageHash{
 
 
 unsigned char result[16];
 NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self)];
 CC_MD5(imageData, [imageData length], result);
 NSString *ih = [NSString stringWithFormat:
 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
 result[0], result[1], result[2], result[3], 
 result[4], result[5], result[6], result[7],
 result[8], result[9], result[10], result[11],
 result[12], result[13], result[14], result[15]
 ];
 
 return ih;
 
 //TODO: make better
 return [NSString stringWithInt:[self hash]];
 
 
 }
*/



