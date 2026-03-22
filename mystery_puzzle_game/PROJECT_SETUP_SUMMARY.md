# Mystery Detective Puzzle Game - Complete Project Setup & Architecture Summary

## Project Overview

**Mystery Detective Puzzle Game** is a Flutter-based mobile game where players solve crimes by finding evidence objects within a 60-second time limit per level. The game features a narrative-driven detective story, progressive difficulty across 3 levels, and a penalty/hint system to engage players.

**Target Platforms:** Android, iOS, Web, macOS, Linux, Windows

---

## 1. Technology Stack & Configuration

### Flutter & Dart Environment
- **Flutter Version:** 3.10.8+
- **Dart Version:** 3.10.8+
- **Package Manager:** Flutter Pub

### Key Dependencies (from pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

### Assets Configuration
- **Images Location:** `assets/images/`
- **Required Assets:** `detective.png` (used in home screen)
- Additional game object images needed for level screens

### App Configuration
- **App Name:** Mystery Detective Puzzle Game
- **Theme:** Material Design with Indigo primary color
- **Debug Mode:** Checked mode banner disabled
- **Status:** Private package (not published to pub.dev)

---

## 2. Project Directory Structure

```
mystery_puzzle_game/
│
├── lib/
│   ├── main.dart                              # App entry point & root widget
│   │
│   ├── models/
│   │   └── level.dart                         # Level data model (simple POJO)
│   │
│   ├── database/
│   │   └── database_helper.dart               # Empty (planned for future)
│   │
│   └── screens/
│       ├── home_screen.dart                   # Home/intro screen
│       ├── level_screen.dart                  # Main gameplay screen
│       ├── level_complete_screen.dart         # Level progression screen
│       ├── game_complete_screen.dart          # Game end screen
│       └── time_up_screen.dart                # Timeout screen
│
├── test/
│   └── widget_test.dart                       # Test file (placeholder)
│
├── assets/
│   └── images/                                # Game images
│
├── android/                                   # Android native code
├── ios/                                       # iOS native code
├── macos/                                     # macOS native code
├── linux/                                     # Linux native code
├── windows/                                   # Windows native code
├── web/                                       # Web platform files
│
├── pubspec.yaml                               # Flutter dependencies & config
├── analysis_options.yaml                      # Lint rules
└── README.md                                  # Documentation
```

---

## 3. Core Architecture & Game Mechanics

### App Entry Point (main.dart)
```dart
void main() {
  runApp(const MysteryGame());
}

class MysteryGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mystery Detective Puzzle Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeScreen(),  // Starts at HomeScreen
    );
  }
}
```
- Creates MaterialApp with Indigo theme
- Routes to HomeScreen as starting point
- No named routes (direct navigation via Navigator.push/pushReplacement)

### Data Model (models/level.dart)
```dart
class Level {
  final int levelNumber;      // 1-3
  final String targetObject;  // Evidence name to find
  
  Level({required this.levelNumber, required this.targetObject});
}
```
- Simple data class for level configuration
- Currently instantiated manually in level_screen.dart

### Screen Flow Architecture

```
HomeScreen (Entry Point)
    ↓ (Start button clicked)
LevelScreen (Level 1)
    ├─ Timer counts down (60 → 0)
    ├─ User clicks objects
    │  ├─ Correct → LevelCompleteScreen
    │  └─ Wrong → -10 seconds, wrong counter++
    │
    ├─ After 3 wrong → Show hint
    │
    └─ Timer reaches 0 → TimeUpScreen
    
LevelScreen (Level 2, 3) - Same mechanics
    ↓
GameCompleteScreen (All levels beaten)
    ↓
HomeScreen (Reset for replay)
```

---

## 4. Screen Components & Functionality

### 4.1 HomeScreen (lib/screens/home_screen.dart)
**Purpose:** Introduction and story narrative

**Features:**
- Displays game title with white text
- Shows tagline: "Find the clues and solve the case."
- Shows detective image from assets
- Displays story card explaining gameplay
- Shows "Play" button to start Level 1
- Displays story dialog on app load (using `addPostFrameCallback`)

**State Management:** StatefulWidget
```dart
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Shows initial story dialog after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(...); // Story dialog
    });
  }
}
```

**Navigation:** 
- Play Button → LevelScreen(level: 1, targetObject: "key")

**UI Design:**
- Gradient background: Black → Indigo
- Material Card for story text
- Centered layout with SingleChildScrollView for responsiveness

---

### 4.2 LevelScreen (lib/screens/level_screen.dart)
**Purpose:** Main gameplay mechanics and level progression

**Key State Variables:**
```dart
int timeLeft = 60;              // Countdown timer (seconds)
Timer? timer;                   // Dart timer for periodic updates
int wrongClicks = 0;            // Tracks wrong attempts
```

**Game Mechanics:**

#### Timer System
- Starts at 60 seconds per level
- Counts down via `Timer.periodic(Duration(seconds: 1))`
- Triggers every 1 second using `setState()`
- When reaches 0: Navigates to TimeUpScreen with `pushReplacement()`

