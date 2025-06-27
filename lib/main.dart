import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_course/pages/home_page.dart';
import 'package:flutter_course/widgets/navigation_bar_app.dart';
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

  final destinations = [
    const NavigationBarAppDestination(
      label: 'Home',
      icon: Icons.home,
      child: HomePage(),
    ),
    const NavigationBarAppDestination(
      label: 'Profile',
      icon: Icons.person,
      child: Center(child: Text('Profile')),
    ),
  ];

  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationBarAppModel(destinations: destinations),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationBarApp());
  }
}
