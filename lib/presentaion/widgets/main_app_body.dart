import 'package:flutter/material.dart';
import 'app_buttom_navigation_bar.dart';
import 'home_screen_app_bar.dart';

class MainAppBody extends StatelessWidget {
  const MainAppBody({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeScreenAppBar(
        onNotificationActionClicked: () {},
      ),
      body: body,
      bottomNavigationBar: AppButtomNavigationBar(
        onExploreClicked: () {},
        onVideoAddClicked: () {},
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
