import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../application/post/post_cubit.dart';
import '../core/utils.dart';
import '../domain/entity/post/firebase_post.dart';
import 'consts.dart';
import 'video_player_page.dart';
import 'widgets/auth_aware.dart';
import 'widgets/main_app_body.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mainThemeData,
      home: const HomePage(
        params: HomePageParams(),
      ),
    );
  }
}

class HomePageParams {
  final bool isLibrary;
  final String? uid;

  const HomePageParams({this.isLibrary = false, this.uid});
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.params = const HomePageParams(),
  });

  /// extra HomePageParams
  static const path = '/';
  final HomePageParams params;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.params.isLibrary) {
      getPosts(context);
    } else {
      getAllPosts(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainAppBody(
      body: AuthAware(
        child: RefreshIndicator(
          onRefresh: () async => refreshPostList(context),
          child: BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ListPostFailed) {
                return const Center(
                  child: Text(
                    'Failed to fetch list of posts',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                );
              }
              if (state is ListPostSuccess) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    var post = state.posts[index];
                    return VideoWidget(
                      title: post.title,
                      location: post.hLocation,
                      username: post.username,
                      views: '1M',
                      uploadedTime: formatDateOfCreatedAt(post.createdAt),
                      category: post.category,
                      thumbnail: post.thumbnail,
                      onClick: () => onViewVideo(context, post),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      onExploreClicked: onExploreClicked,
      onViewLibraryClicked: onViewLibraryClicked,
    );
  }

  void onViewNotificationClicked() {}

  onViewVideo(BuildContext context, FPost post) =>
      context.push(VideoPlayerPage.path, extra: post);

  // void onAddNewPost(BuildContext context) => context.go(VideoRecordPage.path);

  void onViewLibraryClicked() {
    getPosts(context);
  }

  void onExploreClicked() {
    getAllPosts(context);
  }

  void refreshPostList(BuildContext context) {
    if (widget.params.isLibrary) {
      getPosts(context);
    } else {
      getAllPosts(context);
    }
  }

  void getPosts(BuildContext context) {
    context.read<PostCubit>().getPosts(widget.params.uid);
  }

  void getAllPosts(BuildContext context) {
    context.read<PostCubit>().getAllPosts();
  }
}

class VideoWidget extends StatelessWidget {
  const VideoWidget({
    super.key,
    required this.title,
    required this.username,
    required this.views,
    required this.uploadedTime,
    required this.category,
    required this.location,
    required this.thumbnail,
    required this.onClick,
  });

  final String title;
  final String location;
  final String username;
  final String views;
  final String uploadedTime;
  final String category;
  final String thumbnail;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onClick,
      child: Card(
        child: Column(
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(thumbnail), fit: BoxFit.cover),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(),
              titleAlignment: ListTileTitleAlignment.threeLine,
              titleTextStyle: textTheme.titleSmall,
              subtitleTextStyle: textTheme.bodySmall,
              title: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(title),
                  const Text(' '),
                  Text(location),
                ],
              ),
              subtitle: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "@$username\n",
                      style: textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: "$views views"),
                    const TextSpan(text: " • "),
                    TextSpan(text: uploadedTime),
                    const TextSpan(text: " • "),
                    TextSpan(text: category),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
