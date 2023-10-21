import 'package:blackcoffer_assignment/presentaion/video_record_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        onVideoAddClicked: () => onVideoAddClicked(context),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  void onVideoAddClicked(BuildContext context) =>
      context.replace(VideoRecordPage.path);
}
