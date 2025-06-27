import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MainAppModel(),
      child: const MainApp(),
    ),
  );
}

class MainAppModel with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;
  set counter(int value) {
    _counter = value;
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You have pushed the button this many times:'),
              Consumer<MainAppModel>(
                builder: (context, value, _) {
                  return Text(
                    '${value.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(title: Text('Flutter Demo Home Page')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<MainAppModel>(context, listen: false).counter++;
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
