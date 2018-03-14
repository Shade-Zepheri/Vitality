#import <Cephei/HBPreferences.h>

@interface VLYSettings : NSObject

+ (instancetype)sharedSettings;

@property (readonly, nonatomic) BOOL enabled;
@property (strong, readonly, nonatomic) NSData *animatedImageData;

- (void)registerPreferenceChangeBlock:(HBPreferencesChangeCallback)callback;

@end
