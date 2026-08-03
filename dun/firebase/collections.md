# Firebase Collections

## users

```json
{
  "uid": "string",
  "email": "string",
  "displayName": "string | null",
  "photoUrl": "string | null",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## tasks

```json
{
  "id": "string",
  "userId": "string",
  "title": "string",
  "description": "string | null",
  "scheduledAt": "timestamp",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "startedAt": "timestamp | null",
  "completedAt": "timestamp | null",
  "expectedDuration": "number (minutes)",
  "actualDuration": "number (minutes) | null",
  "postponeCount": "number",
  "status": "pending | inProgress | completed | cancelled"
}
```

## settings

```json
{
  "userId": "string",
  "themeMode": "system | light | dark",
  "notificationsEnabled": "boolean",
  "soundEnabled": "boolean",
  "focusDuration": "number (minutes)",
  "breakDuration": "number (minutes)"
}
```

## statistics

```json
{
  "userId": "string",
  "totalTasks": "number",
  "completedTasks": "number",
  "totalFocusTime": "number (minutes)",
  "currentStreak": "number",
  "longestStreak": "number",
  "updatedAt": "timestamp"
}
```
