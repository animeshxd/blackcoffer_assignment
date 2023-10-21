import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../application/post/post_cubit.dart';
import '../core/utils.dart';
import 'consts.dart';
import 'video_record_page.dart';
import 'widgets/app_buttom_navigation_bar.dart';
import 'widgets/auth_aware.dart';
import 'widgets/home_screen_app_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mainThemeData,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.isLibrary = false});
  static const path = '/home';
  final bool isLibrary;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.isLibrary) {
      context.read<PostCubit>().getOwnedPosts();
    } else {
      context.read<PostCubit>().getAllPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeScreenAppBar(
        bottom: SearchBarWithFilter(
          preferredSize: const Size(150, 20),
        ),
        onNotificationActionClicked: onViewNotificationClicked,
      ),
      body: AuthAware(
        child: RefreshIndicator(
          onRefresh: () async => refreshPostList(context),
          child: BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
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
                      uploadedTime: formatDateOfLastMessage(post.createdAt),
                      category: post.category,
                      thumbnail: post.thumbnail,
                    );
                  },
                  // children: const [
                  //   VideoWidget(
                  //     title: "Video TItle long long long  #1",
                  //     location: "WB",
                  //     username: '@username',
                  //     views: '1M',
                  //     uploadedTime: '4 minutes ago',
                  //     category: "Festival",
                  //     video: Colors.amber,
                  //   ),
                  //   VideoWidget(
                  //     title: "Video TItle #2",
                  //     location: "AP",
                  //     username: '@username',
                  //     views: '1M',
                  //     uploadedTime: '4 minutes ago',
                  //     category: "Politics",
                  //     video: Colors.green,
                  //   ),
                  //   VideoWidget(
                  //     title: "Video TItle #2",
                  //     location: "DL",
                  //     username: '@username',
                  //     views: '1M',
                  //     uploadedTime: '4 minutes ago',
                  //     category: "Sports",
                  //     video: Colors.indigo,
                  //   ),
                  // ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (index) {
      //     switch (index) {
      //       case 0:
      //         onExploreClicked();
      //         debugPrint("Home");
      //       case 1:
      //         _addNewPost();
      //         debugPrint("Add");
      //       case 2:
      //         onViewLibraryClicked();
      //         debugPrint("Library");
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Explore',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add),
      //       label: 'Add',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.video_collection),
      //       label: 'Library',
      //     ),
      //   ],
      // ),
      bottomNavigationBar: AppButtomNavigationBar(
        onExploreClicked: null,
        onVideoAddClicked: () => onAddNewPost(context),
        onViewLibraryClicked: onViewLibraryClicked,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.read<PostCubit>().getOwnedPosts();
      //   },
      //   child: const Text(''),
      // ),
    );
  }

  void onViewNotificationClicked() {}

  void onAddNewPost(BuildContext context) => context.go(VideoRecordPage.path);

  void onViewLibraryClicked() {
    context.read<PostCubit>().getOwnedPosts();
  }

  void onExploreClicked() {}

  void refreshPostList(BuildContext context) {
    if (widget.isLibrary) {
      context.read<PostCubit>().getOwnedPosts();
    } else {
      context.read<PostCubit>().getAllPosts();
    }
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
  });

  final String title;
  final String location;
  final String username;
  final String views;
  final String uploadedTime;
  final String category;
  final String thumbnail;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Card(
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
    );
  }
}
