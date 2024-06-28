// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
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

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Color> colorSequence = [];
  List<Color> userSequence = [];
  int level = 1;
  bool showSequence = true;
  int currentStep = 0;
  Random random = Random();

  void generateSequence() {
    colorSequence = [];
    for (int i = 0; i < level; i++) {
      colorSequence
          .add(Colors.primaries[random.nextInt(Colors.primaries.length)]);
    }
  }

  void startNewLevel() {
    setState(() {
      userSequence = [];
      currentStep = 0;
      level++;
      showSequence = true;
      generateSequence();
      showColorSequence();
    });
  }

  void showColorSequence() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentStep < colorSequence.length) {
        setState(() {
          showSequence = true;
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            showSequence = false;
            currentStep++;
          });
        });
      } else {
        timer.cancel();
        setState(() {
          currentStep = 0;
        });
      }
    });
  }

  void onColorButtonPressed(Color color) {
    setState(() {
      userSequence.add(color);
      if (userSequence.length == colorSequence.length) {
        if (userSequence.toString() == colorSequence.toString()) {
          startNewLevel();
        } else {
          showGameOverDialog();
        }
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text("You reached level $level"),
          actions: [
            TextButton(
              child: const Text("Home"),
              onPressed: () {
                // Fucntion send to firebase
                context.navigateAndRemoveUntil(
                  newRoute: Routes.layOutViewsRoute,
                );
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    generateSequence();
    showColorSequence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Level: $level',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showSequence && currentStep < colorSequence.length)
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: colorSequence[currentStep],
              ),
            if (!showSequence || currentStep >= colorSequence.length)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: Colors.primaries.map((color) {
                  return ElevatedButton(
                    onPressed: () => onColorButtonPressed(color),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      minimumSize: const Size(50, 50),
                    ),
                    child: Container(),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
