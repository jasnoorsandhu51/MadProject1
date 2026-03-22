class ClueObject {
  final String label;
  final String imagePath;
  final double left;
  final double top;
  final bool visible;
  // Extra transparent padding added around the image to enlarge the tap zone.
  final double hitPadding;

  const ClueObject({
    required this.label,
    required this.imagePath,
    required this.left,
    required this.top,
    this.visible = true,
    this.hitPadding = 0,
  });
}

class LevelConfig {
  final int level;
  final String sceneImage;
  final List<ClueObject> clues;
  final String narrativeQuote;

  const LevelConfig({
    required this.level,
    required this.sceneImage,
    required this.clues,
    required this.narrativeQuote,
  });

  static const List<LevelConfig> levels = [
    LevelConfig(
      level: 1,
      sceneImage: 'assets/images/scene1.jpg',
      clues: [
        ClueObject(
          label: 'lockpick',
          imagePath: 'assets/images/lockpick.png',
          left: 0.15,
          top: 0.60,
        ),
        ClueObject(
          label: 'hammer',
          imagePath: 'assets/images/hammer.png',
          left: 0.40,
          top: 0.45,
        ),
      ],
      narrativeQuote:
          "Someone broke in with tools. These weren't grabbed in a hurry.",
    ),
    LevelConfig(
      level: 2,
      sceneImage: 'assets/images/scene2.jpg',
      clues: [
        ClueObject(
          label: 'footprint',
          imagePath: 'assets/images/footprint.png',
          left: 0.25,
          top: 0.70,
          visible: false,
          hitPadding: 48,
        ),
        ClueObject(
          label: 'wallet',
          imagePath: 'assets/images/wallet.png',
          left: 0.60,
          top: 0.55,
        ),
      ],
      narrativeQuote: 'The thief dropped something while fleeing. Careless.',
    ),
    LevelConfig(
      level: 3,
      sceneImage: 'assets/images/scene3.jpg',
      clues: [
        ClueObject(
          label: 'diary',
          imagePath: 'assets/images/diary.png',
          left: 0.36,
          top: 0.30,
        ),
      ],
      narrativeQuote: "Investigate Stacy's room for clues.",
    ),
  ];
}
