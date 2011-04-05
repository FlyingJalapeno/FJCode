//
//  NSString+extensions.m
//  CMN2
//
//  Created by Corey Floyd on 4/27/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "NSString+extensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (comparison) 

- (NSComparisonResult)localizedCaseInsensitiveArticleStrippingCompare:(NSString*)aString{
    
    NSString* firstString = [self stringByRemovingArticlePrefixes];
    aString = [aString stringByRemovingArticlePrefixes];
    
    return [firstString localizedCaseInsensitiveCompare:aString];    
    
}


@end


@implementation NSString (parsing) 

-(NSArray *)csvRows {
    NSMutableArray *rows = [NSMutableArray array];
    
    // Get newline character set
    NSMutableCharacterSet *newlineCharacterSet = (id)[NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [newlineCharacterSet formIntersectionWithCharacterSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];
    
    // Characters that are important to the parser
    NSMutableCharacterSet *importantCharactersSet = (id)[NSMutableCharacterSet characterSetWithCharactersInString:@",\""];
    [importantCharactersSet formUnionWithCharacterSet:newlineCharacterSet];
    
    // Create scanner, and scan string
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    while ( ![scanner isAtEnd] ) {        
        BOOL insideQuotes = NO;
        BOOL finishedRow = NO;
        NSMutableArray *columns = [NSMutableArray arrayWithCapacity:10];
        NSMutableString *currentColumn = [NSMutableString string];
        while ( !finishedRow ) {
            NSString *tempString;
            if ( [scanner scanUpToCharactersFromSet:importantCharactersSet intoString:&tempString] ) {
                [currentColumn appendString:tempString];
            }
            
            if ( [scanner isAtEnd] ) {
                if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
                finishedRow = YES;
            }
            else if ( [scanner scanCharactersFromSet:newlineCharacterSet intoString:&tempString] ) {
                if ( insideQuotes ) {
                    // Add line break to column text
                    [currentColumn appendString:tempString];
                }
                else {
                    // End of row
                    if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
                    finishedRow = YES;
                }
            }
            else if ( [scanner scanString:@"\"" intoString:NULL] ) {
                if ( insideQuotes && [scanner scanString:@"\"" intoString:NULL] ) {
                    // Replace double quotes with a single quote in the column string.
                    [currentColumn appendString:@"\""]; 
                }
                else {
                    // Start or end of a quoted string.
                    insideQuotes = !insideQuotes;
                }
            }
            else if ( [scanner scanString:@"," intoString:NULL] ) {  
                if ( insideQuotes ) {
                    [currentColumn appendString:@","];
                }
                else {
                    // This is a column separating comma
                    [columns addObject:currentColumn];
                    currentColumn = [NSMutableString string];
                    [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:NULL];
                }
            }
        }
        if ( [columns count] > 0 ) [rows addObject:columns];
    }
    
    return rows;
}

@end


@implementation NSString (exstensions) 

- (BOOL)containsString:(NSString*)string {
	return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}


- (BOOL)containsCharacters{

    return [self containsCharactersIncludeWhiteSpace:NO];
}

- (BOOL)containsCharactersIncludeWhiteSpace:(BOOL)flag{
        
    if(!flag){
        
        NSString* stripped = [self stringByTrimmingWhiteSpace];
        
        if([stripped length]==0)
            return NO;
    }
	
    if([self length] == 0)
        return NO;
    
    return YES;
}

- (NSString*)nilIfZeroLength{
    
    if([self containsCharacters])
        return self;
    
    return nil;
}

- (BOOL)isNotEmpty{
    
	BOOL answer = YES;
    
	NSString* stripped = [self stringByTrimmingWhiteSpace];
	
    if([stripped length]==0)
        answer = NO;
    return answer;
}



- (BOOL)isEmpty{
    
	BOOL answer = NO;
    
	NSString* stripped = [self stringByTrimmingWhiteSpace];
	
    if([stripped length]==0)
        answer = YES;
    return answer;
}


- (BOOL)doesContainString:(NSString *)aString{
    
    BOOL answer = YES;
    
    NSRange rangeOfSubString = [self rangeOfString:aString];
    
    if(rangeOfSubString.location == NSNotFound)
        answer = NO;
    
    return answer;
    
}

- (NSRange)fullRange{
    
    return (NSMakeRange(0, [self length]));
}

- (NSString*)stringByDeletingLastCharacter{
    
    if([self length]==0)
        return self;
    
    return [NSString stringWithString:[self substringToIndex:([self length]-1)]];
    
    
}

- (NSString*)stringByRemovingArticlePrefixes{
    
    if([self length] < 5)
        return self; 
    
    NSString* aString = [[self copy] autorelease];
    
    if([[aString substringToIndex:4] doesContainString:@"The "]){
        
        aString = [aString substringFromIndex:4];
        aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    }else if([[aString substringToIndex:4] doesContainString:@"the "]){
        
        aString = [aString substringFromIndex:4];
        aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    return aString;
}

- (NSString*)stringByTrimmingWhiteSpace{
    
   	NSString* stripped = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return stripped;
    
}


+ (NSString*)GUIDString {
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];
}


/*
 * We did not write the method below
 * It's all over Google and we're unable to find the original author
 * Please contact info@enormego.com with the original author and we'll
 * Update this comment to reflect credit
 */
- (NSString*)md5 {
	const char* string = [self UTF8String];
	unsigned char result[16];
	CC_MD5(string, strlen(string), result);
	NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
					  result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], 
					  result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
	
	return [hash lowercaseString];
}

