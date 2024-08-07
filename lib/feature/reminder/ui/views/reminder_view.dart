import 'package:dupli/feature/reminder/ui/widgets/reminder_view_body.dart';
import 'package:flutter/material.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Reminder Session',
        ),
      ),
      body: const ReminderViewBody(),
    );
  }
}
