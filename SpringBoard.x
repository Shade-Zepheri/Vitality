#import "FLAnimatedImage.h"
#import "VLYSettings.h"
#import <SpringBoard/SBWallpaperController.h>
#import <SpringBoard/SpringBoard.h>

VLYSettings *settings;

FLAnimatedImageView *imageView;

#pragma mark - Setup

void updateAnimatedWallpaperView() {
    // Create and set animatedImage
    NSData *data = settings.animatedImageData;
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    imageView.animatedImage = image;

    // Hide view if not enabled
    imageView.hidden = !settings.enabled;
}

void (^createAnimatedGifView)(NSNotification *) = ^(NSNotification *nsNotification) {
    // Create imageView
    imageView = [[FLAnimatedImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;

    // Added to wallpaper window
    UIWindow *wallpaperWindow = [[%c(SBWallpaperController) sharedInstance] _window];
    [wallpaperWindow addSubview:imageView];

    // Add the image
    updateAnimatedWallpaperView();

    // Have the view update when setting does
    [settings registerPreferenceChangeBlock:^{
        updateAnimatedWallpaperView();
    }];
};

#pragma mark - Hooks

%hook SpringBoard

- (void)_updateHomeScreenPresenceNotification:(NSNotification *)notification {
    %orig;

    // Stop animaing if not visible
    if (![self isShowingHomescreen]) {
        [imageView stopAnimating];
    } else {
        [imageView startAnimating];
    }
}

%end

#pragma mark - Constructor

%ctor {
    // Create singleton
    settings = [VLYSettings sharedSettings];

    // Add the animated view when SpringBoard loads
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:createAnimatedGifView];
}
