import Flutter
import UIKit
import UserNotifications

public class SwiftFcmChannelsManagerPlugin: NSObject, FlutterPlugin {
    var permissionGranted: String = "granted"
    var permissionUnknown: String = "unknown"
    var permissionDenied: String = "denied"
    var permissionProvisional: String = "provisional"

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fcm_channels_manager", binaryMessenger: registrar.messenger())
        let instance = SwiftFcmChannelsManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "requestNotificationPermission" {
            getNotificationStatus(completion: {
                status in
                if status == self.permissionUnknown || status == self.permissionProvisional {
                    if #available(iOS 10.0, *) {
                        let center = UNUserNotificationCenter.current()
                        var options = UNAuthorizationOptions()
                        if let arguments = call.arguments as? Dictionary<String, Bool> {
                            if arguments["sound"] != nil && arguments["sound"] == true {
                                options.insert(.sound)
                            }
                            if arguments["alert"] != nil && arguments["alert"] == true {
                                options.insert(.alert)
                            }
                            if arguments["badge"] != nil && arguments["badge"] == true {
                                options.insert(.badge)
                            }
                            if arguments["provisional"] != nil && arguments["provisional"] == true {
                                if #available(iOS 12.0, *) {
                                    options.insert(.provisional)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            if arguments["carPlay"] != nil && arguments["carPlay"] == true {
                                options.insert(.carPlay)
                            }
                            if arguments["criticalAlert"] != nil && arguments["criticalAlert"] == true {
                                if #available(iOS 12.0, *) {
                                    options.insert(.criticalAlert)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            if arguments["providesAppNotificationSettings"] != nil && arguments["providesAppNotificationSettings"] == true {
                                if #available(iOS 12.0, *) {
                                    options.insert(.providesAppNotificationSettings)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                        }
                        center.requestAuthorization(options: options) { success, error in
                            if error == nil {
                                if success == true {
                                    result(self.permissionGranted)
                                } else {
                                    result(self.permissionDenied)
                                }
                            } else {
                                result(error?.localizedDescription)
                            }
                        }
                    } else {
                        var notificationTypes = UIUserNotificationType(rawValue: 0)
                        if let arguments = call.arguments as? Dictionary<String, Bool> {
                            if arguments["sound"] != nil {
                                notificationTypes.insert(UIUserNotificationType.sound)
                            }
                            if arguments["alert"] != nil {
                                notificationTypes.insert(UIUserNotificationType.alert)
                            }
                            if arguments["badge"] != nil {
                                notificationTypes.insert(UIUserNotificationType.badge)
                            }
                            var settings: UIUserNotificationSettings?

                            settings = UIUserNotificationSettings(types: notificationTypes, categories: nil)

                            if let settings = settings {
                                UIApplication.shared.registerUserNotificationSettings(settings)
                            }
                            self.getNotificationStatus(completion: { status in
                                result(status)
                            })
                        }
                    }
                } else if status == self.permissionDenied {
                    // The user has denied the permission they must go to the settings screen
                    if let arguments = call.arguments as? Dictionary<String, Bool> {
                        if arguments["openSettings"] != nil && arguments["openSettings"] == false {
                            result(self.permissionDenied)
                            return
                        }
                    }
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }
                    result(nil)
                } else {
                    result(status)
                }
            })
        } else if call.method == "getNotificationPermissionStatus" {
            getNotificationStatus(completion: { status in
                result(status)
            })
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    func getNotificationStatus(completion: @escaping ((String) -> Void)) {
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { settings in
                if settings.authorizationStatus == .notDetermined {
                    completion(self.permissionUnknown)
                } else if settings.authorizationStatus == .denied {
                    completion(self.permissionDenied)
                } else if settings.authorizationStatus == .authorized {
                    completion(self.permissionGranted)
                } else if #available(iOS 12.0, *) {
                    if settings.authorizationStatus == .provisional {
                        completion(self.permissionProvisional)
                    }
                }
            })
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                completion(permissionGranted)
            } else {
                completion(permissionDenied)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value) })
}
