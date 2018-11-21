#import "AwareframeworkRotationPlugin.h"
#import <awareframework_rotation/awareframework_rotation-Swift.h>

@implementation AwareframeworkRotationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkRotationPlugin registerWithRegistrar:registrar];
}
@end