- (NSString*)stringByTruncatingToLength:(int)length {
	return [self stringByTruncatingToLength:length direction:NSTruncateStringPositionEnd];
}

- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom {
	return [self stringByTruncatingToLength:length direction:truncateFrom withEllipsisString:@"..."];
}

- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom withEllipsisString:(NSString*)ellipsis {
	NSMutableString *result = [[NSMutableString alloc] initWithString:self];
	NSString *immutableResult;
	
	if([result length] <= length) {
		[result release];
		return self;
	}
	
	unsigned int charactersEachSide = length / 2;
	
	NSString* first;
	NSString* last;
	
	switch(truncateFrom) {
		case NSTruncateStringPositionStart:
			[result insertString:ellipsis atIndex:[result length] - length + [ellipsis length] ];
			immutableResult  = [[result substringFromIndex:[result length] - length] copy];
			[result release];
			return [immutableResult autorelease];
		case NSTruncateStringPositionMiddle:
			first = [result substringToIndex:charactersEachSide - [ellipsis length]+1];
			last = [result substringFromIndex:[result length] - charactersEachSide];
			immutableResult = [[[NSArray arrayWithObjects:first, last, NULL] componentsJoinedByString:ellipsis] copy];
			[result release];
			return [immutableResult autorelease];
		default:
		case NSTruncateStringPositionEnd:
			[result insertString:ellipsis atIndex:length - [ellipsis length]];
			immutableResult  = [[result substringToIndex:length] copy];
			[result release];
			return [immutableResult autorelease];
	}
}

- (NSString *)stringByPreparingForURL {
	NSString *escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																				  (CFStringRef)self,
																				  NULL,
																				  (CFStringRef)@":/?=,!$&'()*+;[]@#",
																				  CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	
	return [escapedString autorelease];
}



@end


@implementation NSString(NumberStuff)


+ (NSString*)stringWithInt:(int)anInteger{
    
    return [NSString stringWithFormat:@"%i", anInteger];
    
}

+ (NSString*)stringWithFloat:(float)aFloat decimalPlaces:(int)decimalPlaces{
    
    NSMutableString *formatString = [NSMutableString stringWithString:@"%."];
    [formatString appendString:[NSString stringWithInt:decimalPlaces]];
    [formatString appendString:@"f"];
    return [NSString stringWithFormat:formatString, aFloat];
    
}

