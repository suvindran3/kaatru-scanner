import 'package:device_scanner/controllers/navbar_controller.dart';
import 'package:device_scanner/screens/my_account_screen.dart';
import 'package:device_scanner/screens/scanner_screen.dart';
import 'package:device_scanner/screens/tickets_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  final NavbarController navbarController = NavbarController();

  @override
  void dispose() {
    navbarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBuilder(
        animation: navbarController,
        builder: (context, _) {
          return BottomNavigationBar(
            onTap: (index) => navbarController.updateIndex(index,
                pageController: pageController),
            iconSize: 30,
            currentIndex: navbarController.currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.brown,
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            selectedLabelStyle:
                GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(
                label: 'SCAN',
                icon: Icon(Icons.qr_code),
              ),
              BottomNavigationBarItem(
                label: 'TICKETS',
                icon: Icon(Icons.confirmation_number_outlined),
              ),
              BottomNavigationBarItem(
                label: 'MY ACCOUNT',
                icon: Icon(Icons.person),
              ),
            ],
          );
        },
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          navbarController.updateIndex(index);
        },
        children: const [
          ScannerScreen(),
          TicketsScreen(),
          MyAccountScreen(),
        ],
      ),
    );
  }
}
