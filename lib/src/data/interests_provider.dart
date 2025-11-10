import 'package:flutter/foundation.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/domain/game.dart';

class InterestsProvider extends ChangeNotifier {
  final DatabaseRepository db;

  List<String> _interests = [];

  bool _isLoading = false;

  String? _error;

  List<String> get interests => _interests;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasInterests => _interests.isNotEmpty;

  InterestsProvider(this.db);

  Future<void> loadInterests(List<String> gameIds) async {
    if (gameIds.isEmpty) {
      _interests = [];
      _isLoading = false;
      _error = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final gameFutures = gameIds.map((gameId) => db.getGameById(gameId));
      final games = await Future.wait(gameFutures);

      _interests = games
          .where((game) => game != null)
          .map((game) => game!.gameName)
          .toList();

      _isLoading = false;
      _error = null;
    } catch (e) {
      debugPrint('InterestsProvider: Error loading interests: $e');
      _interests = [];
      _isLoading = false;
      _error = 'Failed to load interests';
    }

    notifyListeners();
  }

  void clearInterests() {
    _interests = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  Future<void> refreshInterests(List<String> gameIds) async {
    clearInterests();
    await loadInterests(gameIds);
  }
}
