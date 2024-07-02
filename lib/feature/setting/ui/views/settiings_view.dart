import 'package:dupli/feature/setting/ui/widgets/settings_view_body.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.settings,
        ),
        title: const Text(
          'Settings',
        ),
      ),
      body: const SettingsViewBody(),
    );
  }
}
