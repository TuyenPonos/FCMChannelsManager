import 'package:fcm_channels_manager/notification_importance.dart';

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final NotificationImportance importance;
  NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
  });

  factory NotificationChannel.fromJson(Map<String, dynamic> json) =>
      NotificationChannel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        importance: (json["importance"] as String).parse,
      );
}
