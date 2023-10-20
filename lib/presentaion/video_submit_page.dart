import 'package:flutter/material.dart';

import 'consts.dart';
import 'widgets/main_app_body.dart';
import 'widgets/rounded_elevated_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainThemeData,
      title: 'Material App',
      home: VideoSubmitPage(),
    );
  }
}

class VideoSubmitPage extends StatelessWidget {
  VideoSubmitPage({
    super.key,
  });
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController locationEditingController =
      TextEditingController();
  final TextEditingController categoryEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainAppBody(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Placeholder(fallbackHeight: 170),
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
      ),
    );
  }

  void onPostVideoRequested() {}
}
