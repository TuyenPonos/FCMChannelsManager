import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fcm_channels_manager_method_channel.dart';
import 'notification_channel.dart';

abstract class FcmChannelsManagerPlatform extends PlatformInterface {
  /// Constructs a FcmChannelsManagerPlatform.
  FcmChannelsManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FcmChannelsManagerPlatform _instance =
      MethodChannelFcmChannelsManager();

  /// The default instance of [FcmChannelsManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFcmChannelsManager].
  static FcmChannelsManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FcmChannelsManagerPlatform] when
  /// they register themselves.
  static set instance(FcmChannelsManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> registerChannel(Map<String, dynamic> params) {
    return instance.registerChannel(params);
  }

  Future<String?> unregisterChannel(String channelId) {
    return instance.unregisterChannel(channelId);
  }

  Future<List<NotificationChannel>> getChannels() {
    return instance.getChannels();
  }

  Future<bool> providesAppNotificationSettings() {
    return instance.providesAppNotificationSettings();
  }
}
