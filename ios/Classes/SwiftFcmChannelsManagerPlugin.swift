import Flutter
import UIKit
import UserNotifications

public class SwiftFcmChannelsManagerPlugin: NSObject, FlutterPlugin {
 

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fcm_channels_manager", binaryMessenger: registrar.messenger())
        let instance = SwiftFcmChannelsManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "providesAppNotificationSettings"){
            if #available(iOS 12.0, *) {
                let center = UNUserNotificationCenter.current()
                var options = UNAuthorizationOptions()
                options.insert(.providesAppNotificationSettings)
                center.requestAuthorization(options: options) { _, error in
                    result(error != nil)
                
                }
            }
        }
 
    }
}
