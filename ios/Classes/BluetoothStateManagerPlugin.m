#import "BluetoothStateManagerPlugin.h"
#if __has_include(<bluetooth_state_manager/bluetooth_state_manager-Swift.h>)
#import <bluetooth_state_manager/bluetooth_state_manager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bluetooth_state_manager-Swift.h"
#endif

@implementation BluetoothStateManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBluetoothStateManagerPlugin registerWithRegistrar:registrar];
}
@end
