#import "FLAnimatedImage.h"
#import "VLYSettings.h"
#import <FrontBoardServices/FBSSystemService.h>
#import <SpringBoard/SpringBoard.h>
#import <SpringBoardFoundation/SBFStaticWallpaperView.h>
#import <SpringBoardServices/SBSRelaunchAction.h>
#import <version.h>

VLYSettings *settings;

FLAnimatedImageView *imageView;
BOOL addedImage = NO;

#pragma mark - Hooks

%hook SBFStaticWallpaperView

- (void)layoutSubviews {
    %orig;

    if (settings.enabled && !addedImage) {
        imageView = [[FLAnimatedImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;

        NSData *data = settings.animatedImageData;
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
        imageView.animatedImage = image;
        [self addSubview:imageView];
        addedImage = YES;
    }
}

%end

%hook SpringBoard

- (BOOL)isShowingHomescreen {
    BOOL showing = %orig;
    if (!showing) {
        [imageView stopAnimating];
    } else {
        [imageView startAnimating];
    }

    return showing;
}

%end

#pragma mark - Listener

static void respring_notification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if (IS_IOS_OR_NEWER(iOS_9_3)) {
        SBSRelaunchAction *restartAction = [%c(SBSRelaunchAction) actionWithReason:@"RestartRenderServer" options:SBSRelaunchActionOptionsFadeToBlack targetURL:nil];
        [[%c(FBSSystemService) sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
    } else {
        [(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
    }
}

#pragma mark - Constructor

%ctor {
    // Create singletons
    settings = [VLYSettings sharedSettings];

    // Register for respring notification
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &respring_notification, CFSTR("com.shade.vitality/Respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    %init;
}
