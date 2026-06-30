/// Represents the preferred period for scheduling a habit or mission.
enum PreferredPeriod {
  /// Before the user's regular morning block.
  dawn,

  /// Morning block.
  morning,

  /// Afternoon block.
  afternoon,

  /// Evening block.
  evening,

  /// Night block.
  night,

  /// No strong scheduling preference.
  anytime,
}
