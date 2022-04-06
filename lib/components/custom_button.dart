import 'package:device_scanner/controllers/button_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      this.onTap,
      required this.buttonText,
      required this.buttonController})
      : super(key: key);

  final VoidCallback? onTap;
  final String buttonText;
  final ButtonController buttonController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: AnimatedBuilder(
        animation: buttonController,
        builder: (context, _) => buttonController.isLoading
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                buttonText,
                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
              ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.brown,
        ),
        fixedSize: MaterialStateProperty.all(
          const Size(double.maxFinite, 50),
        ),
      ),
    );
  }
}
