#import "CoucouFlutterPlugin.h"
#import <coucou_flutter/coucou_flutter-Swift.h>

@implementation CoucouFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCoucouFlutterPlugin registerWithRegistrar:registrar];
}
@end
