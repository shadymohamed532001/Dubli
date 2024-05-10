import 'package:dubli/feature/reminder/ui/widgets/reminder_view_body.dart';
import 'package:flutter/material.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ReminderViewBody(),
    );
  }
}
