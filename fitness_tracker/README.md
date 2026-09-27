# Fitness Tracker (Flutter)

A simple, clean fitness tracking app: log workouts manually, see daily/weekly
progress on a dashboard with progress bars and charts, and browse full
history. Data is stored locally on-device with SQLite (`sqflite`) — no
backend or account needed.

## Features
- **Log activities**: type (running, walking, cycling, gym, yoga, swimming,
  other), date, duration, calories burned, steps, optional notes.
- **Dashboard**: today's steps / calories / active minutes / workout count,
  each with a progress bar against a daily goal, plus 7-day bar charts for
  calories and steps.
- **History**: full list of logged activities, newest first; swipe left to
  delete an entry.
- **Local storage**: SQLite via `sqflite`, so data persists across app
  restarts with no network/account required.

## Project structure
```
lib/
  main.dart                     # App entry point, theme
  models/activity.dart          # Activity model + ActivityType enum + goals
  db/database_helper.dart       # SQLite setup + CRUD queries
  screens/dashboard_screen.dart # Summary/progress screen (home)
  screens/add_activity_screen.dart # Manual log-entry form
  screens/history_screen.dart   # Full activity list with delete
  widgets/stat_card.dart        # Reusable metric + progress bar card
  widgets/weekly_chart.dart     # 7-day bar chart (fl_chart)
```

## Getting started

1. Make sure you have the Flutter SDK installed:
   https://docs.flutter.dev/get-started/install

2. From this project's root folder, fetch dependencies:
   ```
   flutter pub get
   ```

3. Run on a connected device / emulator:
   ```
   flutter run
   ```

No API keys, backend setup, or environment variables are needed — the app
works fully offline out of the box.

## Adjusting daily goals
Default goals (8,000 steps / 500 kcal / 45 active minutes) live in
`DailyGoals` in `lib/models/activity.dart`. Change the defaults there, or
extend the app with a settings screen that lets the user edit them and
persist the choice (e.g. with `shared_preferences`).

## Swapping in a backend later
The app talks to storage only through `DatabaseHelper` in
`lib/db/database_helper.dart`. To move to Firebase (or any other backend),
implement the same methods (`insertActivity`, `getAllActivities`,
`getActivitiesBetween`, etc.) against Firestore/Realtime Database and swap
the implementation — the UI code doesn't need to change.
