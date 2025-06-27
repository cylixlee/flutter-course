import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // We does not support Web platform, so we'll just ignore the `kIsWeb`
  // condition.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize window manager.
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    // Apply window options.
    final windowOptions = WindowOptions(
      title: "Flutter Course",
      size: Size(500, 900),
    );
    windowManager.waitUntilReadyToShow(windowOptions);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter Material App")),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(child: Text("Drawer Header")),
              ListTile(title: Text("Logout")),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
