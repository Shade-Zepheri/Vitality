#import "VLYSettings.h"

@implementation VLYSettings

+ (instancetype)sharedSettings {
	static VLYSettings *sharedSettings;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedSettings = [[self alloc] init];
	});

	return sharedSettings;
}

- (instancetype)init {
	if (self = [super init]) {
		[self reloadSettings];
	}

	return self;
}

- (void)reloadSettings {
	CFPreferencesAppSynchronize(CFSTR("com.shade.vitality"));
	_enabled = !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.shade.vitality")) ? YES : [(__bridge id)CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.shade.vitality")) boolValue];
	NSString *themeBundleName = !CFPreferencesCopyAppValue(CFSTR("currentWallpaper"), CFSTR("com.shade.vitality")) ? @"Vitality-Default.bundle" : (__bridge id)CFPreferencesCopyAppValue(CFSTR("currentWallpaper"), CFSTR("com.shade.vitality"));

	NSURL *bundleURL = [[NSURL alloc] initFileURLWithPath:@"/Library/Application Support/Vitality/Wallpapers/"];
	NSBundle *themeAssets = [[NSBundle alloc] initWithURL:[bundleURL URLByAppendingPathComponent:themeBundleName]];

	NSURL *pathURL;
	if ([[NSFileManager defaultManager] fileExistsAtPath:[themeAssets pathForResource:@"wallpaper" ofType:@"gif"]]) {
		pathURL = [NSURL fileURLWithPath:[themeAssets pathForResource:@"wallpaper" ofType:@"gif"]];
	} else {
		pathURL = [NSURL fileURLWithPath:@"/Library/Application Support/Vitality/Wallpapers/Vitality-Default.bundle/wallpaper.gif"];
	}

	_animatedImageData = [NSData dataWithContentsOfURL:pathURL];
}

@end
