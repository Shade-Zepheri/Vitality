#import "VLYSettings.h"

// Settings keys
static NSString *const VLYPreferencesEnabledKey = @"enabled";
static NSString *const VLYPreferencesCurrentBundleNameKey = @"currentWallpaper";

@implementation VLYSettings {
    HBPreferences *_preferences;

    NSString *_currentBundle;
}

+ (instancetype)sharedSettings {
    static VLYSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
    });

    return sharedSettings;
}

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create prefs
        _preferences = [HBPreferences preferencesForIdentifier:@"com.shade.vitality"];

        // Register defaults
        [_preferences registerBool:&_enabled default:YES forKey:VLYPreferencesEnabledKey];
        [_preferences registerObject:&_currentBundle default:@"Vitality-Default.bundle" forKey:VLYPreferencesCurrentBundleNameKey];

        // Observe when change
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(preferencesWereUpdated) name:HBPreferencesDidChangeNotification object:nil];
        [self preferencesWereUpdated];
    }

    return self;
}

#pragma mark - Callbacks

- (void)preferencesWereUpdated {
    //Get new data
    NSURL *bundlesURL = [NSURL fileURLWithPath:@"/var/mobile/Library/Vitality/"];
    NSBundle *themeBundle = [NSBundle bundleWithURL:[bundlesURL URLByAppendingPathComponent:_currentBundle]];

    NSURL *wallpaperURL = [themeBundle URLForResource:@"wallpaper" withExtension:@"gif"];
    _animatedImageData = [NSData dataWithContentsOfURL:wallpaperURL];
}

- (void)registerPreferenceChangeBlock:(HBPreferencesChangeCallback)callback {
    [_preferences registerPreferenceChangeBlock:callback];
}

@end
