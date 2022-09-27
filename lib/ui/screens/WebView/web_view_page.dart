import 'package:flutter/material.dart';
import 'package:test/ui/screens/SettingsPage/settings_page.dart';

class WebView extends StatelessWidget {
  const WebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("home assistant web view")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => SettingsPage()))),
      ),
    );
  }
}
