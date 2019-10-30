#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

@interface VLYSettings : NSObject
@property (class, strong, readonly) VLYSettings *sharedSettings;

@property (readonly, nonatomic) BOOL enabled;
@property (strong, readonly, nonatomic) NSData *animatedImageData;

- (void)registerPreferenceChangeBlock:(HBPreferencesChangeCallback)callback;

@end
