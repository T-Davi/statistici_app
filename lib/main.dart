import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// player type
class Player {
  String name;
  int lives;

  late String emoji, extraEmoji = '';
  String deadline = 'deadline';

  Player(this.name, this.lives) {
    emoji = getRandomHeart();
    deadline = generateDeadline();
  }

  String generateDeadline() {
    final deadlines = [
      '$name - ☠️',
      '$name - 🧟‍♂️',
      'BANG $name',
    ];
    final random = Random();
    return deadlines[random.nextInt(deadlines.length)];
  }

  String getRandomHeart() {
    final emojis = ['❤️', '💚', '💙', '🧡', '❤️‍🔥', '💘', '💝', '💖'];
    final random = Random();
    return emojis[random.nextInt(emojis.length)];
  }

  void removeLife() {
    if (extraEmoji.isNotEmpty) {
      extraEmoji = extraEmoji.characters.take(extraEmoji.characters.length - 1).toString();
    } else if (lives > 0) {
      lives--;
    }
  }

  String title() {
    if (lives == 0) {
      return deadline;
    }
    return '$name - ${emoji * lives}$extraEmoji';
  }
}

// main app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      // theme: ThemeData.light(), // light theme
      theme: ThemeData.dark(), // dark theme
    );
  }
}

// players screen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// players screen state
class _MainScreenState extends State<MainScreen> {
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    loadPlayers();
  }

  // memory actions
  Future<void> savePlayers() async {
    // final prefs = await SharedPreferences.getInstance();
    // final data = players.map((p) => p.toJson()).toList();
    // print(data);
    // prefs.setString('players', jsonEncode(data));
  }

  Future<void> loadPlayers() async {
    // final prefs = await SharedPreferences.getInstance();
    // final data = prefs.getString('players');
    // if (data != null) {
    //   final List<dynamic> decoded = jsonDecode(data);
    //   print(decoded);
    //   setState(() {
    //     // players = decoded.map((e) => Player.fromJson(e)).toList();
    //     // players = decoded.map((e) => Player.fromJson(e)).toList();
    //   });
    // }
  }

  // pre game actions
  void addPlayer(String name) {
    setState(() {
      players.add(Player(name, 4));
      savePlayers();
    });
  }

  // in game actions
  void removePlayer(int index) {
    setState(() {
      players.removeAt(index);
      savePlayers();
    });
  }

  void removeLife(int index) {
    if (players[index].lives > 0) {
      setState(() {
        players[index].removeLife();
        savePlayers();
      });
    } else {
      removePlayer(index);
    }
  }

  void stealLife(int giverIndex, int receiverIndex) {
    if (players[giverIndex].lives > 0) {
      setState(() {
        players[giverIndex].removeLife();
        players[receiverIndex].extraEmoji += players[giverIndex].emoji;
        savePlayers();
      });
    }
  }

  void undoAction() {
    if (players.length > 1) {
      setState(() {
        // TODO: undo action
        // savePlayers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistici'),
      ),
      body: Column(
        children: [
          // list of players
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(players[index].title()),
                  // subtitle: Text('Lives: ${players[index].lives}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // add life button
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: players[index].lives == 0
                            ? null
                            : () async {
                                final giverIndex = await showDialog(
                                  context: context,
                                  builder: (context) => SelectPlayerDialog(players, index),
                                );
                                if (giverIndex != null) {
                                  stealLife(giverIndex, index);
                                }
                              },
                      ),
                      // remove life button
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          removeLife(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // add player and undo buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = await showDialog(
                        context: context,
                        builder: (context) => AddPlayerDialog(),
                      );
                      if (name != null && name.isNotEmpty) {
                        addPlayer(name);
                      }
                    },
                    child: const Text('Aggiungi giocatore'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: players.isNotEmpty ? () => undoAction() : null,
                    child: const Text('Annulla'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      /*
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController nameController = TextEditingController();
                return AlertDialog(
                  title: const Text('Add Participant'),
                  content: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Enter Name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      */
    );
  }
}

// add player dialog screen
class AddPlayerDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  AddPlayerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Inserisci il nome del giocatore:'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Nome'),
        autofocus: true,
        onSubmitted: (value) {
          Navigator.of(context).pop(controller.text.trim());
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text.trim());
          },
          child: const Text('Aggiungi'),
        ),
      ],
    );
  }
}

// select player dialog screen
class SelectPlayerDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final List<Player> players;
  final int currentIndex;

  SelectPlayerDialog(this.players, this.currentIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scegli a chi rubare una vita:'),
      content: Column(
        children: players.map((player) {
          return ListTile(
            title: Text(player.title()),
            onTap: player.lives == 0 || players.indexOf(player) == currentIndex
                ? null
                : () {
                    Navigator.pop(context, players.indexOf(player));
                  },
            enabled: player.lives > 0 && players.indexOf(player) != currentIndex,
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
      ],
    );
  }
}
