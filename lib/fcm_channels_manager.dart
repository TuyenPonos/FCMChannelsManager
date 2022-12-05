// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'fcm_channels_manager_platform_interface.dart';
import 'notification_channel.dart';
import 'notification_importance.dart';
import 'notification_visibility.dart';

export 'notification_channel.dart';
export 'notification_importance.dart';
export 'notification_visibility.dart';

class FcmChannelsManager {
  /// [id] The id of the channel. Must be unique per package.
  /// [name] The user visible name of the channel.
  /// The recommended maximum length is 40 characters;
  /// [description] Sets the user visible description of this channel.
  /// The recommended maximum length is 300 characters;
  /// the value may be truncated if it is too long
  /// [importance] The importance of the channel.
  /// This controls how interruptive notifications posted to this channel are
  /// it is one of the constants from NotificationImportance class
  /// [visibility]Sets whether notifications posted to this channel appear on the lockscreen or not, and if so,
  /// whether they appear in a redacted form. See e.g.
  /// Only modifiable by the system and notification ranker
  /// [bubble] IMPORTANT! Will take effect only on sdk version 29+
  /// and will be silently ignored on any prior versions
  /// Sets whether notifications posted to this
  /// channel can appear outside of the notification
  /// shade, floating over other apps' content as a bubble.
  /// <p>This value will be ignored for channels that aren't allowed to pop on screen (that is,
  /// channels whose {@link #getImportance() importance} is <
  /// {@link NotificationManager#IMPORTANCE_HIGH}.</p>
  /// <p>Only modifiable before the channel is submitted to
  /// {@link NotificationManager#createNotificationChannel(NotificationChannel)}.</p>
  /// @see Notification#getBubbleMetadata()
  /// [vibration] Sets whether notification posted to
  /// this channel should vibrate
  /// [sound] whether this notification should play a sound
  /// if you pass "sound": "default" when sending a notification
  /// [badge] Sets whether notifications posted to this channel
  /// can appear as application icon badges in a Launcher
  Future<String?> registerChannel({
    required String id,
    required String name,
    required String description,
    NotificationImportance importance = NotificationImportance.importanceHight,
    NotificationVisibility visibility = NotificationVisibility.public,
    bool bubbles = true,
    bool vibration = true,
    bool sound = true,
    bool badge = true,
  }) {
    final _visibility = visibility.toValue;
    final _importance = importance.toValue;
    assert(_visibility >= -1 && _visibility <= 1);
    assert(_importance >= 0 && _importance <= 4);
    var params = {
      'id': id,
      'name': name,
      'description': description,
      'importance': _importance,
      'visibility': _visibility,
      'vibration': vibration,
      'bubbles': bubbles,
      'sound': sound,
      'badge': badge,
    };
    return FcmChannelsManagerPlatform.instance.registerChannel(params);
  }

  Future<String?> unregisterChannel(String channelId) {
    return FcmChannelsManagerPlatform.instance.unregisterChannel(channelId);
  }

  Future<List<NotificationChannel>> getChannels() {
    return FcmChannelsManagerPlatform.instance.getChannels();
  }
}
