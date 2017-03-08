#include "VLYRootListController.h"
#import <CepheiPrefs/HBSupportController.h>

@implementation VLYRootListController

+ (NSString *)hb_specifierPlist {
    return @"Root";
}

- (void)showSupportEmailController {
	UIViewController *viewController = (UIViewController *)[HBSupportController supportViewControllerForBundle:[NSBundle bundleForClass:self.class] preferencesIdentifier:@"com.dopeteam.tails"];
	[self.navigationController pushViewController:viewController animated:YES];
}

- (void)respring {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.vitality/Respring"), nil, nil, YES);
}

- (NSArray *)themeTitles {
    NSMutableArray* files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:kBundlePath error:nil] mutableCopy];
    for (int i = 0; i < files.count; i++) {
    	NSString *file = [files objectAtIndex:i];
    	file = [file stringByReplacingOccurrencesOfString:@".bundle" withString:@""];
    	[files replaceObjectAtIndex:i withObject:file];
    }

    return files;
}

- (NSArray *)themeValues {
    NSMutableArray* files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:kBundlePath error:nil] mutableCopy];
    return files;
}

@end
