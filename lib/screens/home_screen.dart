import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:device_scanner/operations/operations.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController pageController = PageController();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await Operations.exit(context),
      child: Theme(
        data: ThemeData(
          textTheme: TextTheme(
            bodyText2: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
          ),
        ),
        child: Scaffold(
          bottomNavigationBar: ConvexAppBar(
              height: 60,
              controller: tabController,
              backgroundColor: Colors.brown,
              color: Colors.white70,
              onTap: (index) {
                pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate);
              },
              items: const [
                TabItem(
                  title: 'SCAN',
                  icon: Icon(
                    Icons.qr_code,
                    color: Colors.white70,
                  ),
                  activeIcon: Icon(
                    Icons.qr_code,
                    color: Colors.black,
                  ),
                ),
                TabItem(
                  title: 'TICKETS',
                  icon: Icon(
                    Icons.confirmation_number_outlined,
                    color: Colors.white70,
                  ),
                  activeIcon: Icon(
                    Icons.confirmation_number_outlined,
                    color: Colors.black,
                  ),
                ),
                TabItem(
                  title: 'MY ACCOUNT',
                  icon: Icon(
                    Icons.person,
                    color: Colors.white70,
                  ),
                  activeIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              tabController.animateTo(index);
            },
            children: const [
              ScannerScreen(),
              TicketsScreen(),
              MyAccountScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
