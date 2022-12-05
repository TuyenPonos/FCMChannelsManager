enum NotificationImportance {
  disabled,
  importanceMin,
  importanceLow,
  importanceDefault,
  importanceHight,
}

extension NotificationImportanceExt on NotificationImportance {
  int get toValue {
    if (this == NotificationImportance.importanceMin) {
      return 1;
    }
    if (this == NotificationImportance.importanceLow) {
      return 2;
    }
    if (this == NotificationImportance.importanceDefault) {
      return 3;
    }
    if (this == NotificationImportance.importanceHight) {
      return 4;
    }
    return 0;
  }
}

extension NotificationImportanceParseExt on String {
  NotificationImportance get parse {
    if (this == '1') {
      return NotificationImportance.importanceMin;
    }
    if (this == '2') {
      return NotificationImportance.importanceLow;
    }
    if (this == '3') {
      return NotificationImportance.importanceDefault;
    }
    if (this == '4') {
      return NotificationImportance.importanceHight;
    }
    return NotificationImportance.disabled;
  }
}
