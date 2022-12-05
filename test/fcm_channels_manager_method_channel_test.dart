import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fcm_channels_manager/fcm_channels_manager_method_channel.dart';

void main() {
  MethodChannelFcmChannelsManager platform = MethodChannelFcmChannelsManager();
  const MethodChannel channel = MethodChannel('fcm_channels_manager');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
