import 'package:chat_app_demo/themes/theme_provider.dart';
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
                          isSwitched = value;
                          provider.toggleTheme();
                        });
                      },
                      activeColor: themeData.colorScheme.tertiary,
                      activeTrackColor: themeData.colorScheme.shadow,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
