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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _useDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter StatefulWidget")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Currently using "),
                  Text(
                    _useDarkMode ? "dark" : "light",
                    textScaler: TextScaler.linear(1.25),
                  ),
                  Text(" mode"),
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _useDarkMode = !_useDarkMode;
                  });
                },
                child: Text("Toggle Theme"),
              ),
            ],
          ),
        ),
      ),
      theme: _useDarkMode ? ThemeData.dark() : ThemeData.light(),
    );
  }
}
