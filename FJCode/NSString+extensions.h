//
//  NSString+extensions.h
//  CMN2
//
//  Created by Corey Floyd on 4/27/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <Foundation/Foundation.h>


/* 
 * Short hand NSLocalizedString, doesn't need 2 parameters
 */
#define LocalizedString(s) NSLocalizedString(s,s)

/*
 * LocalizedString with an additionl parameter for formatting
 */
#define LocalizedStringWithFormat(s,...) [NSString stringWithFormat:NSLocalizedString(s,s),##__VA_ARGS__]

enum {
	NSTruncateStringPositionStart=0,
	NSTruncateStringPositionMiddle,
	NSTruncateStringPositionEnd
}; typedef int NSTruncateStringPosition;



@interface NSString (comparison) 

- (NSComparisonResult)localizedCaseInsensitiveArticleStrippingCompare:(NSString*)aString;

@end



@interface NSString (encoding)

- (NSString *)encodedURLString;
- (NSString *)encodedURLParameterString;
- (NSString *)decodedURLString;
- (NSString *)removeQuotes;

@end


@interface NSString (parsing) 

-(NSArray *)csvRows;

@end

@interface NSString (exstensions) 

#ifndef TARGET_OS_MAC
- (CGSize)sizeForMultiLineLabelWithFont:(UIFont **)font minimumFontSize:(CGFloat)minimumFontSize constrainedToSize:(CGSize)size;
#endif


- (BOOL)isCaseInsensitiveEqualToString:(NSString *)aString;

- (BOOL)doesContainString:(NSString *)aString;
/*
 * Checks to see if the string contains the given string, case insenstive
 */
- (BOOL)containsString:(NSString*)string;

- (NSString*) decomposeAndFilterString: (NSString*) string;
/*
 * Checks to see if the string contains the given string while allowing you to define the compare options
 */
- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;

- (NSRange)fullRange;
- (NSString*)stringByDeletingLastCharacter;
- (NSString*)stringByRemovingCharactersFromEnd:(NSUInteger)chars;
- (NSString*)stringByRemovingCharactersFromBeginning:(NSUInteger)chars;
- (NSString*)stringByRemovingArticlePrefixes;

- (NSString*)stringByRemovingQueryString;

//replaces deprecated methods below
- (BOOL)containsCharacters; //tests if length is > 0, does not count whitespace
- (BOOL)containsCharactersIncludeWhiteSpace:(BOOL)flag; //whitespace optional

- (NSString*)nilIfZeroLength; //doesNotCountWhiteSpace

//DEPRECATED, same as above
- (BOOL)isNotEmpty; //__OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0)
- (BOOL)isEmpty; //__OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0)

+ (NSString*)GUIDString;
- (NSString*)md5;

/*
 * Truncate string to length
 */
- (NSString*)stringByTruncatingToLength:(int)length;
- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom;
- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom withEllipsisString:(NSString*)ellipsis;


- (NSString*)stringByTrimmingWhiteSpace;


- (NSString*) stringByPreparingForURL;

- (NSString*) stringByRemovingHTMLTags;


@end

@interface NSString (NumberStuff) 

+ (NSString*)secondsToStringWithHours:(int)seconds;

+ (NSString*)stringWithInt:(int)anInteger;
+ (NSString*)stringWithFloat:(float)aFloat decimalPlaces:(int)decimalPlaces;
+ (NSString*)stringWithDouble:(double)aDouble decimalPlaces:(int)decimalPlaces;

- (BOOL)holdsFloatingPointValue;
- (BOOL)holdsFloatingPointValueForLocale:(NSLocale *)locale;
- (BOOL)holdsIntegerValue;

/*
 * Returns the long value of the string
 */
- (long)longValue;

+ (NSString *) commasForNumber: (long long) num;


@end



typedef enum {
	StringValidationTypeEmail = 0,
	StringValidationTypePhone,
    StringValidationTypeZip
} StringValidationType;

@interface NSString (Validation)


+ (NSPredicate *)predicateForWhiteSpace;
+ (NSPredicate *)predicateForEmail;
+ (NSPredicate *)predicateForPhone;
+ (NSPredicate *)predicateForZip;

+ (NSPredicate *)predicateForStongPasswordLength:(NSUInteger)length; //requires special character "@#$%^&+=", upper case, lower case, number
+ (NSPredicate *)predicateForMediumPasswordLength:(NSUInteger)length; //requires upper case, lower case, number
+ (NSPredicate *)predicateForWeakPasswordLength:(NSUInteger)length; //requires letter, number



- (BOOL)isValid:(StringValidationType)type acceptWhiteSpace:(BOOL)acceptWhiteSpace;

- (BOOL)validatesWithPredicate:(NSPredicate*)predicate acceptWhiteSpace:(BOOL)acceptWhiteSpace;

@end



@interface NSMutableString (charManipulation)

- (void)removeLastCharacter;


@end


@interface NSString (caseManipulation)


- (NSString *)deCamelizeWith:(NSString *)delimiter;

/**
 * Return the dashed form af this camelCase string:
 *
 *   [@"camelCase" dasherize] //> @"camel-case"
 */
- (NSString *)dasherize;

/**
 * Return the underscored form af this camelCase string:
 *
 *   [@"camelCase" underscore] //> @"camel_case"
 */
- (NSString *)underscore;

/**
 * Return the camelCase form af this dashed/underscored string:
 *
 *   [@"camel-case_string" camelize] //> @"camelCaseString"
 */
- (NSString *)camelize;

/**
 * Return a copy of the string suitable for displaying in a title. Each word is downcased, with the first letter upcased.
 */
- (NSString *)titleize;

/**
 * Return a copy of the string with the first letter capitalized.
 */
- (NSString *)toClassName;

@end

