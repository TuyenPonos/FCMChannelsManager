import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fcm_channels_manager_platform_interface.dart';
import 'notification_channel.dart';

/// An implementation of [FcmChannelsManagerPlatform] that uses method channels.
class MethodChannelFcmChannelsManager extends FcmChannelsManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fcm_channels_manager');

  @override
  Future<String?> registerChannel(Map<String, dynamic> params) async {
    final res =
        await methodChannel.invokeMethod<String>('registerChannel', params);
    return res;
  }

  @override
  Future<String?> unregisterChannel(String channelId) async {
    final res = await methodChannel
        .invokeMethod<String>('unregisterChannel', {'id': channelId});
    return res;
  }

  @override
  Future<List<NotificationChannel>> getChannels() async {
    final Map response = await methodChannel.invokeMethod('getChannels');
    final List<NotificationChannel> channels = List.from([]);
    for (var item in response.entries) {
      channels.add(NotificationChannel.fromJson(jsonDecode(item.value)));
    }
    return channels;
  }

  @override
  Future<bool> providesAppNotificationSettings() async {
    final res = await methodChannel
        .invokeMethod<bool>('providesAppNotificationSettings');
    return res ?? false;
  }
}
