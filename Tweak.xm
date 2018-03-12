#import "FLAnimatedImage.h"
#import "headers.h"
#import "VLYSettings.h"

FLAnimatedImageView *imageView;
BOOL addedImage = NO;

%hook SBFStaticWallpaperView
- (void)layoutSubviews {
  %orig;

  if ([VLYSettings sharedSettings].enabled && !addedImage) {
    imageView = [[FLAnimatedImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;

    NSData *data = [VLYSettings sharedSettings].animatedImageData;
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

void reloadSettings() {
    [[VLYSettings sharedSettings] reloadSettings];
}

void respring_notification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
		if (IS_IOS_OR_NEWER(iOS_9_3)) {
				SBSRelaunchAction *restartAction = [%c(SBSRelaunchAction) actionWithReason:@"RestartRenderServer" options:SBSRelaunchOptionsFadeToBlack targetURL:nil];
				[[%c(FBSSystemService) sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
		} else {
				[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
		}
}

%ctor {
    if (IN_SPRINGBOARD) {
      CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &respring_notification, CFSTR("com.shade.vitality/Respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.shade.vitality/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
