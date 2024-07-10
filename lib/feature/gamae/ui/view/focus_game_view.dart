import 'package:dupli/feature/gamae/ui/widgets/game_view.dart';
import 'package:flutter/material.dart';

class FocusGame extends StatelessWidget {
  const FocusGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}
