# User Guide — Mystery Detective Puzzle Game

## Table of Contents

1. [Setup](#1-setup)
2. [Running the game](#2-running-the-game)
3. [Gameplay walkthrough](#3-gameplay-walkthrough)
4. [Scoring](#4-scoring)
5. [Leaderboard & player name](#5-leaderboard--player-name)
6. [Screen reference](#6-screen-reference)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Setup

### Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **3.10.8 or higher**
- Dart is bundled with Flutter — no separate install needed
- A target platform (pick any one):
  - Web browser (Chrome recommended)
  - macOS, Windows, or Linux desktop
  - Android emulator or physical device
  - iOS Simulator (macOS only)

### Install dependencies

```bash
cd mystery_puzzle_game
flutter pub get
```

This fetches `shared_preferences` and all other packages listed in `pubspec.yaml`.

---

## 2. Running the game

### Quickest option — web (no emulator needed)

```bash
flutter run -d chrome
```

### macOS desktop

```bash
flutter run -d macos
```

### Android

Start an Android emulator from Android Studio first, then:

```bash
flutter run -d android
```

Or list all connected devices and pick one:

```bash
flutter devices
flutter run -d <device-id>
```

### iOS (macOS only)

Open Simulator.app first, then:

```bash
flutter run -d ios
```

### Windows / Linux desktop

```bash
flutter run -d windows
flutter run -d linux
```

### Release / optimised build

```bash
flutter run --release
```

---

## 3. Gameplay walkthrough

### Home screen

The game opens on the home screen with the case title and a **START INVESTIGATION** button. Tap it to begin.

### Intro narrative

A dialogue sequence sets the scene. Tap anywhere to advance through each line. When the dialogue ends you are taken to Level 1 automatically.

### Level screen

Each level gives you **60 seconds** to find one specific piece of evidence hidden in the scene.

| Action | What happens |
|---|---|
| Tap the **correct object** | Evidence is collected; a green snackbar confirms the find |
| Tap an **incorrect object** | −10 seconds penalty; wrong-click counter increases |
| Timer reaches **0** | You are taken to the Time Up screen |

A clue progress bar at the top shows how many of the level's clues you have found.

After finding all clues in a level, a short inter-level dialogue plays before the next level begins.

### Level progression

| Level | Evidence to find |
|---|---|
| 1 | The Vault Key |
| 2 | The Muddy Wallet |
| 3 | The Hidden Glove |

### Time Up screen

If the timer runs out you see a "Time Up" screen. Tap **TRY AGAIN** to restart the same level, or **HOME** to return to the main menu.

---

## 4. Scoring

Your score is calculated once at the end of all three levels:

```
score = (time remaining in seconds × 10) − (wrong clicks × 50)
```

The time remaining carried into the formula is whatever time was left on the clock when you found the final clue in Level 3.

**Examples**

| Time left | Wrong clicks | Score |
|---|---|---|
| 45 s | 0 | 450 pts |
| 30 s | 2 | 200 pts |
| 10 s | 5 | −150 pts |

Scores can be negative if you accumulated many penalties.

---

## 5. Leaderboard & player name

### Name entry dialog

When the **Game Complete** screen first appears a dialog asks for your name. This is pre-filled with the name you used last time (stored locally).

- Type your name and tap **SAVE**
- Your run is saved to the local leaderboard immediately
- The dialog only appears once per run — rebuilds caused by the particle animation do not re-trigger it

### Leaderboard panel

The right column of the Game Complete screen shows:

- **THIS RUN** — your score, time left, and penalty count for this run
- **LEADERBOARD** — top 5 all-time runs sorted by score (highest first), with player name and score on each row

Leaderboard data is stored locally using `shared_preferences` and persists across app restarts. It is per-device only.

---

## 6. Screen reference

| Screen | File | Purpose |
|---|---|---|
| Home | `home_screen.dart` | Entry point; start button |
| Intro background | `intro_background_screen.dart` | Animated intro before dialogue |
| Dialogue | `dialogue_screen.dart` | Narrative scenes between levels |
| Level | `level_screen.dart` | Core gameplay — timer, clue tapping |
| Level complete | `level_complete_screen.dart` | Per-level summary; continue button |
| Game complete | `game_complete_screen.dart` | Final score, leaderboard, buttons |
| Time up | `time_up_screen.dart` | Timeout — retry or home |

### Game Complete screen layout

```
┌─────────────────────────────────────────────────────┐
│               [ CASE SOLVED ]  badge                │
├────────────────────────┬────────────────────────────┤
│  LEFT COLUMN           │  RIGHT COLUMN              │
│  • Polaroid + GUILTY   │  THIS RUN header           │
│    stamp               │  Score (big)               │
│  • STACY name          │  TIME LEFT | PENALTIES     │
│  • Exhibition Maid     │  ──────────────────        │
│  • Amber divider       │  LEADERBOARD header        │
│  • 5 evidence rows     │  1. Player — 450 pts       │
│    with ✓ icons        │  2. …                      │
│                        │  [Spacer]                  │
│                        │  [ CLOSE THE CASE ]        │
│                        │  [ PLAY AGAIN ]            │
└────────────────────────┴────────────────────────────┘
```

---

## 7. Troubleshooting

### `flutter pub get` fails

Make sure Flutter is on your PATH:

```bash
flutter --version
```

If the command is not found, follow the [Flutter install guide](https://docs.flutter.dev/get-started/install) for your OS.

### No devices found

```bash
flutter devices
```

- **Web**: ensure Chrome is installed; use `-d chrome`
- **Android**: start the emulator from Android Studio (AVD Manager) before running
- **iOS**: open Simulator.app on macOS first

### Image assets missing / blank scene

Ensure `assets/images/` contains the required images (`maid.png`, scene assets). The asset directory is declared in `pubspec.yaml` under `flutter: assets:`.

### Leaderboard shows stale data

The leaderboard re-fetches after you save your name. If it still looks wrong, hot-restart the app (`R` in the terminal running `flutter run`).

### Score appears negative

Each wrong click subtracts 50 points. A large number of penalties with little time remaining produces a negative score — this is expected behaviour.
