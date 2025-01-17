import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: const Text(
          'Settings',
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // dark mode
          Text(
            "Dark Mode",
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          // switch toggle
          CupertinoSwitch(
            value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
        ],
      ),
    );
  }
}
