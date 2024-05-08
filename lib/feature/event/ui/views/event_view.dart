import 'package:dubli/feature/event/ui/widgets/event_view_body.dart';
import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EventViewBody(),
    );
  }
}
