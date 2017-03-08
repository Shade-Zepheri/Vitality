@interface VLYSettings : NSObject {
	NSDictionary *_settings;
}
@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, readonly) NSData *animatedImageData;

+ (instancetype)sharedSettings;
- (void)reloadSettings;
@end
