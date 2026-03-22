class GameState {
  GameState._();
  static final GameState instance = GameState._();

  static const int totalClues = 5;
  final List<String> foundClues = [];

  void addClue(String label) {
    if (!foundClues.contains(label)) {
      foundClues.add(label);
    }
  }

  int get foundCount => foundClues.length;

  void reset() {
    foundClues.clear();
  }
}
