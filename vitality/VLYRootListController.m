#import "VLYRootListController.h"
#import "VLYPreviewGifController.h"
#import <CepheiPrefs/HBSupportController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@implementation VLYRootListController

#pragma mark - HBListController

+ (NSString *)hb_specifierPlist {
    return @"Root";
}

- (instancetype)init {
    self = [super init];
    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:0.47 green:0.10 blue:0.00 alpha:1.0];
        appearanceSettings.navigationBarTitleColor = [UIColor whiteColor];
        appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed:0.00 green:0.47 blue:0.42 alpha:1.0];
        appearanceSettings.translucentNavigationBar = NO;
        self.hb_appearanceSettings = appearanceSettings;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *previewButton = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(previewGif)];
    self.navigationItem.rightBarButtonItem = previewButton;
}

#pragma mark - Support

- (void)showSupportEmailController {
    UIViewController *viewController = (UIViewController *)[HBSupportController supportViewControllerForBundle:[NSBundle bundleForClass:self.class] preferencesIdentifier:@"com.dopeteam.tails"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)respring {
    // TODO: get rid need to respring
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.vitality/Respring"), nil, nil, YES);
}

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

#pragma mark - Bar buton

- (void)previewGif {
    [self pushController:[[VLYPreviewGifController alloc] init]];
}

@end
