#import "DataOverSoundPlugin.h"
#if __has_include(<data_over_sound/data_over_sound-Swift.h>)
#import <data_over_sound/data_over_sound-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "data_over_sound-Swift.h"
#endif

@implementation DataOverSoundPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDataOverSoundPlugin registerWithRegistrar:registrar];
}
@end
