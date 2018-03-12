@interface VLYSettings : NSObject

+ (instancetype)sharedSettings;

@property (readonly, nonatomic) BOOL enabled;
@property (strong, readonly, nonatomic) NSData *animatedImageData;

@end
