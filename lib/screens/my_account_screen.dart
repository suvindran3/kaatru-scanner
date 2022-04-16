import 'package:device_scanner/components/custom_dialog.dart';
import 'package:device_scanner/screens/installed_devices_screen.dart';
import 'package:device_scanner/screens/sign_in_screen.dart';
import 'package:device_scanner/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../network/database.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen>
    with SingleTickerProviderStateMixin {
  late CustomDialog customDialog;

  @override
  void initState() {
    customDialog = CustomDialog.init(this);
    customDialog.initializeController();
    super.initState();
  }

  @override
  void dispose() {
    customDialog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.brown,
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4.3,
              padding: EdgeInsets.only(
                  right: 15, left: 15, top: MediaQuery.of(context).padding.top),
              child: const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xffEAEFF3),
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 80,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 35),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'User ID:  ',
                                  style: GoogleFonts.outfit(color: Colors.grey),
                                ),
                                TextSpan(
                                  text: Database.user.id,
                                  style:
                                      GoogleFonts.outfit(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Username:  ',
                                  style: GoogleFonts.outfit(color: Colors.grey),
                                ),
                                TextSpan(
                                  text: Database.user.name,
                                  style:
                                      GoogleFonts.outfit(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const _OptionCard(
                      optionName: 'Installed devices',
                      iconData: Icons.history,
                      nextScreen: InstalledDevicesScreen(),
                    ),
                    const _OptionCard(
                      optionName: 'Contact us',
                      iconData: Icons.contact_page_outlined,
                      nextScreen: SplashScreen(),
                    ),
                    const _OptionCard(
                      optionName: 'About us',
                      iconData: Icons.details,
                      nextScreen: SplashScreen(),
                    ),
                    _OptionCard(
                      optionName: 'Sign out',
                      iconData: Icons.logout,
                      onTap: signOut,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void signOut() async {
    customDialog.show(
      context: context,
      title: 'Sign out',
      content: 'Are you sure you want to sign out?',
      secondButtonText: 'Sign out',
      secondButtonTap: () async {
        customDialog.stateChanged = true;
        await Database.signOut();
      },
      onComplete: (state) {
        if (state) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
          );
        }
      },
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    Key? key,
    required this.optionName,
    required this.iconData,
    this.nextScreen,
    this.onTap,
  }) : super(key: key);

  final String optionName;
  final IconData iconData;
  final Widget? nextScreen;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: nextScreen != null
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => nextScreen!),
                  )
              : onTap,
          leading: CircleAvatar(
            backgroundColor: const Color(0xffEAEFF3),
            child: Icon(
              iconData,
              color: Colors.grey,
            ),
          ),
          title: Text(
            optionName,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.navigate_next),
        ),
        SizedBox(
          height: 10,
          child: Divider(
            color: Colors.grey.shade300,
            indent: 15,
            endIndent: 15,
          ),
        ),
      ],
    );
  }
}
