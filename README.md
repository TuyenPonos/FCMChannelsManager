
The `fcm_channels_manager` is a flutter package that using to create and manage Notification in Android
## Features

The plugin provide an API for Android:

* Create a new channel
* Get all channels that have been registered
* Delete a channel

Support Android 8.0 (API level 26) and above. For more information, visit [Create and Manage Notification Channels](https://developer.android.com/develop/ui/views/notifications/channels)

## Installation

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  fcm_channels_manager: <latest_version>
```

In your library add the following import:

```dart
import 'package:fcm_channels_manager/fcm_channels_manager.dart';
```

## Usage

### 1. Create new channel

Return success message if channel registered successfully.

```dart
final result =  await FcmChannelsManager().registerChannel(
        id: "1001",
        name: "Feedback notification",
        description: "Receive new feedback and system's notification",
        importance: NotificationImportance.importanceHight,
        visibility: NotificationVisibility.public,
        bubbles: true,
        vibration: true,
        sound: true,
        badge: true,
      );
```

* Notification importance level


| Plugin value                                | Android Reference          |
|:--------------------------------------|:-------------------|
|`NotificationImportance.disabled`       | [IMPORTANCE_NONE](https://developer.android.com/reference/android/app/NotificationManager#IMPORTANCE_NONE)   |
|`NotificationImportance.importanceMin ` | [IMPORTANCE_MIN](https://developer.android.com/reference/android/app/NotificationManager#IMPORTANCE_MIN)   |
|`NotificationImportance.importanceLow` | [IMPORTANCE_LOW](https://developer.android.com/reference/android/app/NotificationManager#IMPORTANCE_LOW) |
|`NotificationImportance.importanceDefault` | [IMPORTANCE_DEFAULT](https://developer.android.com/reference/android/app/NotificationManager#IMPORTANCE_DEFAULT) |
|`NotificationImportance.importanceHight` | [IMPORTANCE_HIGH](https://developer.android.com/reference/android/app/NotificationManager#IMPORTANCE_HIGH) |

* Notification visibility

| Plugin value                                | Description          |
|:--------------------------------------|:-------------------|
|`NotificationVisibility.public`       | Show this notification in its entirety on all lockscreens   |
|`NotificationVisibility.private ` | Show this notification on all lockscreens, but conceal sensitive or private information on secure lockscreens   |
|`NotificationVisibility.secret` | Do not reveal any part of this notification on a secure lockscreen |

### 2. Get all registered channels

You can get all registered channels with base informations about this channel: `id`, `name`, `description`, `importance`. You can check the importance level then handle your businesses.

```dart
final channesl = await FcmChannelsManager().getChannels();
```

### 3. Delete a channel

Remove registered channel by channel's id. Return success message if channel deleted

```dart
final result = await FcmChannelsManager().unregisterChannel('1001')
```

## Example

Follow the example: `/example`

Demo:

![/example/demo_channels.gif](https://github.com/TuyenPonos/FCMChannelsManager/blob/main/example/demo_channels.gif)


## Contributions 

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an issue.
If you fixed a bug or implemented a feature, please send a pull request.