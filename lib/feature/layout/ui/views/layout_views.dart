import 'package:dubli/feature/layout/ui/widgets/bottom_nav_bar.dart';
import 'package:dubli/feature/layout/ui/widgets/layout_view_body.dart';
import 'package:flutter/material.dart';


class LayOutViews extends StatefulWidget {
  const LayOutViews({super.key});

  @override
  State<LayOutViews> createState() => _LayOutViewsState();
}

class _LayOutViewsState extends State<LayOutViews> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayOutViewBody(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
