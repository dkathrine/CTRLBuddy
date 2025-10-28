import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/domain/game.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';

class GamePicker extends StatefulWidget {
  // Callback when a game is selected
  final Function(Game) onGameSelected;

  // Initial game to display (optional, for editing scenarios)
  final Game? initialGame;

  /// Label for the text field
  final String label;

  // Database repository for fetching games
  final DatabaseRepository databaseRepository;

  // Current user ID for creating game suggestions
  final String currentUserId;

  const GamePicker({
    super.key,
    required this.onGameSelected,
    required this.databaseRepository,
    required this.currentUserId,
    this.initialGame,
    this.label = 'Select a Game',
  });

  @override
  State<GamePicker> createState() => _GamePickerState();
}

class _GamePickerState extends State<GamePicker> {
  final TextEditingController _controller = TextEditingController();
  List<Game> _allGames = [];
  bool _isLoading = true;
  Game? _selectedGame;

  @override
  void initState() {
    super.initState();
    _loadGames();

    // Set initial game if provided
    if (widget.initialGame != null) {
      _selectedGame = widget.initialGame;
      _controller.text = widget.initialGame!.gameName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    setState(() => _isLoading = true);

    try {
      final games = await widget.databaseRepository.getPublishedGames(
        limit: 500,
      );
      setState(() {
        _allGames = games;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading games: $e')));
        debugPrint("Error loading games: $e");
      }
    }
  }

  List<Game> _filterGames(String query) {
    if (query.isEmpty) return _allGames;

    final lowerQuery = query.toLowerCase();
    return _allGames.where((game) {
      return game.gameName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<void> _showGameSuggestionDialog(String gameName) async {
    final shouldSuggest = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Not Found'),
        content: Text(
          'We couldn\'t find "$gameName" in our database.\n\n'
          'Would you like to suggest it? We\'ll review your suggestion and add it soon.\n\n'
          'In the meantime, please use the "General" tag for your post.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Suggest Game'),
          ),
        ],
      ),
    );

    if (shouldSuggest == true) {
      await _suggestNewGame(gameName);
    }
  }

  Future<void> _suggestNewGame(String gameName) async {
    try {
      final newGame = Game(
        id: '',
        gameName: gameName,
        slug: gameName.toLowerCase().trim().replaceAll(' ', '_'),
        status: 'pending',
        createdBy: widget.currentUserId,
      );

      await widget.databaseRepository.createGame(newGame);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Thank you! Your game suggestion has been submitted for review.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Clear the text field
      _controller.clear();
      setState(() => _selectedGame = null);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error suggesting game: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Autocomplete<Game>(
      initialValue: widget.initialGame != null
          ? TextEditingValue(text: widget.initialGame!.gameName)
          : null,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Game>.empty();
        }
        return _filterGames(textEditingValue.text);
      },
      displayStringForOption: (Game game) => game.gameName,
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Sync our controller with the field controller
            if (_controller.text.isEmpty && fieldController.text.isNotEmpty) {
              _controller.text = fieldController.text;
            }

            return TextField(
              controller: fieldController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: 'Start typing to search...',
                suffixIcon: _selectedGame != null
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                _controller.text = value;
              },
              onSubmitted: (value) {
                // If user presses enter and no game is selected, show suggestion dialog
                if (_selectedGame == null && value.isNotEmpty) {
                  final exactMatch = _allGames
                      .where(
                        (game) =>
                            game.gameName.toLowerCase() == value.toLowerCase(),
                      )
                      .toList();

                  if (exactMatch.isEmpty) {
                    _showGameSuggestionDialog(value);
                  }
                }
              },
            );
          },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<Game> onSelected,
            Iterable<Game> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 400,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Game game = options.elementAt(index);
                      return ListTile(
                        leading:
                            game.coverUrl != null && game.coverUrl!.isNotEmpty
                            ? Image.network(
                                game.coverUrl!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.videogame_asset),
                              )
                            : const Icon(Icons.videogame_asset),
                        title: Text(game.gameName),
                        subtitle: Text('${game.threadsCount} threads'),
                        onTap: () {
                          onSelected(game);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
      onSelected: (Game selectedGame) {
        setState(() {
          _selectedGame = selectedGame;
          _controller.text = selectedGame.gameName;
        });
        widget.onGameSelected(selectedGame);
      },
    );
  }
}
