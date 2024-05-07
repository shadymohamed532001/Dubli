import 'package:dubli/feature/home/ui/widgets/home_view_body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Task List',
        ),
      ),
      body: const HomeViewBody(),
    );
  }
}
