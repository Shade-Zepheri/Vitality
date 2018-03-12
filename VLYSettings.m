#import "VLYSettings.h"
#import <Cephei/HBPreferences.h>

// Pref keys
static NSString *const VLYPreferencesEnabledKey = @"enabled";
static NSString *const VLYPreferencesCurrentBundleNameKey = @"currentWallpaper";

@implementation VLYSettings {
    HBPreferences *_preferences;

    NSString *_bundleName;
}

+ (instancetype)sharedSettings {
    static VLYSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
    });

    return sharedSettings;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create prefs
        _preferences = [HBPreferences preferencesForIdentifier:@"com.shade.vitality"];

        // Register defaults
        [_preferences registerBool:&_enabled default:YES forKey:VLYPreferencesEnabledKey];
        [_preferences registerObject:&_bundleName default:@"Vitality-Default.bundle" forKey:VLYPreferencesCurrentBundleNameKey];

        // Observe when change
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(preferencesUpdated) name:HBPreferencesDidChangeNotification object:nil];
    }

    return self;
}

#pragma mark - Callback

- (void)preferencesUpdated {
    //Get new data
    NSURL *bundlesURL = [NSURL fileURLWithPath:@"/Library/Application Support/Vitality/Wallpapers/"];
    NSBundle *themeBundle = [NSBundle bundleWithURL:[bundlesURL URLByAppendingPathComponent:_bundleName]];

    NSURL *pathURL = [NSURL fileURLWithPath:[themeBundle pathForResource:@"wallpaper" ofType:@"gif"]];
    _animatedImageData = [NSData dataWithContentsOfURL:pathURL];
}

@end
