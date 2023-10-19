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
      debugShowCheckedModeBanner: false,
      theme: mainThemeData,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeScreenAppBar(
        bottom: SearchBarWithFilter(
          preferredSize: const Size(150, 20),
        ),
        onNotificationActionClicked: onViewNotificationClicked,
      ),
      body: ListView(
        children: const [
          VideoWidget(
            title: "Video TItle long long long  #1",
            location: "WB",
            username: '@username',
            views: '1M',
            uploadedTime: '4 minutes ago',
            category: "Festival",
            video: Colors.amber,
          ),
          VideoWidget(
            title: "Video TItle #2",
            location: "AP",
            username: '@username',
            views: '1M',
            uploadedTime: '4 minutes ago',
            category: "Politics",
            video: Colors.green,
          ),
          VideoWidget(
            title: "Video TItle #2",
            location: "DL",
            username: '@username',
            views: '1M',
            uploadedTime: '4 minutes ago',
            category: "Sports",
            video: Colors.indigo,
          ),
        ],
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
        onExploreClicked: onExploreClicked,
        onVideoAddClicked: onAddNewPost,
        onViewLibraryClicked: onViewLibraryClicked,
      ),
    );
  }

  void onViewNotificationClicked() {}
  void onAddNewPost() {}
  void onViewLibraryClicked() {}
  void onExploreClicked() {}
}

class VideoWidget extends StatelessWidget {
  const VideoWidget({
    Key? key,
    required this.title,
    required this.username,
    required this.views,
    required this.uploadedTime,
    required this.category,
    required this.location,
    required this.video,
  }) : super(key: key);

  final String title;
  final String location;
  final String username;
  final String views;
  final String uploadedTime;
  final String category;
  final Color video;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    category;
    return Card(
      child: Column(
        children: [
          Container(color: video, height: 170),
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
                // TextButton(onPressed: () {}, child: Text(location)),
              ],
            ),
            subtitle: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$username\n",
                    style: textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: "$views views"),
                  const TextSpan(text: " • "),
                  TextSpan(text: uploadedTime),
                  const TextSpan(text: " • "),
                  TextSpan(text: category),
                  // WidgetSpan(
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     style: TextButton.styleFrom(

                  //       padding: const EdgeInsets.all(0),
                  //       textStyle: textTheme.bodySmall,
                  //       alignment: Alignment.bottomLeft
                  //     ),
                  //     child: Text(category),
                  //   ),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
