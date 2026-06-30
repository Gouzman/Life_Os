/// Describes how often a habit should recur.
enum HabitFrequency {
  /// The habit should be planned every day.
  daily,

  /// The habit should be planned on weekdays.
  weekdays,

  /// The habit should be planned once per week.
  weekly,

  /// The habit should be planned once per month.
  monthly,

  /// The habit follows a custom recurrence rule.
  custom,
}
