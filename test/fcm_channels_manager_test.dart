import 'package:fcm_channels_manager/notification_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fcm_channels_manager/fcm_channels_manager_platform_interface.dart';
import 'package:fcm_channels_manager/fcm_channels_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFcmChannelsManagerPlatform
    with MockPlatformInterfaceMixin
    implements FcmChannelsManagerPlatform {
  @override
  Future<String?> registerChannel(Map<String, dynamic> params) {
    throw UnimplementedError();
  }

  @override
  Future<String?> unregisterChannel(Pattern channelId) {
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationChannel>> getChannels() {
    throw UnimplementedError();
  }
}

void main() {
  final FcmChannelsManagerPlatform initialPlatform =
      FcmChannelsManagerPlatform.instance;

  test('$MethodChannelFcmChannelsManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFcmChannelsManager>());
  });
}
