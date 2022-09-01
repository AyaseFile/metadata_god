#import "MetadataGodPlugin.h"
#if __has_include(<metadata_god/metadata_god-Swift.h>)
#import <metadata_god/metadata_god-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "metadata_god-Swift.h"
#endif

@implementation MetadataGodPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  ((void*)dummy_method_to_enforce_bundling);
  [SwiftMetadataGodPlugin registerWithRegistrar:registrar];
}
@end
