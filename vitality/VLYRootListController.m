#include "VLYRootListController.h"
#import <CepheiPrefs/HBSupportController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import "VLYPreviewGifController.h"

@implementation VLYRootListController

+ (NSString *)hb_specifierPlist {
  return @"Root";
}

- (instancetype)init {
  self = [super init];
  if (self) {
    HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
    appearanceSettings.tintColor = [UIColor colorWithRed:0.07 green:0.42 blue:0.46 alpha:1.0];
    appearanceSettings.invertedNavigationBar = YES;
    self.hb_appearanceSettings = appearanceSettings;
  }

  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  UIBarButtonItem *previewButton = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(previewGif)];
  [(UINavigationItem*)self.navigationItem setRightBarButtonItem:previewButton animated:NO];
}

- (void)showSupportEmailController {
	UIViewController *viewController = (UIViewController *)[HBSupportController supportViewControllerForBundle:[NSBundle bundleForClass:self.class] preferencesIdentifier:@"com.dopeteam.tails"];
	[self.navigationController pushViewController:viewController animated:YES];
}

- (void)respring {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.vitality/Respring"), nil, nil, YES);
}

- (NSArray *)bundleTitles {
  NSMutableArray* files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:kBundlePath error:nil] mutableCopy];
  for (int i = 0; i < files.count; i++) {
  	NSString *file = [files objectAtIndex:i];
  	file = [file stringByReplacingOccurrencesOfString:@".bundle" withString:@""];
  	[files replaceObjectAtIndex:i withObject:file];
  }

  return files;
}

- (NSArray *)bundleValues {
  NSMutableArray* files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:kBundlePath error:nil] mutableCopy];
  return files;
}

- (void)previewGif {
  [self pushController:[[VLYPreviewGifController alloc] init]];
}

@end
