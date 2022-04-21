import 'package:flutter/material.dart';

class SimpleLoadingIndicator extends StatelessWidget {
  const SimpleLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor:
          AlwaysStoppedAnimation(Colors.brown),
        ),
      ),
    );
  }
}

