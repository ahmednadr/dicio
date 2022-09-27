import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/models/active_user_state.dart';
import 'package:test/models/server.dart';
import 'package:test/models/server_state.dart';
import 'package:test/models/user.dart';
import 'package:test/ui/screens/ScanPage/scan_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ServerConfigAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ServerStateAdapter());
  Hive.registerAdapter(ActiveServerAuthAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const ScanPage(),
      ),
    );
  }
}
