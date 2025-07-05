import 'package:flutter/material.dart';

class ControlsShowcase extends StatelessWidget {
  final double maxWidth;
  final double maxCrossAxisExtent;
  final double spacing;
  final List<Widget> children;

  const ControlsShowcase({
    super.key,
    this.maxWidth = 768,
    this.spacing = 16,
    this.maxCrossAxisExtent = 256,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: maxCrossAxisExtent,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      shrinkWrap: true,
      children: List.generate(children.length, (index) {
        return UnconstrainedBox(child: children[index]);
      }),
    );
  }
}
