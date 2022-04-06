import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key, required this.id, required this.forTicket})
      : super(key: key);

  final bool forTicket;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.done_outlined,
                color: Colors.brown,
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 5),
            child: Text(
              'Success!'.toUpperCase(),
              style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            forTicket
                ? 'A ticket has been raised with the ID $id'
                : 'The device $id has been deployed successfully',
            style: GoogleFonts.outfit(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Back to home',
                    style: TextStyle(color: Colors.brown),
                  ),
                  Icon(
                    Icons.navigate_next_outlined,
                    color: Colors.brown,
                  ),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
