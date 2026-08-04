enum TaskStatus {
  pending,
  inProgress,
  paused,
  completed,
  cancelled,
  archived;

  String get value => name;

  static TaskStatus fromValue(String value) {
    return TaskStatus.values.byName(value);
  }
}
