import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../core/utils.dart';
import '../domain/entity/post/firebase_post.dart';
import 'consts.dart';
import 'home_page.dart';
import 'video_record_page.dart';
import 'widgets/app_buttom_navigation_bar.dart';
import 'widgets/home_screen_app_bar.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Material App',
//       theme: mainThemeData,
//       home: const VideoPlayerPage(),
//     );
//   }
// }

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    super.key,
    required this.post,
  });
  final FPost post;
  static const path = '/view_post';
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    var url = 'assets/videos/video.mp4';
    _controller = VideoPlayerController.asset(
      url,
    )
      ..initialize().then((value) => setState(() {}))
      ..setLooping(true)
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
          future: null,
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  title: const Text('Flyin'),
                  pinned: true,
                  bottom: SearchBarWithFilter(),
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
                  delegate:
                      MySliverPersistentVideoPlayer(controller: _controller),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    VideoInfo(post: widget.post),
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
            );
          }),
      bottomNavigationBar: AppButtomNavigationBar(
        onExploreClicked: onExploreClicked,
        onVideoAddClicked: onVideoAddClicked,
      ),
    );
  }

  void onVideoAddClicked() {
    context.replace(VideoRecordPage.path);
  }

  void onExploreClicked() {
    context.replace(HomePage.path);
  }

  void _onNotificationActionClicked() {}
}

class VideoInfo extends StatelessWidget {
  const VideoInfo({super.key, required this.post});

  final FPost post;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          post.title,
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
            Text(formatDateOfCreatedAt(post.createdAt)),
            Text(post.category),
          ],
        ),
        const SizedBox(height: 5),
        ListTile(
          leading: const CircleAvatar(),
          title: Text(post.username),
          trailing: TextButton(
            onPressed: () => onViewAllVideoRequested(context),
            child: const Text('View all video'),
          ),
        ),
      ],
    );
  }

  void onViewAllVideoRequested(BuildContext context) {
    context.push(
      HomePage.path,
      extra: HomePageParams(isLibrary: true, uid: post.uid),
    );
  }
}

class MySliverPersistentVideoPlayer extends SliverPersistentHeaderDelegate {
  final VideoPlayerController controller;

  MySliverPersistentVideoPlayer({required this.controller});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: mainThemeData.colorScheme.background,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
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
