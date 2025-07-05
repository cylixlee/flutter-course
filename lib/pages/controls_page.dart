import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/controls_showcase.dart';

class ControlsPage extends StatelessWidget {
  const ControlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ControlsShowcase(
          children: [
            FilledButton(onPressed: () {}, child: const Text("FilledButton")),
            OutlinedButton(
              onPressed: () {},
              child: const Text("OutlinedButton"),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text("Controls")),
    );
  }
}
