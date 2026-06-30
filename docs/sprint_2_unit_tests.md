# Sprint 2 - Unit Tests To Write

## LifeArea

- Creates a valid life area with Dart-only fields.
- Rejects a negative order.
- Keeps `iconKey` and `colorHex` as primitive presentation tokens.
- Supports archived and active states through the `archived` flag.

## Goal

- Creates a valid goal linked to a life area.
- Rejects priority below 1.
- Rejects priority above 10.
- Keeps `targetDate` as a domain date without UI dependency.

## Habit

- Creates a valid recurring habit.
- Rejects a negative duration.
- Rejects a negative XP reward.
- Keeps frequency and preferred period as domain value objects.

## Routine

- Creates a valid ordered list of habit references.
- Preserves the order of `habitIds`.
- Exposes `habitIds` as an unmodifiable list.
- Allows an empty list only if the product accepts draft routines.

## MissionTemplate

- Creates a reusable mission without scheduled time.
- Rejects a negative duration.
- Rejects a negative XP reward.
- Rejects importance outside 1 to 10.
- Rejects urgency outside 1 to 10.
- Keeps energy level and preferred period as domain value objects.

## MissionInstance

- Creates a generated mission linked to a template.
- Defaults to `MissionStatus.scheduled`.
- Accepts `completedAt` only as nullable completion metadata.
- Rejects an end date before the start date.

## DailyPlan

- Creates an ordered daily plan from mission instances.
- Preserves mission instance order.
- Exposes mission instances as an unmodifiable list.
- Rejects negative remaining free time.
- Rejects a day score below 0 or above 100.
