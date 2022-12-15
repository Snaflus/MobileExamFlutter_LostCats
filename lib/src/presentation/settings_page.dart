import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/register_page.dart';
import 'package:settings_ui/settings_ui.dart';

import '../data/firebase_providers.dart';
import '../domain/cat.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: const [PopupMenu()],
      ),
      body: SettingsList(

        brightness: Brightness.dark,
        sections: [
          SettingsSection(
            title: const Text('Section 1'),
            tiles: [
              SettingsTile(
                title: const Text('Language'),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: const Text('Use System Theme'),
                leading: const Icon(Icons.phone_android),
                initialValue: true,
                onToggle: (value) {
                  setState(() {

                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Section 2'),
            tiles: [
              SettingsTile(
                title: const Text('Security'),
                leading: const Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: const Text('Use fingerprint'),
                leading: const Icon(Icons.fingerprint),
                initialValue: false,
                onToggle: (value) {
                  setState(() {

                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
