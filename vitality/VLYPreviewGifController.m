#import "VLYPreviewGifController.h"
#import "VLYSettings.h"

@implementation VLYPreviewGifController {
    VLYSettings *_settings;
}

- (NSArray *)specifiers {
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _settings = [VLYSettings sharedSettings];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSData *data = _settings.animatedImageData;

    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;

    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    imageView.animatedImage = image;

    self.table.tableHeaderView = imageView;
}

@end
