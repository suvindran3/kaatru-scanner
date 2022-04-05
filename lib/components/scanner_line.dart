import 'package:flutter/material.dart';

class ScannerLine extends StatefulWidget {
  const ScannerLine({Key? key}) : super(key: key);

  @override
  State<ScannerLine> createState() => _ScannerLineState();
}

class _ScannerLineState extends State<ScannerLine>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.5, 0),
        end: const Offset(0.5, 0),
      ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn),
      ),
      child: const VerticalDivider(
        color: Colors.red,
        thickness: 2,
      ),
    );
  }
}
