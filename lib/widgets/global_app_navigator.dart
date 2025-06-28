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

enum _NavigatorType { rail, bar }

class GlobalAppNavigatorModel with ChangeNotifier {
  final List<GlobalAppNavigatorDestination> destinations;
  final Duration duration;
  final Curve curve;

  int get selectedIndex => _selectedIndex;
  PageController get pageController => _pageController;

  PageController _pageController = PageController();
  int _selectedIndex = 0;
  _NavigatorType? _type;

  GlobalAppNavigatorModel({
    required this.destinations,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
    pageController.animateToPage(value, duration: duration, curve: curve);
  }
}

enum GlobalAppNavigatorLabelVisibility { hidden, show, showSelected }

class GlobalAppNavigator extends StatelessWidget {
  final GlobalAppNavigatorLabelVisibility labelVisibility;

  const GlobalAppNavigator({
    super.key,
    this.labelVisibility = GlobalAppNavigatorLabelVisibility.showSelected,
  });

  Widget _buildPageView(
    BuildContext context,
    GlobalAppNavigatorModel value,
    Axis scrollDirection,
  ) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: scrollDirection,
      controller: value.pageController,
      children: List.generate(value.destinations.length, (index) {
        return value.destinations[index].body;
      }),
    );
  }

  Widget _buildNavigationRail(BuildContext context, _NavigatorType type) {
    final labelType = switch (labelVisibility) {
      GlobalAppNavigatorLabelVisibility.hidden => NavigationRailLabelType.none,
      GlobalAppNavigatorLabelVisibility.show => NavigationRailLabelType.all,
      GlobalAppNavigatorLabelVisibility.showSelected =>
        NavigationRailLabelType.selected,
    };
    final model = Provider.of<GlobalAppNavigatorModel>(context, listen: false);

    if (model._type != type) {
      model._type = type;
      model._pageController = PageController(initialPage: model.selectedIndex);
    }

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
                onDestinationSelected: (value) => model.selectedIndex = value,
                labelType: labelType,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              ),
              Expanded(child: _buildPageView(context, value, Axis.vertical)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationBar(BuildContext context, _NavigatorType type) {
    final labelBehavior = switch (labelVisibility) {
      GlobalAppNavigatorLabelVisibility.hidden =>
        NavigationDestinationLabelBehavior.alwaysHide,
      GlobalAppNavigatorLabelVisibility.show =>
        NavigationDestinationLabelBehavior.alwaysShow,
      GlobalAppNavigatorLabelVisibility.showSelected =>
        NavigationDestinationLabelBehavior.onlyShowSelected,
    };
    final model = Provider.of<GlobalAppNavigatorModel>(context, listen: false);

    if (model._type != type) {
      model._type = type;
      model._pageController = PageController(initialPage: model.selectedIndex);
    }

    return Consumer<GlobalAppNavigatorModel>(
      builder: (context, value, child) {
        return Scaffold(
          body: _buildPageView(context, value, Axis.horizontal),
          bottomNavigationBar: NavigationBar(
            destinations: List.generate(value.destinations.length, (index) {
              return NavigationDestination(
                icon: Icon(value.destinations[index].icon),
                label: value.destinations[index].label,
                tooltip: value.destinations[index].label,
              );
            }),
            selectedIndex: value.selectedIndex,
            onDestinationSelected: (value) => model.selectedIndex = value,
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
      return _buildNavigationRail(context, _NavigatorType.rail);
    } else {
      return _buildNavigationBar(context, _NavigatorType.bar);
    }
  }
}
