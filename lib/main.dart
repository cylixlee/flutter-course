import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_course/pages/home_page.dart';
import 'package:flutter_course/pages/profile_page.dart';
import 'package:flutter_course/widgets/global_app_navigator.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // We does not support Web platform, so we'll just ignore the `kIsWeb`
  // condition.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize window manager.
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    // Apply window options.
    const windowOptions = WindowOptions(
      title: "Flutter Course",
      size: Size(500, 900),
    );
    windowManager.waitUntilReadyToShow(windowOptions);
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => HomePageModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GlobalAppNavigator(
        destinations: const [
          GlobalAppNavigatorDestination(
            label: 'Home',
            icon: Icons.home,
            body: HomePage(),
          ),
          GlobalAppNavigatorDestination(
            label: 'Profile',
            icon: Icons.person,
            body: ProfilePage(),
          ),
        ],
      ),
    );
  }
}
