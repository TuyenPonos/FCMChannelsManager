import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fcm_channels_manager/fcm_channels_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _fcmChannelsManagerPlugin = FcmChannelsManager();
  List<NotificationChannel> _channels = List.from([]);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initChannels();
    });
    if (Platform.isIOS) {
      _fcmChannelsManagerPlugin
          .requestNotificationPermission(
            providesAppNotificationSettings: true,
          )
          .then((value) => log('Permission status: $value'));
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getChannels();
    }
  }

  Future<void> _getChannels() async {
    _channels = await _fcmChannelsManagerPlugin.getChannels();
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initChannels() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    final List<Map<String, dynamic>> _mockData = [
      {
        'id': '1001',
        'name': 'Social notification',
        'description': 'Social notification',
        'importance': NotificationImportance.importanceHight,
      },
      {
        'id': '1002',
        'name': 'Message notification',
        'description': 'Message notification',
        'importance': NotificationImportance.importanceDefault,
      },
      {
        'id': '1003',
        'name': 'System notification',
        'description': 'Admin notification',
        'importance': NotificationImportance.importanceLow,
      },
      {
        'id': '1004',
        'name': 'Report notification',
        'description': 'User report notification',
        'importance': NotificationImportance.importanceMin,
      }
    ];
    for (var channel in _mockData) {
      await _fcmChannelsManagerPlugin.registerChannel(
        id: channel['id'],
        name: channel['name'],
        description: channel['description'],
        importance: channel['importance'],
      );
    }
    _getChannels();
  }

  Future<void> unRegisterFirst() async {
    await _fcmChannelsManagerPlugin.unregisterChannel('1001');
    _getChannels();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ListView.builder(
              itemBuilder: (_, index) {
                final channel = _channels[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            channel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(channel.importance.toString()),
                        ],
                      ),
                    ),
                    Switch(
                      value:
                          channel.importance != NotificationImportance.disabled,
                      onChanged: (_) {},
                    )
                  ],
                );
              },
              shrinkWrap: true,
              itemCount: _channels.length,
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                unRegisterFirst();
              },
              child: const Text('Unregister channel 1001'),
            ),
          ],
        ),
      ),
    );
  }
}
