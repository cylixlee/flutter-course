import 'package:flutter/material.dart';

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

enum GlobalAppNavigatorLabelVisibility { hidden, show, showSelected }

class GlobalAppNavigator extends StatefulWidget {
  final List<GlobalAppNavigatorDestination> destinations;
  final Duration duration;
  final Curve curve;
  final GlobalAppNavigatorLabelVisibility labelVisibility;

  late final List<Widget> _children;

  GlobalAppNavigator({
    super.key,
    required this.destinations,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.labelVisibility = GlobalAppNavigatorLabelVisibility.showSelected,
  }) : _children = destinations.map((e) => e.body).toList();

  @override
  State<GlobalAppNavigator> createState() => _GlobalAppNavigatorState();
}

class _GlobalAppNavigatorState extends State<GlobalAppNavigator> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  _NavigatorType? _type;

  void navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  Widget _buildPageView(BuildContext context, Axis scrollDirection) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: scrollDirection,
      controller: _pageController,
      children: widget._children,
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    final labelType = switch (widget.labelVisibility) {
      GlobalAppNavigatorLabelVisibility.hidden => NavigationRailLabelType.none,
      GlobalAppNavigatorLabelVisibility.show => NavigationRailLabelType.all,
      GlobalAppNavigatorLabelVisibility.showSelected =>
        NavigationRailLabelType.selected,
    };

    if (_type != _NavigatorType.rail) {
      _type = _NavigatorType.rail;
      _pageController = PageController(initialPage: _selectedIndex);
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: List.generate(widget.destinations.length, (index) {
              return NavigationRailDestination(
                icon: Icon(widget.destinations[index].icon),
                label: Text(widget.destinations[index].label),
              );
            }),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => navigateTo(index),
            labelType: labelType,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          ),
          Expanded(child: _buildPageView(context, Axis.vertical)),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final labelBehavior = switch (widget.labelVisibility) {
      GlobalAppNavigatorLabelVisibility.hidden =>
        NavigationDestinationLabelBehavior.alwaysHide,
      GlobalAppNavigatorLabelVisibility.show =>
        NavigationDestinationLabelBehavior.alwaysShow,
      GlobalAppNavigatorLabelVisibility.showSelected =>
        NavigationDestinationLabelBehavior.onlyShowSelected,
    };

    if (_type != _NavigatorType.bar) {
      _type = _NavigatorType.bar;
      _pageController = PageController(initialPage: _selectedIndex);
    }

    return Scaffold(
      body: _buildPageView(context, Axis.horizontal),
      bottomNavigationBar: NavigationBar(
        destinations: List.generate(widget.destinations.length, (index) {
          return NavigationDestination(
            icon: Icon(widget.destinations[index].icon),
            label: widget.destinations[index].label,
            tooltip: widget.destinations[index].label,
          );
        }),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => navigateTo(index),
        labelBehavior: labelBehavior,
      ),
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
