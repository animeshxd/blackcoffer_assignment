import 'package:flutter/material.dart';

class AppButtomNavigationBar extends StatelessWidget {
  const AppButtomNavigationBar({
    super.key,
    required this.onExploreClicked,
    required this.onVideoAddClicked,
    this.onViewLibraryClicked,
  });
  final void Function()? onExploreClicked;
  final void Function()? onVideoAddClicked;
  final void Function()? onViewLibraryClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: BottomNavigationBarTheme.of(context).backgroundColor,
        border: const Border(top: BorderSide()),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: onExploreClicked,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.home), Text('Explore')],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onVideoAddClicked,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.add), Text('Add')],
              ),
            ),
          ),
          
          Expanded(
            child: Visibility(
              visible: onViewLibraryClicked != null,
              child: InkWell(
                onTap: onViewLibraryClicked,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.video_collection), Text('Library')],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
