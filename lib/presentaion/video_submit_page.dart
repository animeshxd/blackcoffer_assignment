import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/location_humanizer/location_humanizer_cubit.dart';
import '../application/post/post_cubit.dart';
import '../domain/entity/post/post.dart';
import 'widgets/main_app_body.dart';
import 'widgets/rounded_elevated_button.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: mainThemeData,
//       title: 'Material App',
//       home: VideoSubmitPage(),
//     );
//   }
// }

class VideoSubmitPage extends StatefulWidget {
  const VideoSubmitPage({super.key, required this.post});

  /// Post as extra
  static const path = '/submit_post';
  final Post post;

  @override
  State<VideoSubmitPage> createState() => _VideoSubmitPageState();
}

class _VideoSubmitPageState extends State<VideoSubmitPage> {
  final TextEditingController titleEditingController = TextEditingController();

  late final TextEditingController locationEditingController =
      TextEditingController(text: 'unknown');

  final TextEditingController categoryEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LocationHumanizerCubit>().invoke(widget.post.location);
  }

  @override
  Widget build(BuildContext context) {
    return MainAppBody(
      body: BlocBuilder<LocationHumanizerCubit, LocationHumanizerState>(
        builder: (context, state) {
          if (state is LocationHumanizerLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LocationHumanizerFailed) {
            var location = widget.post.location;
            // var result = 'lon: ${location.longitude}, lat: ${location.latitude}';
            locationEditingController.text = location.toString();
          }
          if (state is LocationHumanizerLoaded) {
            locationEditingController.text = state.result;
          }
          return BlocConsumer<PostCubit, PostState>(
            listener: (context, state) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();
              if (state is PostSubmitFailed) {
                messenger.showSnackBar(const SnackBar(
                  content: Text('Failed to upload post'),
                ));
              }
              if (state is PostSubmitSuccessful) {
                messenger.showSnackBar(const SnackBar(
                  content: Text('Submit Success'),
                ));
              }
            },
            builder: (context, state) {
              if (state is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      FutureBuilder<Uint8List>(
                        future: widget.post.thumbnail.readAsBytes(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.hasError) {
                            return Container(height: 170, color: Colors.black);
                          }
                          return Container(
                            height: 170,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(snapshot.data!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: titleEditingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                          counterText: '',
                        ),
                        maxLength: 5,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: locationEditingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Location',
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: categoryEditingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Category',
                          counterText: '',
                        ),
                        maxLength: 5,
                      ),
                      const SizedBox(height: 10),
                      RoundedElevatedTextButton(
                        text: 'Post',
                        onPressed: onPostVideoRequested,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onPostVideoRequested() {
    var post = widget.post.copyWith(
      title: titleEditingController.text,
      hLocation: locationEditingController.text,
      category: categoryEditingController.text,
    );
    context.read<PostCubit>().submitPost(post);
  }
}
