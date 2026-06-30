/// Represents the execution state of a generated mission.
enum MissionStatus {
  /// The mission is planned but not started.
  scheduled,

  /// The user is currently working on the mission.
  inProgress,

  /// The mission has been completed successfully.
  completed,

  /// The user skipped the mission.
  skipped,

  /// The mission was cancelled and should not count for the day.
  cancelled,
}
