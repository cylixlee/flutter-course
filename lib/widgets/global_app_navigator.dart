import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class GlobalAppNavigatorDestination {
  final String label;
  final IconData icon;
  final Widget body;

  const GlobalAppNavigatorDestination({
    required this.label,
    required this.icon,
    required this.body,
  });
}

class GlobalAppNavigatorModel with ChangeNotifier {
  final List<GlobalAppNavigatorDestination> destinations;
  int _selectedIndex = 0;

  GlobalAppNavigatorModel({required this.destinations});

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}

enum GlobalAppNavigatorLabelVisibility { hidden, show, showSelected }

class GlobalAppNavigator extends StatelessWidget {
  final GlobalAppNavigatorLabelVisibility labelVisibility;

  const GlobalAppNavigator({
    super.key,
    this.labelVisibility = GlobalAppNavigatorLabelVisibility.showSelected,
  });

  Widget _buildNavigationRail(BuildContext context) {
    final labelType = switch (labelVisibility) {
      GlobalAppNavigatorLabelVisibility.hidden => NavigationRailLabelType.none,
      GlobalAppNavigatorLabelVisibility.show => NavigationRailLabelType.all,
      GlobalAppNavigatorLabelVisibility.showSelected =>
        NavigationRailLabelType.selected,
    };

    return Consumer<GlobalAppNavigatorModel>(
      builder: (context, value, child) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                destinations: List.generate(value.destinations.length, (index) {
                  return NavigationRailDestination(
                    icon: Icon(value.destinations[index].icon),
                    label: Text(value.destinations[index].label),
                  );
                }),
                selectedIndex: value.selectedIndex,
                onDestinationSelected: (value) {
                  final model = Provider.of<GlobalAppNavigatorModel>(
                    context,
                    listen: false,
                  );
                  model.selectedIndex = value;
                },
                labelType: labelType,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              ),
              Expanded(child: value.destinations[value.selectedIndex].body),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final labelBehavior = switch (labelVisibility) {
      GlobalAppNavigatorLabelVisibility.hidden =>
        NavigationDestinationLabelBehavior.alwaysHide,
      GlobalAppNavigatorLabelVisibility.show =>
        NavigationDestinationLabelBehavior.alwaysShow,
      GlobalAppNavigatorLabelVisibility.showSelected =>
        NavigationDestinationLabelBehavior.onlyShowSelected,
    };

    return Consumer<GlobalAppNavigatorModel>(
      builder: (context, value, child) {
        return Scaffold(
          body: value.destinations[value.selectedIndex].body,
          bottomNavigationBar: NavigationBar(
            destinations: List.generate(value.destinations.length, (index) {
              return NavigationDestination(
                icon: Icon(value.destinations[index].icon),
                label: value.destinations[index].label,
                tooltip: value.destinations[index].label,
              );
            }),
            selectedIndex: value.selectedIndex,
            onDestinationSelected: (value) {
              final model = Provider.of<GlobalAppNavigatorModel>(
                context,
                listen: false,
              );
              model.selectedIndex = value;
            },
            labelBehavior: labelBehavior,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.size.width >= 600) {
      return _buildNavigationRail(context);
    } else {
      return _buildNavigationBar(context);
    }
  }
}
