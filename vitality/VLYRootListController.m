#import "VLYRootListController.h"
#import <CepheiPrefs/HBSupportController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@implementation VLYRootListController

#pragma mark - HBListController

+ (NSString *)hb_specifierPlist {
    return @"Root";
}

#pragma mark - View management

- (void)viewDidLoad  {
    [super viewDidLoad];

    HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
    appearanceSettings.tintColor = [UIColor colorWithRed:0.98 green:0.66 blue:0.15 alpha:1.0];
    appearanceSettings.navigationBarTitleColor = [UIColor whiteColor];
    appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed:0.00 green:0.54 blue:0.48 alpha:1.0];
    appearanceSettings.statusBarTintColor = [UIColor whiteColor];
    appearanceSettings.translucentNavigationBar = NO;
    self.hb_appearanceSettings = appearanceSettings;
}

#pragma mark - Supporting methods

- (NSArray *)bundleTitles {
    NSArray *installedBundles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:VLYBundlesPath error:nil];
    NSMutableArray *bundleTitles = [NSMutableArray array];

    for (NSString *bundle in installedBundles) {;
        [bundleTitles addObject:[bundle stringByDeletingPathExtension]];
    }

    return bundleTitles;
}

- (NSArray *)bundleValues {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:VLYBundlesPath error:nil];
}

@end