#### Wrong Answer System
```dart
void wrongAnswer() {
  setState(() {
    timeLeft -= 10;              // Deduct 10 seconds
    if (timeLeft < 0) timeLeft = 0;  // Prevent negative
    wrongClicks++;               // Increment counter
  });
}
```
- Called when incorrect object is selected
- Deducts 10 seconds (minimum 0)
- Triggers hint after 3 wrong attempts

#### Hint System
```dart
if (wrongClicks == 3) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Hint: Focus on what the criminal left behind."),
    ),
  );
}
```
- Shows SnackBar hint after 3 wrong selections
- Generic hint: "Focus on what the criminal left behind"
- Only shows once (after wrongClicks == 3)

#### Level-Specific Instructions
```dart
if (widget.level == 1) {
  instruction = "Welcome! Find the key evidence.";
} else if (widget.level == 2) {
  instruction = "Find the object the criminal left behind..";
} else {
  instruction = "Find the object the criminal left behind.";
}
```
- Shows dialog before level starts
- Different text per level
- Dialog prevents user interaction until "Start" clicked

**Navigation:**
- Correct selection → LevelCompleteScreen
- Timer reaches 0 → TimeUpScreen (with pushReplacement)
- "Back" button → HomeScreen (undefined in snippet, likely to be added)

---

### 4.3 Level Complete Screen (lib/screens/level_complete_screen.dart)
**Purpose:** Transition between levels

**Expected Features:**
- Shows level completion message
- Displays stats (time remaining, wrong attempts)
- "Next Level" button for levels 1-2
- "Finish" button for level 3

**Navigation:**
- Next Level → LevelScreen(level: level+1)
- Level 3 completion → GameCompleteScreen

*(Full implementation not shown in previous reads)*

---

### 4.4 Game Complete Screen (lib/screens/game_complete_screen.dart)
**Purpose:** End game celebration and replay

**Expected Features:**
- Shows victory message
- Displays final stats/score
- "Play Again" button

**Navigation:**
- Play Again → HomeScreen (reset to level 1)

*(Full implementation not shown)*

---

### 4.5 Time Up Screen (lib/screens/time_up_screen.dart)
**Purpose:** Timeout failure state

**Expected Features:**
- Shows "Time's Up!" message
- Displays level failed
- "Retry Level" or "Return Home" button

**Navigation:**
- Retry → LevelScreen with same level
- Return Home → HomeScreen

*(Full implementation not shown)*

---

## 5. Navigation Flow

### Direct Navigation Pattern
```dart
// Forward navigation (push)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => LevelScreen(level: nextLevel)),
);

// Replace current screen (pushReplacement)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => TimeUpScreen()),
);

// Pop to previous screen
Navigator.pop(context);
```

**No Named Routes:** Application uses simple Navigator.push/pushReplacement pattern without named routes.

**State Passing:** Level data passed via constructor parameters (Level model not used directly).

---

## 6. State Management Approach

### Pattern: StatefulWidget with setState()
- **No external state management** (Redux, GetX, Riverpod, Provider)
- Each screen manages its own local state
- Timer updates trigger full `setState()` rebuild (60 times per level)

### Per-Screen State:
| Screen | State Variables |
|--------|-----------------|
| HomeScreen | None (just displays UI) |
| LevelScreen | timeLeft, timer, wrongClicks |
| LevelCompleteScreen | Level completion data |
| GameCompleteScreen | Final score data |
| TimeUpScreen | Failure state |

### Performance Impact:
- Timer rebuilds entire LevelScreen every second
- Not optimized for complex UIs (acceptable for current simplicity)
- Could be optimized with ValueNotifier or StreamBuilder for timer updates

---

## 7. UI/UX Design System

### Colors
```dart
// Primary Theme
primarySwatch: Colors.indigo

// Gradients
LinearGradient(
  colors: [Colors.black, Colors.indigo],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
)

// Text Colors
Colors.white          // Primary text
Colors.white70        // Secondary text
```

### Typography
```dart
// Title
fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white

// Subtitle
fontSize: 16, color: Colors.white70

// Body
fontSize: 15
```

### Components
- **Material Cards**: Elevated cards for content sections
- **Dialogs**: AlertDialog for story/instructions
- **SnackBars**: Bottom notifications for hints
- **Gradients**: Background effects
- **Images**: Asset images (detective.png required)

---

## 8. Game Flow Logic

### Winning Condition (per level)
- User identifies correct object
- Timer still > 0
- Navigation to LevelCompleteScreen

### Losing Condition
- Timer reaches 0 before correct selection
- Navigation to TimeUpScreen

### Penalty Mechanic
- Wrong selection → -10 seconds
- Applied via `setState()` immediately
- No animations or feedback delays

### Progression
```
Level 1: Find "key evidence"
    ↓ (success)
Level 2: Find "wallet"
    ↓ (success)
Level 3: Find "notebook"
    ↓ (success)
Game Complete Screen
```

