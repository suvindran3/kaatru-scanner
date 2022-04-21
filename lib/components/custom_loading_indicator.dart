import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RiveAnimation.asset('images/loading-indicator.riv');
  }
}
