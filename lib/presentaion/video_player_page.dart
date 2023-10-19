import 'package:flutter/material.dart';

import 'consts.dart';
import 'widgets/app_buttom_navigation_bar.dart';
import 'widgets/home_screen_app_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: mainThemeData,
      home: const VideoPlayerPage(),
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  const VideoPlayerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Flyin'),
            pinned: true,
            bottom: SearchBarWithFilter(
              preferredSize: const Size(150, 20),
            ),
            actions: [
              IconButton(
                onPressed: _onNotificationActionClicked,
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 18,
                ),
              )
            ],
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: MySliverPersistentVideoPlayer(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const VideoInfo(
                category: 'Sports',
                userFullName: 'A User',
                relativeTime: '1 days ago',
                videoTitle: 'Title 1',
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Comments',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
          ),
          const SliverFillRemaining()
        ],
      ),
      bottomNavigationBar: AppButtomNavigationBar(
        onExploreClicked: () {},
        onVideoAddClicked: () {},
      ),
    );
  }

  void _onNotificationActionClicked() {}
}

class VideoInfo extends StatelessWidget {
  const VideoInfo({
    Key? key,
    required this.category,
    required this.userFullName,
    required this.relativeTime,
    required this.videoTitle,
  }) : super(key: key);
  final String videoTitle;
  final String relativeTime;
  final String category;
  final String userFullName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          videoTitle,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.thumb_up_alt),
              onPressed: null,
              label: const Text('100'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.thumb_down_alt),
              onPressed: null,
              label: const Text('50'),
            ),
            const IconButton(
              icon: Icon(Icons.share),
              onPressed: null,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('1 views'),
            Text(relativeTime),
            Text(category),
          ],
        ),
        const SizedBox(height: 5),
        ListTile(
          leading: const CircleAvatar(),
          title: Text(userFullName),
          trailing: TextButton(
            onPressed: onViewAllVideoRequested,
            child: const Text('View all video'),
          ),
        ),
      ],
    );
  }

  void onViewAllVideoRequested() {}
}

class MySliverPersistentVideoPlayer extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
