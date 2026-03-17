import 'package:flutter/material.dart';

class PhaseLabel extends StatelessWidget {
  final String label;
  final Color color;

  const PhaseLabel({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 3,
      ),
    );
  }
}
