import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RunRecord {
  final String playerName;
  final int score;
  final int timeRemaining;
  final int wrongClicks;

  const RunRecord({
    required this.playerName,
    required this.score,
    required this.timeRemaining,
    required this.wrongClicks,
  });

  Map<String, dynamic> toJson() => {
    'playerName': playerName,
    'score': score,
    'timeRemaining': timeRemaining,
    'wrongClicks': wrongClicks,
  };

  factory RunRecord.fromJson(Map<String, dynamic> json) => RunRecord(
    playerName: json['playerName'] as String,
    score: json['score'] as int,
    timeRemaining: json['timeRemaining'] as int,
    wrongClicks: json['wrongClicks'] as int,
  );

  static int calculateScore(int timeRemaining, int wrongClicks) =>
      timeRemaining * 10 - wrongClicks * 50;
}

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _key = 'run_records';

  Future<void> saveRun(RunRecord run) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];
    existing.add(jsonEncode(run.toJson()));
    await prefs.setStringList(_key, existing);
  }

  Future<List<RunRecord>> getAllRuns() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    final records = list
        .map((s) => RunRecord.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    records.sort((a, b) => b.score.compareTo(a.score));
    return records;
  }
}

class PreferencesService {
  static const _nameKey = 'player_name';

  static Future<String> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? 'Player';
  }

  static Future<void> savePlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }
}