+ (NSString*)stringWithDouble:(double)aDouble decimalPlaces:(int)decimalPlaces{
    
    NSMutableString *formatString = [NSMutableString stringWithString:@"%."];
    [formatString appendString:[NSString stringWithInt:decimalPlaces]];
    [formatString appendString:@"f"];
    return [NSString stringWithFormat:formatString, aDouble];
    
}



- (BOOL)holdsFloatingPointValue
{
    return [self holdsFloatingPointValueForLocale:[NSLocale currentLocale]];
}
- (BOOL)holdsFloatingPointValueForLocale:(NSLocale *)locale
{
    NSString *currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    NSString *decimalSeparator = [locale objectForKey:NSLocaleDecimalSeparator];
    NSString *groupingSeparator = [locale objectForKey:NSLocaleGroupingSeparator];
    
    
    // Must be at least one character
    if ([self length] == 0)
        return NO;
    NSString *compare = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Strip out grouping separators
    compare = [compare stringByReplacingOccurrencesOfString:groupingSeparator withString:@""];
    
    // We'll allow a single dollar sign in the mix
    if ([compare hasPrefix:currencySymbol])
    {   
        compare = [compare substringFromIndex:1];
        // could be spaces between dollar sign and first digit
        compare = [compare stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    NSUInteger numberOfSeparators = 0;
    
    NSCharacterSet *validCharacters = [NSCharacterSet decimalDigitCharacterSet];
    for (NSUInteger i = 0; i < [compare length]; i++) 
    {
        unichar oneChar = [compare characterAtIndex:i];
        if (oneChar == [decimalSeparator characterAtIndex:0])
            numberOfSeparators++;
        else if (![validCharacters characterIsMember:oneChar])
            return NO;
    }
    return (numberOfSeparators == 1);
    
}
- (BOOL)holdsIntegerValue
{
    if ([self length] == 0)
        return NO;
    
    NSString *compare = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet *validCharacters = [NSCharacterSet decimalDigitCharacterSet];
    for (NSUInteger i = 0; i < [compare length]; i++) 
    {
        unichar oneChar = [compare characterAtIndex:i];
        if (![validCharacters characterIsMember:oneChar])
            return NO;
    }
    return YES;
}

- (long)longValue {
	return (long)[self longLongValue];
}

// return a comma delimited string
+ (NSString *) commasForNumber: (long long) num
{
	if (num < 1000) return [NSString stringWithFormat:@"%d", num];
	return	[[self commasForNumber:num/1000] stringByAppendingFormat:@",%03d", (num % 1000)];
}

@end



@implementation NSString (Validation)

+ (NSPredicate *)predicateForWhiteSpace {
	
	NSString *whiteSpaceRegex = @"[\\s]*"; 
	return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", whiteSpaceRegex]; 
	
}

+ (NSPredicate *)predicateForEmail {
	
	NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
}

+ (NSPredicate *)predicateForPhone {
	
	NSString *regex = @"[-0-9 \\(\\)]{7,18}"; 
	return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
}

+ (NSPredicate *)predicateForZip {
	
	NSString *regex = @"[0-9]{5}"; 
	return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
}

+ (NSPredicate *)predicateForStongPasswordLength:(NSUInteger)length {
	
	NSString *regex = [NSString stringWithFormat:@"^.*(?=.{%i,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$", length]; 
	return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
}

+ (NSPredicate *)predicateForMediumPasswordLength:(NSUInteger)length{
    
    NSString *regex = [NSString stringWithFormat:@"^.*(?=.{%i,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).*$", length]; 
	return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
}
+ (NSPredicate *)predicateForWeakPasswordLength:(NSUInteger)length{
    
    NSString *regex = [NSString stringWithFormat:@"^.*(?=.{%i,})(?=.*\\d)(?=.*[A-Za-z]).*$", length]; 
	return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

}


- (BOOL)isValid:(int)type acceptWhiteSpace:(BOOL)acceptWhiteSpace {	
	
	NSPredicate *primaryPredicate = nil;
	
	switch (type) {
		case StringValidationTypeEmail:
			primaryPredicate = [[self class] predicateForEmail];
			break;
		case StringValidationTypePhone:
			primaryPredicate = [[self class] predicateForPhone];
			break;
        case StringValidationTypeZip:
			primaryPredicate = [[self class] predicateForZip];
			break;    
	}
	
	
	NSPredicate *finalPredicate = primaryPredicate;
	
	if (acceptWhiteSpace) {
		
		NSPredicate *whiteSpacePredicate = [[self class] predicateForWhiteSpace];
        NSArray* a = [NSArray arrayWithObjects:primaryPredicate, whiteSpacePredicate, nil];
		finalPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:a]; 
		
	}
	
	return [finalPredicate evaluateWithObject:self];
	
}

- (BOOL)validatesWithPredicate:(NSPredicate*)predicate acceptWhiteSpace:(BOOL)acceptWhiteSpace{
    
    NSPredicate *finalPredicate = predicate;
	
	if (acceptWhiteSpace) {
		
		NSPredicate *whiteSpacePredicate = [[self class] predicateForWhiteSpace];
        NSArray* a = [NSArray arrayWithObjects:finalPredicate, whiteSpacePredicate, nil];
		finalPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:a]; 
		
	}
	
	return [finalPredicate evaluateWithObject:self];
    
}

