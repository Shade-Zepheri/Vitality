#import "VLYPreviewGifController.h"

@implementation VLYPreviewGifController
- (NSArray *)specifiers {
    return nil;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSString *themeBundleName = !CFPreferencesCopyAppValue(CFSTR("currentWallpaper"), CFSTR("com.shade.vitality")) ? @"Vitality-Default.bundle" : (__bridge id)CFPreferencesCopyAppValue(CFSTR("currentWallpaper"), CFSTR("com.shade.vitality"));

  	NSURL *bundleURL = [[NSURL alloc] initFileURLWithPath:@"/Library/Application Support/Vitality/Wallpapers/"];
  	NSBundle *themeAssets = [[NSBundle alloc] initWithURL:[bundleURL URLByAppendingPathComponent:themeBundleName]];

  	NSURL *pathURL;
  	if ([[NSFileManager defaultManager] fileExistsAtPath:[themeAssets pathForResource:@"wallpaper" ofType:@"gif"]]) {
  		pathURL = [NSURL fileURLWithPath:[themeAssets pathForResource:@"wallpaper" ofType:@"gif"]];
  	} else {
  		pathURL = [NSURL fileURLWithPath:@"/Library/Application Support/Vitality/Wallpapers/Vitality-Default.bundle/wallpaper.gif"];
  	}
    NSData *data = [NSData dataWithContentsOfURL:pathURL];

    _imageView = [[FLAnimatedImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;

    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    _imageView.animatedImage = image;
  }

  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.tableHeaderView = _imageView;
}

@end
