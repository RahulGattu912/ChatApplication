import 'package:chat_app_demo/home/home_page.dart';
import 'package:chat_app_demo/register/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_demo/themes/light_mode.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ThemeData themeData = lightMode;
  TextTheme textTheme = theme;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.colorScheme.tertiary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              color: themeData.colorScheme.primary,
              size: 48,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Sign in to continue',
              style: textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  height: 52,
                  child: TextField(
                    style: textTheme.titleLarge
                        ?.copyWith(color: themeData.colorScheme.shadow),
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: textTheme.titleLarge,
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeData.colorScheme.secondary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeData.colorScheme.primary),
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  height: 52,
                  child: TextField(
                      style: textTheme.titleLarge
                          ?.copyWith(color: themeData.colorScheme.shadow),
                      controller: _password,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        hintText: 'Password',
                        hintStyle: textTheme.titleLarge,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: themeData.colorScheme.secondary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeData.colorScheme.primary),
                            borderRadius: BorderRadius.circular(16)),
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                    _verifyEmailPassword(
                        context: context,
                        email: _email.text,
                        password: _password.text);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text(
                                'Error',
                                style: textTheme.titleLarge?.copyWith(
                                    color: themeData.colorScheme.shadow),
                              ),
                              content: Text(
                                'Please Enter valid Email and Password',
                                style: textTheme.titleLarge,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Close',
                                    style: textTheme.titleLarge?.copyWith(
                                        color: themeData.colorScheme.shadow),
                                  ),
                                )
                              ]);
                        });
                  }
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: themeData.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Login',
                      style: GoogleFonts.spaceMono(
                          color: themeData.colorScheme.tertiary, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: GoogleFonts.spaceMono(
                      color: themeData.colorScheme.primary),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: Text(
                    'Register Here!',
                    style: GoogleFonts.spaceMono(
                        color: themeData.colorScheme.shadow,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _verifyEmailPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String errorMessage =
        'An Error has occured. Please try again after some time.';
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect Password';
      }
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(
                  'Error',
                  style: GoogleFonts.spaceMono(),
                ),
                content: Text(
                  errorMessage,
                  style: GoogleFonts.spaceMono(
                      color: themeData.colorScheme.primary),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: GoogleFonts.spaceMono(
                          color: themeData.colorScheme.shadow),
                    ),
                  )
                ]);
          });
    }
  }
}
