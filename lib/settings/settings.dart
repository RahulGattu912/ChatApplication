import 'package:chat_app_demo/provider/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: themeData.colorScheme.shadow),
            title: Text(
              'Settings',
              style: themeData.textTheme.titleLarge
                  ?.copyWith(color: themeData.colorScheme.shadow),
            ),
            backgroundColor: themeData.colorScheme.tertiary,
          ),
          backgroundColor: themeData.colorScheme.tertiary,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Dark Mode',
                      style: themeData.textTheme.titleLarge?.copyWith(
                          color: themeData.colorScheme.shadow, fontSize: 20),
                    ),
                    const Spacer(),
                    Switch(
                      value: provider.isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          // isSwitched = value;
                          provider.toggleTheme();
                        });
                      },
                      activeColor: themeData.colorScheme.tertiary,
                      activeTrackColor: themeData.colorScheme.shadow,
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _deleteUser();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete, color: Colors.red),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Delete Account',
                          style: themeData.textTheme.titleLarge
                              ?.copyWith(color: Colors.red, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteUser() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
// ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Deleted Successfully')));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to delete account. Please reauthenticate.')),
      );
    }
  }
}
