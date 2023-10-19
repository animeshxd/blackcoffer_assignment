import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'consts.dart';
import 'widgets/main_app_body.dart';
import 'widgets/rounded_elevated_button.dart';

void main() => runApp(const MyApp());

enum VideoState { initial, resumed, paused }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: mainThemeData,
      home: VideoRecordPage(),
    );
  }
}

class VideoRecordPage extends StatelessWidget {
  VideoRecordPage({
    super.key,
  });
  final videoState = VideoState.initial.obs;

  void onPostButtonCLicked() {}

  void onRecordClicked() {
    videoState.value = videoState.value == VideoState.paused
        ? VideoState.resumed
        : VideoState.paused;
  }
  void onSwitchCameraClicked() {}

  
  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.of(context).size;
    return MainAppBody(
      body: Column(
        children: [
          Placeholder(
            fallbackHeight: viewSize.height * .4,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RecorderController(
              onRecordClicked: onRecordClicked,
              onSwitchCameraClicked: onSwitchCameraClicked,
              state: videoState,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
      floatingActionButton: Obx(() {
        return SizedBox(
          width: 70,
          child: RoundedElevatedTextButton(
            text: 'Post',
            onPressed: videoState.value == VideoState.initial
                ? null
                : onPostButtonCLicked,
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class RecorderController extends StatelessWidget {
  const RecorderController({
    super.key,
    required this.onRecordClicked,
    required this.onSwitchCameraClicked,
    required this.state,
  });
  final void Function() onRecordClicked;
  final void Function() onSwitchCameraClicked;
  final Rx<VideoState> state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(child: SizedBox.shrink()),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: mainColorScheme.primary,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: onRecordClicked,
            child: Obx(() {
              final icon = switch (state.value) {
                VideoState.paused => Icons.pause,
                VideoState.resumed => Icons.play_arrow,
                _ => Icons.videocam
              };
              return Icon(
                icon,
                color: Colors.white,
                size: 35,
              );
            }),
          ),
        ),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              side: BorderSide(
                width: 3,
                color: mainColorScheme.primary,
              ),
              padding: const EdgeInsets.all(15),
            ),
            onPressed: onSwitchCameraClicked,
            child: const Icon(Icons.sync),
          ),
        ),
      ],
    );
  }
}
