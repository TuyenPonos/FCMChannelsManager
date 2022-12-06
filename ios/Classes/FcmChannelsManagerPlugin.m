#import "FcmChannelsManagerPlugin.h"
#if __has_include(<fcm_channels_manager/fcm_channels_manager-Swift.h>)
#import <fcm_channels_manager/fcm_channels_manager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fcm_channels_manager-Swift.h"
#endif

@implementation FcmChannelsManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFcmChannelsManagerPlugin registerWithRegistrar:registrar];
}
@end
