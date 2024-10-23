import 'package:chat_app_demo/chat/users.dart';
import 'package:chat_app_demo/login/login_page.dart';
import 'package:chat_app_demo/themes/light_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextTheme textTheme = theme;
  ThemeData themeData = lightMode;
  bool _isLoggingOut = false; // To manage loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.tertiary,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Home Page',
          style: textTheme.titleLarge,
        ),
      ),
      backgroundColor: themeData.colorScheme.tertiary,
      drawer: Drawer(
        backgroundColor: themeData.colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text(
                'Welcome,',
                style: textTheme.titleLarge?.copyWith(
                  color: themeData.colorScheme.shadow,
                  fontSize: 28,
                ),
              ),
              ListTile(
                title: Text(
                  'Home',
                  style: textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
                trailing: Icon(
                  Icons.home,
                  color: themeData.colorScheme.primary,
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Settings',
                  style: textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
                trailing: Icon(
                  Icons.settings,
                  color: themeData.colorScheme.primary,
                ),
              ),
              const Spacer(flex: 2),
              ListTile(
                title: Text(
                  'Log Out',
                  style: textTheme.titleLarge?.copyWith(
                      fontSize: 20, color: themeData.colorScheme.shadow),
                ),
                trailing: _isLoggingOut
                    ? CircularProgressIndicator(
                        color: themeData.colorScheme.shadow,
                      )
                    : IconButton(
                        onPressed: () {
                          _signOut();
                        },
                        icon: Icon(
                          Icons.logout,
                          color: themeData.colorScheme.shadow,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: const Users(),
    );
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoggingOut = true; // Start showing loading indicator
    });

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoggingOut = false; // Stop showing loading indicator
      });
    }
  }
}
