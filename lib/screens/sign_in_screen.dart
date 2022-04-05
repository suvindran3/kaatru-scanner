import 'dart:async';
import 'package:flutter/material.dart';
import '../components/arc_painter.dart';
import '../components/custom_text_field.dart';
import '../operations/operations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController userIDController = TextEditingController();

  final TextEditingController numberController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final StreamController<bool> isLoading = StreamController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    numberController.dispose();
    userIDController.dispose();
    passwordController.dispose();
    isLoading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Operations.exit(context),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: CustomPaint(
                painter: ArcPainter(),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 150.0, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Welcome!',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Text(
                              'Sign in to continue',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextField(
                              controller: userIDController,
                              hintText: 'User ID',
                              iconData: Icons.person,
                              inputType: TextInputType.text,
                              validator: (input) => userIDValidator(input),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            CustomTextField(
                              controller: passwordController,
                              visibility: true,
                              hintText: 'Password',
                              iconData: Icons.lock,
                              inputType: TextInputType.text,
                              validator: (input) => passwordValidator(input),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<bool>(
                        initialData: false,
                        stream: isLoading.stream,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed:
                                snapshot.data! ? null : () => signIn(context),
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                const Size(double.maxFinite, 50),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(
                                scale: CurvedAnimation(
                                    parent: animation, curve: Curves.easeInOut),
                                child: child,
                              ),
                              child: snapshot.data != null &&
                                      snapshot.data == false
                                  ? const Text('SIGN IN')
                                  : const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white54),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? userIDValidator(String input) {
    if (input.isEmpty) {
      return 'please enter a email';
    } else {
      return null;
    }
  }

  String? passwordValidator(String input) {
    if (input.isEmpty) {
      return 'please enter the password';
    } else {
      return null;
    }
  }

  void signIn(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading.add(true);
      FocusManager.instance.primaryFocus?.unfocus();
      await Operations.signIn(
        context: context,
        userID: userIDController.text,
        password: passwordController.text,
        onError: () => isLoading.add(false),
      );
    }
  }
}
