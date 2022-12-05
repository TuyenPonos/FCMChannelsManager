enum NotificationVisibility {
  /// Notification visibility: Show this notification in its entirety on all lockscreens.
  public,
  // Notification visibility: Show this notification on all lockscreens, but conceal sensitive or
  // private information on secure lockscreens
  private,
  // Notification visibility: Do not reveal any part of this notification on a secure lockscreen.
  secret,
}

extension NotificationVisibilityExt on NotificationVisibility {
  int get toValue {
    if (this == NotificationVisibility.private) {
      return 0;
    }
    if (this == NotificationVisibility.public) {
      return 1;
    }
    return -1;
  }
}
