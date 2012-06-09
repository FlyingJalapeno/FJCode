
extern NSString* const FJNetworkErrorDomain;
extern NSString* const FJNetworkServerErrorDomain;


typedef enum  {
    
    FJNetworkErrorUnknown,
    FJNetworkErrorNilNetworkResponse,
    FJNetworkErrorJSONParse,
    FJNetworkErrorInvalidResponse,
    FJNetworkErrorNotAuthenticated,
    FJNetworkErrorCorruptImageResponse,
    FJNetworkErrorPasswordResetRequired,
    FJNetworkErrorMissingRequiredInfo,
    FJNetworkErrorInvalidCredentials
    
} FJNetworkErrorType;

extern NSString* const kUnparsedJSONStringKey;
extern NSString* const kInvalidResponseDataKey;
extern NSString* const kCorruptImageResponseDataKey;
extern NSString* const kOriginalPostParametersDataKey;


@interface NSError(FJNetwork)

+ (NSError*)errorWithErrorResponseDictionary:(NSDictionary*)dict;

+ (NSError*)invalidNetworkResponseErrorWithStatusCode:(int)status URL:(NSURL*)url;

+ (NSError*)invalidNetworkResponseErrorWithStatusCode:(int)status message:(NSString*)message URL:(NSURL*)url;

+ (NSError*)networkRequestTimeOutErrorWithURL:(NSURL*)url;

+ (NSError*)cancelledNetworkRequestWithURL:(NSURL*)url;

+ (NSError*)nilNetworkRespnseErrorWithURL:(NSURL*)url;

+ (NSError*)JSONParseErrorWithData:(NSString*)unparsedString;

+ (NSError*)invalidResponseErrorWithData:(id)invalidData;

+ (NSError*)userNotAuthenticatedInError;

+ (NSError*)invalidCredentialsError;

+ (NSError*)unknownErrorWithDescription:(NSString*)desc;

+ (NSError*)corruptImageResponse:(NSURL*)url data:(NSData*)corruptData;

+ (NSError*)missingRequiredDataError;

+ (NSError*)passwordResetRequiredError;

+ (NSError*)serverErrorWithStatusCode:(int)status message:(NSString*)message URL:(NSURL*)url postParameters:(NSDictionary*)parameters;


@end
