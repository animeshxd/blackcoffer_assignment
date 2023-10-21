import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home_page.dart';
import '../video_record_page.dart';
import 'app_buttom_navigation_bar.dart';
import 'home_screen_app_bar.dart';

class MainAppBody extends StatelessWidget {
  const MainAppBody({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.onExploreClicked,
    this.onVideoAddClicked,
    this.onViewLibraryClicked,
    this.disableoExploreClicked = false,
  });

  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final VoidCallback? onExploreClicked;
  final VoidCallback? onVideoAddClicked;
  final VoidCallback? onViewLibraryClicked;
  final bool disableoExploreClicked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeScreenAppBar(
        onNotificationActionClicked: () {},
        bottom: SearchBarWithFilter(),
      ),
      body: body,
      bottomNavigationBar: AppButtomNavigationBar(
        onExploreClicked: disableoExploreClicked
            ? null
            : onExploreClicked ?? () => _onExploreClicked(context),
        onVideoAddClicked:
            onVideoAddClicked ?? () => _onVideoAddClicked(context),
        onViewLibraryClicked: onViewLibraryClicked,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  void _onVideoAddClicked(BuildContext context) =>
      context.replace(VideoRecordPage.path);
  void _onExploreClicked(BuildContext context) =>
      context.replace(HomePage.path);
}
