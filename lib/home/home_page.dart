import 'package:chat_app_demo/chat/users.dart';
import 'package:chat_app_demo/login/login_page.dart';
import 'package:chat_app_demo/provider/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_demo/settings/settings.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.tertiary,
        iconTheme: IconThemeData(color: themeData.colorScheme.shadow),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Home Page',
          style: themeData.textTheme.titleLarge
              ?.copyWith(color: themeData.colorScheme.shadow),
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
                style: themeData.textTheme.titleLarge?.copyWith(
                  color: themeData.colorScheme.shadow,
                  fontSize: 28,
                ),
              ),
              ListTile(
                title: Text(
                  'Home',
                  style: themeData.textTheme.titleLarge?.copyWith(fontSize: 20),
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
                  style: themeData.textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                trailing: Icon(
                  Icons.settings,
                  color: themeData.colorScheme.primary,
                ),
              ),
              const Spacer(flex: 2),
              ListTile(
                title: Text(
                  'Log Out',
                  style: themeData.textTheme.titleLarge?.copyWith(
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
