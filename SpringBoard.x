#import "FLAnimatedImage.h"
#import "VLYSettings.h"
#import <SpringBoard/SBWallpaperController.h>

VLYSettings *settings;

FLAnimatedImageView *imageView;

#pragma mark - Setup

void updateAnimatedWallpaperView() {
    // Update image
    NSData *data = settings.animatedImageData;
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    imageView.animatedImage = image;

    imageView.hidden = !settings.enabled;
}

void (^createAnimatedGifView)(NSNotification *) = ^(NSNotification *nsNotification) {
    imageView = [[FLAnimatedImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;

    UIWindow *wallpaperWindow = [[%c(SBWallpaperController) sharedInstance] _window];
    [wallpaperWindow addSubview:imageView];

    updateAnimatedWallpaperView();

    [settings registerPreferenceChangeBlock:^{
        updateAnimatedWallpaperView();
    }];
};

#pragma mark - Constructor

%ctor {
    // Create singleton
    settings = [VLYSettings sharedSettings];

    // Add the animated view when SpringBoard loads
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:createAnimatedGifView];
}
