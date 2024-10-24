import 'package:chat_app_demo/login/login_page.dart';
import 'package:chat_app_demo/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ThemeData themeData = lightMode;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _isObscure = true;
  bool _isObscure1 = true;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;
    return Scaffold(
      backgroundColor: themeData.colorScheme.tertiary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.app_registration,
              color: themeData.colorScheme.primary,
              size: 48,
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Sign Up to continue', style: themeData.textTheme.titleLarge),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  height: 52,
                  child: TextField(
                    cursorColor: themeData.colorScheme.shadow,
                    style: themeData.textTheme.titleLarge
                        ?.copyWith(color: themeData.colorScheme.shadow),
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: themeData.textTheme.titleLarge,
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
                      cursorColor: themeData.colorScheme.shadow,
                      style: themeData.textTheme.titleLarge
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
                          child: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: themeData.colorScheme.shadow,
                          ),
                        ),
                        hintText: 'Password',
                        hintStyle: themeData.textTheme.titleLarge,
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
              child: SizedBox(
                  height: 52,
                  child: TextField(
                      cursorColor: themeData.colorScheme.shadow,
                      style: themeData.textTheme.titleLarge
                          ?.copyWith(color: themeData.colorScheme.shadow),
                      controller: _confirmPassword,
                      obscureText: _isObscure1,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure1 = !_isObscure1;
                            });
                          },
                          child: Icon(
                            _isObscure1
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: themeData.colorScheme.shadow,
                          ),
                        ),
                        hintText: 'Confirm Password',
                        hintStyle: themeData.textTheme.titleLarge,
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
                  if (_password.text.isEmpty ||
                      _confirmPassword.text.isEmpty ||
                      _email.text.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: themeData.colorScheme.shadow,
                            title: Text(
                              'Error',
                              style: themeData.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: themeData.colorScheme.tertiary),
                            ),
                            content: Text(
                              'Please enter valid details',
                              style: themeData.textTheme.titleLarge?.copyWith(
                                  color: themeData.colorScheme.tertiary),
                            ),
                            actions: [
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        themeData.colorScheme.tertiary)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Close',
                                  style: themeData.textTheme.titleLarge
                                      ?.copyWith(
                                          color: themeData.colorScheme.shadow),
                                ),
                              )
                            ],
                          );
                        });
                  }
                  if (_password.text.isNotEmpty &&
                      _confirmPassword.text.isNotEmpty) {
                    if (_password.text.length < 8 ||
                        _confirmPassword.text.length < 8) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: themeData.colorScheme.shadow,
                          content: Text(
                            'Password length must be greater than 8',
                            style: themeData.textTheme.titleLarge?.copyWith(
                                color: themeData.colorScheme.tertiary),
                          )));
                    }
                    if (_password.text != _confirmPassword.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: themeData.colorScheme.shadow,
                          content: Text(
                            'Passwords do not match',
                            style: themeData.textTheme.titleLarge?.copyWith(
                                color: themeData.colorScheme.tertiary),
                          )));
                    }
                  }

                  _registerUser(
                      context: context,
                      email: _email.text,
                      password: _password.text,
                      themeData: themeData);
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: themeData.colorScheme.shadow,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: themeData.textTheme.titleLarge?.copyWith(
                          fontSize: 16, color: themeData.colorScheme.tertiary),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: themeData.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  },
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: Text(
                    'Login Here!',
                    style: themeData.textTheme.titleLarge?.copyWith(
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

  _registerUser(
      {required BuildContext context,
      required String email,
      required String password,
      required ThemeData themeData}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String errorMessage = 'An error has occurred. Please try again later.';
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // CollectionReference usersRef =
      //     FirebaseFirestore.instance.collection('Users');
      // QuerySnapshot querySnapshot = await usersRef.get();
      // List<DocumentSnapshot> users = querySnapshot.docs;
      // String userId = auth.currentUser!.uid;
      // ignore: collection_methods_unrelated_type
      // if (!users.contains(userId)) {
      // FirebaseFirestore fireStore = FirebaseFirestore.instance;
      // fireStore
      //     .collection('Users')
      //     .doc(auth.currentUser?.uid)
      //     .set({'email': email, 'uid': auth.currentUser?.uid});
      // }
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      fireStore
          .collection('Users')
          .doc(auth.currentUser?.uid)
          .set({'email': email, 'uid': auth.currentUser?.uid});
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: themeData.colorScheme.shadow,
              title: Text(
                'Success',
                style: themeData.textTheme.titleLarge
                    ?.copyWith(color: themeData.colorScheme.shadow),
              ),
              content: Text(
                'Account Created Successfully',
                style: themeData.textTheme.titleLarge,
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          themeData.colorScheme.tertiary)),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  },
                  child: Text(
                    'Login',
                    style: themeData.textTheme.titleLarge
                        ?.copyWith(color: themeData.colorScheme.shadow),
                  ),
                )
              ],
            );
          });
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }

      // Show the error message in a dialog
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: themeData.colorScheme.shadow,
            title: Text(
              'Registration Error',
              style: themeData.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeData.colorScheme.tertiary),
            ),
            content: Text(
              errorMessage,
              style: themeData.textTheme.titleLarge
                  ?.copyWith(color: themeData.colorScheme.tertiary),
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(themeData.colorScheme.tertiary)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: themeData.textTheme.titleLarge
                      ?.copyWith(color: themeData.colorScheme.shadow),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