@end

@implementation NSMutableString (charManipulation)

- (void)removeLastCharacter{
    
    [self deleteCharactersInRange:NSMakeRange([self length]-1, 1)];
    
}

@end

@implementation NSString (InflectionSupport)

/*
- (NSCharacterSet *)capitals {
	return [NSCharacterSet uppercaseLetterCharacterSet];
}

- (NSString *)deCamelizeWith:(NSString *)delimiter {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer ];
	NSMutableString *underscored = [NSMutableString string];
	
	NSString *currChar;
	for (int i = 0; i < [self length]; i++) {
		currChar = [NSString stringWithCharacters:buffer+i length:1];
		if([[self capitals] characterIsMember:buffer[i]]) {
			if (0 != i) {
				[underscored appendFormat:@"%@%@", delimiter, [currChar lowercaseString]];
			} else {
				[underscored appendFormat:@"%@", [currChar lowercaseString]];
			}
		} else {
			[underscored appendString:currChar];
		}
	}
	
	free(buffer);
	return underscored;
}


- (NSString *)dasherize {
	return [self deCamelizeWith:@"-"];
}

- (NSString *)underscore {
	return [self deCamelizeWith:@"_"];
}

- (NSCharacterSet *)camelcaseDelimiters {
	return [NSCharacterSet characterSetWithCharactersInString:@"-_"];
}

- (NSString *)camelize {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer ];
	NSMutableString *underscored = [NSMutableString string];
	
	BOOL capitalizeNext = NO;
	NSCharacterSet *delimiters = [self camelcaseDelimiters];
	for (int i = 0; i < [self length]; i++) {
		NSString *currChar = [NSString stringWithCharacters:buffer+i length:1];
		if([delimiters characterIsMember:buffer[i]]) {
			capitalizeNext = YES;
		} else {
			if(capitalizeNext) {
				[underscored appendString:[currChar uppercaseString]];
				capitalizeNext = NO;
			} else {
				[underscored appendString:currChar];
			}
		}
	}
	
	free(buffer);
	return underscored;
	
}

- (NSString *)titleize {
	NSArray *words = [self componentsSeparatedByString:@" "];
	NSMutableString *output = [NSMutableString string];
	for (NSString *word in words) {
		[output appendString:[[word substringToIndex:1] uppercaseString]];
		[output appendString:[[word substringFromIndex:1] lowercaseString]];
		[output appendString:@" "];
	}
	return [output substringToIndex:[self length]];
}

- (NSString *)toClassName {
	NSString *result = [self camelize];
	return [result stringByReplacingCharactersInRange:NSMakeRange(0,1) 
										   withString:[[result substringWithRange:NSMakeRange(0,1)] uppercaseString]];
}
 
 */

@end
