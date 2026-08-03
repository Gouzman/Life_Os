enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
  archived;

  String get value => name;

  static TaskStatus fromValue(String value) {
    return TaskStatus.values.byName(value);
  }
}