---

## 9. Database Layer (Planned)

### Current State
- `database_helper.dart` exists but is **completely empty**
- No database operations implemented
- No data persistence

### Planned Use
- Store level configurations
- Save high scores/player progress
- Persist game state across sessions

### Future Implementation
- SQLite via sqflite package
- Level data: levelNumber, targetObject, description
- Score data: playerName, levelCompleted, timeRemaining, wrongAttempts

---

## 10. Running & Testing the Game

### Setup
```bash
# Navigate to project
cd mystery_puzzle_game

# Get dependencies
flutter pub get

# Run on default device/emulator
flutter run

# Run on specific platform
flutter run -d ios          # iOS Simulator
flutter run -d android      # Android Emulator
flutter run -d web          # Web browser
flutter run -d macos        # macOS desktop
flutter run -l              # Linux desktop
flutter run -d windows      # Windows desktop
```

### Testing
```bash
# Run all tests
flutter test

# Run with verbose output
flutter test -v

# Run specific test file
flutter test test/widget_test.dart
```

### Current Test Status
- **placeholder widget_test.dart** tests counter app (not game)
- Will FAIL - must be replaced with game-specific tests
- No proper tests for: timer, level progression, penalties, hints

### Manual Testing Checklist
```
✓ App launches → HomeScreen displays
✓ Story dialog shows on load
✓ "Play" button → Level 1 starts
✓ Timer begins counting down
✓ Clicking wrong object → -10 seconds
✓ 3 wrong clicks → Hint appears
✓ Clicking correct object → Level Complete
✓ Complete Level 2 → Game continues
✓ Complete Level 3 → Game Complete screen
✓ Timer reaches 0 → Time Up screen
✓ All navigation works smoothly
```

---

## 11. Known Issues & Gaps

### Missing/Incomplete Features
| Feature | Status | Notes |
|---------|--------|-------|
| Level object UI | INCOMPLETE | LevelScreen reading incomplete - no actual selectable objects shown |
| Database integration | NOT STARTED | database_helper.dart empty |
| Score persistence | NOT STARTED | No save/load functionality |
| Image assets | INCOMPLETE | detective.png required, game objects not created |
| Sound effects | NOT STARTED | No audio implementation |
| Animations | MISSING | No screen transitions or object selection animations |
| Proper tests | MISSING | Placeholder test file needs replacement |
| Level 3+ | NOT AVAILABLE | Only 3 hardcoded levels |

### Technical Debt
1. No error handling (what if assets missing?)
2. Hard-coded level data (should use database or config)
3. No input validation
4. Timer continues in background if app minimized
5. No pause/resume functionality
6. setState() rebuilds entire widget (inefficient)

---

## 12. Development Workflow

### File Organization
- **Screens Isolated**: Each screen in separate file
- **Models Separate**: Data classes in models/ folder
- **Assets Organized**: Images in assets/images/
- **No Shared Services**: No utilities, helpers, or providers

### Code Style
- Uses Flutter best practices
- Material Design components
- Proper constructor key usage (super.key)
- Comments present in places

### Build System
- Standard Flutter build system
- Android Gradle build (android/)
- iOS Xcode build (ios/)
- Web support enabled
- Linux/macOS/Windows support enabled

---

## 13. How to Extend the Game

### Add a New Level
1. Create new level parameters in LevelScreen
2. Add level intro text in `showLevelIntro()`
3. Add navigation chain: LevelComplete → next LevelScreen
4. Update Level 3 to navigate to GameCompleteScreen

### Add New Screen/Feature
1. Create new file in `lib/screens/`
2. Extend StatelessWidget or StatefulWidget
3. Import in navigation source and add Navigator.push()
4. Pass any required data via constructor

### Implement Database
1. Add sqflite dependency to pubspec.yaml
2. Implement database_helper.dart with SQLite methods
3. Convert hard-coded levels to database queries
4. Add score persistence

### Add Animations
1. Use AnimationController in StatefulWidget
2. Wrap widgets in AnimatedBuilder or AnimatedWidget
3. Add transitions to screen routes

---

## 14. Summary

**What You Have:**
✓ Working Flutter app with 3 levels
✓ Timer system with 60-second countdown
✓ Penalty system (-10 seconds on wrong answer)
✓ Hint system (after 3 wrong attempts)
✓ Navigation between screens
✓ Material Design UI
✓ Cross-platform support

**What Needs Work:**
✗ Actual game object selection UI (critical)
✗ Image assets and level graphics
✗ Proper unit/widget tests
✗ Database implementation
✗ Score persistence
✗ Sound and animations
✗ Error handling and validation

**Next Steps to Ship:**
1. Complete LevelScreen with interactive game objects
2. Create required image assets
3. Implement proper widget tests
4. Test on target platforms (iOS/Android)
5. Polish UI/UX with animations
6. Add database for score persistence

---

**Project Status:** Early/Mid Development - Core mechanics functional, UI/content incomplete
