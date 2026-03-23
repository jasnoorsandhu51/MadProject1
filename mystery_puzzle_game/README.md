# Mystery Detective Puzzle Game

A Flutter-based mystery detective puzzle game where players solve crimes by finding evidence under time pressure. Identify the culprit across three levels, then see your name on the leaderboard.

## Features

- **3 Progressive Levels** — find the correct evidence object in each scene within 60 seconds
- **Countdown Timer** — 60 seconds per level; wrong selections deduct 10 seconds
- **Penalty System** — incorrect taps penalise time and reduce your final score
- **Score Calculation** — `timeRemaining × 10 − wrongClicks × 50`
- **Story-Driven Narrative** — immersive dialogue scenes between levels
- **Game Complete Screen** — two-column layout with the convict profile on the left and a stats + leaderboard panel on the right
- **Leaderboard** — top 5 runs persisted locally via `shared_preferences`; player name collected once per run via a name-entry dialog
- **Cross-Platform** — Android, iOS, Web, macOS, Linux, Windows

## Prerequisites

| Requirement | Version |
|---|---|
| Flutter SDK | ≥ 3.10.8 |
| Dart SDK | included with Flutter |

A device or emulator is optional — the game runs in a web browser or as a desktop app without one.

## Project Structure

```
lib/
├── main.dart
├── database/
│   └── database_helper.dart   # RunRecord model, DatabaseHelper, PreferencesService
├── models/
│   ├── dialogue.dart
│   ├── game_state.dart
│   ├── level.dart
│   ├── level_config.dart
│   └── dialogue.dart
├── screens/
│   ├── home_screen.dart
│   ├── intro_background_screen.dart
│   ├── level_screen.dart
│   ├── dialogue_screen.dart
│   ├── level_complete_screen.dart
│   ├── game_complete_screen.dart  ← two-column layout, leaderboard
│   └── time_up_screen.dart
└── widgets/
    ├── clue_progress_bar.dart
    └── dialogue_overlay.dart

assets/
└── images/    # maid.png and scene assets
```

## Getting Started

```bash
# 1. Install dependencies
cd mystery_puzzle_game
flutter pub get

# 2. Run (picks the best available device automatically)
flutter run

# Or target a specific platform:
flutter run -d chrome    # Web
flutter run -d macos     # macOS desktop
flutter run -d ios       # iOS Simulator (macOS only)
flutter run -d android   # Android emulator / device
flutter run -d windows   # Windows desktop
flutter run -d linux     # Linux desktop
```

See [USER_GUIDE.md](USER_GUIDE.md) for a full walkthrough of gameplay and all screens.

## Running Tests

```bash
flutter test
```

## Technology Stack

| Layer | Choice |
|---|---|
| Framework | Flutter 3.10.8+ |
| Language | Dart |
| State management | `StatefulWidget` |
| Persistence | `shared_preferences` |
| UI | Material Design with custom dark theme |

## License

This project is private and not published to pub.dev.
