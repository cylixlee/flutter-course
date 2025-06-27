import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class NavigationBarAppDestination {
  final String label;
  final IconData icon;
  final Widget child;

  const NavigationBarAppDestination({
    required this.label,
    required this.icon,
    required this.child,
  });
}

class NavigationBarAppModel with ChangeNotifier {
  final List<NavigationBarAppDestination> destinations;
  int _selectedIndex = 0;

  NavigationBarAppModel({required this.destinations});

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationBarAppModel>(
      builder: (context, value, child) {
        return Scaffold(
          body: value.destinations[value.selectedIndex].child,
          bottomNavigationBar: NavigationBar(
            destinations: List.generate(value.destinations.length, (index) {
              final item = value.destinations[index];
              return NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
                tooltip: item.label,
              );
            }),
            selectedIndex: value.selectedIndex,
            onDestinationSelected: (index) {
              final model = Provider.of<NavigationBarAppModel>(
                context,
                listen: false,
              );
              model.selectedIndex = index;
            },
          ),
        );
      },
    );
  }
}
