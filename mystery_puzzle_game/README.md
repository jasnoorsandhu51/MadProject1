# Mystery Detective Puzzle Game

A Flutter-based mystery detective puzzle game where players solve crimes by finding evidence under time pressure.

## Game Overview

This is an interactive detective-themed puzzle game where players have 60 seconds per level to identify and collect the correct evidence object. The game features a multi-level progression system with increasing difficulty and a hint mechanism to aid players who struggle.

## Features

- **3 Progressive Levels**: Each level requires finding a different evidence object
- **Countdown Timer**: 60 seconds per level to complete the puzzle
- **Penalty System**: Wrong selections deduct 10 seconds from the timer
- **Hint System**: After 3 wrong attempts, a helpful hint is displayed
- **Score Tracking**: Tracks wrong attempts for feedback
- **Story-Driven**: Immersive detective narrative with dialogue and instructions
- **Cross-Platform**: Runs on Android, iOS, Web, macOS, Linux, and Windows

## Prerequisites

- **Flutter SDK**: Version 3.10.8 or higher
- **Dart SDK**: Included with Flutter
- **Mobile Emulator/Device**: Android emulator, iOS simulator, or physical device (optional for web/desktop)
- **Assets**: Game requires image assets in `assets/images/` directory

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── level.dart             # Level data model
├── database/
│   └── database_helper.dart    # Database utilities (currently empty)
└── screens/
    ├── home_screen.dart        # Home/intro screen with story
    ├── level_screen.dart       # Main gameplay screen with timer
    ├── level_complete_screen.dart  # Level completion screen
    ├── game_complete_screen.dart   # Game end screen
    └── time_up_screen.dart     # Timeout screen

assets/
└── images/                      # Game images and assets
```

## Getting Started

### 1. Install Dependencies

```bash
cd mystery_puzzle_game
flutter pub get
```

### 2. Run the Game

**On default platform:**
```bash
flutter run
```

**On specific platform:**
```bash
# iOS Simulator (macOS only)
flutter run -d ios

# Android Emulator
flutter run -d android

# Web Browser
flutter run -d web

# macOS Desktop
flutter run -d macos

# Linux Desktop
flutter run -l

# Windows Desktop
flutter run -d windows
```

**With verbose logging:**
```bash
flutter run -v
```

## Testing

### Run Automated Tests

```bash
flutter test
```

**Note:** The current test file contains placeholder tests. For proper testing of game functionality, additional widget and integration tests should be written.

### Manual Testing Checklist

- [ ] **Home Screen**: Launch app and verify story dialog appears
- [ ] **Game Start**: Tap "Start" button and verify Level 1 begins
- [ ] **Timer**: Verify 60-second countdown timer starts and updates
- [ ] **Wrong Selection**: Click incorrect objects and verify 10 seconds are deducted
- [ ] **Hint System**: Make 3 wrong selections and verify hint message appears
- [ ] **Correct Selection**: Select correct evidence and verify level completion
- [ ] **Level Progression**: Complete levels 1-3 and verify game completion screen
- [ ] **Timeout**: Let timer reach zero and verify "Time Up" screen appears
- [ ] **Navigation**: Verify all screen transitions work correctly
- [ ] **Back Navigation**: Verify ability to return to home screen

## Game Mechanics

### Timer System
- Each level starts with 60 seconds
- Timer counts down every second
- When timer reaches 0, the level ends with "Time Up" screen

### Penalty System
- Each wrong object selection deducts 10 seconds
- Penalty prevents timer from going below 0
- Tracks total wrong attempts for feedback

### Hint System
- Triggers automatically after 3 consecutive wrong attempts
- Provides game-specific guidance
- Helps players progress without penalties

### Level Progression
1. **Level 1**: Find key evidence at crime scene
2. **Level 2**: Find object criminal left behind (wallet)
3. **Level 3**: Find object criminal left behind (notebook)

## Technology Stack

- **Framework**: Flutter 3.10.8+
- **Language**: Dart
- **State Management**: StatefulWidget (built-in)
- **UI Design**: Material Design
- **Styling**: Custom gradients and Material components

## Future Enhancements

- [ ] Implement database for level data and high scores
- [ ] Add sound effects and background music
- [ ] Implement difficulty levels (Easy, Medium, Hard)
- [ ] Add multiplayer support
- [ ] Add leaderboard system
- [ ] Implement persistent score storage
- [ ] Add more levels beyond 3
- [ ] Add different game themes/cases

## License

This project is private and not yet published.
