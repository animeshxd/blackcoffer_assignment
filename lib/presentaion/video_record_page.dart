import '../domain/entity/post.dart';
import 'video_submit_page.dart';
import 'widgets/auth_aware.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';

import '../application/camera_bloc/camera_bloc.dart';
import '../application/location_cubit/locations_cubit.dart';
import 'consts.dart';
import 'gps_permission_page.dart';
import 'widgets/main_app_body.dart';
import 'widgets/rounded_elevated_button.dart';

// void main() => runApp(const MyApp());

enum VideoState { initial, resumed, paused }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Material App',
//       theme: mainThemeData,
//       home: MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (context) => CameraBloc()),
//           BlocProvider(create: (context) => LocationsCubit()),
//         ],
//         child: const VideoRecordPage(),
//       ),
//     );
//   }
// }

class VideoRecordPage extends StatefulWidget {
  static const path = '/post';

  const VideoRecordPage({super.key});

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage>
    with WidgetsBindingObserver {
  final videoState = VideoState.initial.obs;
  CameraBloc? cameraBloc;

  void onPostButtonCLicked() => cameraBloc?.add(StopVideoRecorder());

  void onRecordClicked() => cameraBloc?.add(ToggleVideoRecorder());

  void onSwitchCameraClicked() => cameraBloc?.add(const SwitchCamera());

  void goToPostPage({
    required BuildContext context,
    required XFile video,
    required XFile thumbnail,
    required Position location,
  }) {
    context.replace(
      VideoSubmitPage.path,
      extra: Post(location: location, video: video, thumbnail: thumbnail),
    );
  }

  Future<Position?> goToGPSPermissionPage(BuildContext context) =>
      context.push<Position>(GPSPermissionPage.path);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      cameraBloc?.add(const DisposeCurrentController());
    } else if (state == AppLifecycleState.resumed) {
      cameraBloc?.add(const InitializeCamera());
    }
  }

  @override
  void initState() {
    super.initState();
    cameraBloc = context.read();
    // cameraBloc?.add(CheckAvailableCamera());
    context.read<LocationsCubit>().getLocation();
  }

  Position? currentPosition;

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.of(context).size;
    return MainAppBody(
      body: AuthAware(
        child: BlocConsumer<LocationsCubit, LocationsState>(
          listener: (context, state) async {
            switch (state) {
              case LocationAskEnableService():
              case LocationAskPermission():
                currentPosition = await goToGPSPermissionPage(context);
                currentPosition!;
                break;
              case LocationGetSuccess():
                cameraBloc?.add(CheckAvailableCamera());
                break;
              case LocationPermanentlyDisabled():
              default:
            }
          },
          builder: (context, state) {
            if (state is LocationPermanentlyDisabled) {
              return const Center(
                child: Text(
                  'Unable to provide service, Location Not Found',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            }
            return BlocConsumer<CameraBloc, CameraState>(
              listener: (context, state) async {
                var messenger = ScaffoldMessenger.maybeOf(context);
                if (state is CameraInitializationFailed) {
                  videoState.value = VideoState.initial;
                  return;
                }
                if (state is CameraInitializationSuccess) {
                  debugPrint(state.toString());
                  var vstate = switch (state) {
                    VideoRecorderPaused() => VideoState.paused,
                    VideoRecorderResumed() => VideoState.resumed,
                    VideoRecorderStarted() => VideoState.resumed,
                    _ => VideoState.initial
                  };
                  videoState.value = vstate;
                  return;
                }

                if (state is VideoRecorderStopped) {
                  var location =
                      currentPosition ?? (await goToGPSPermissionPage(context));
                  if (location == null) {
                    messenger?.showSnackBar(const SnackBar(
                      content: Text(
                        'unable to provide service without location',
                      ),
                    ));
                    return;
                  }
                  if (!context.mounted) return;
                  goToPostPage(
                    context: context,
                    video: state.video,
                    thumbnail: state.thumbnail,
                    location: location,
                  );
                  return;
                }

                if (state is CameraFound) {
                  cameraBloc?.add(const InitializeCamera());
                  return;
                }
              },
              builder: (context, state) {
                if (state is CameraNotFound) {
                  return const Center(
                    child: Text(
                      'Camera not found',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  );
                }
                if (state is CameraFound) {
                  var camHeight = viewSize.height * .65;
                  return SizedBox(
                    height: camHeight,
                    child: Stack(
                      children: [
                        if (state is CameraInitializationFailed)
                          SizedBox(
                            height: camHeight,
                            child: Center(
                              child: Text(
                                state.reason,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        if (state is CameraInitializationSuccess)
                          SizedBox(
                            height: camHeight,
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.hardEdge,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                ),
                                width: 350 * .8,
                                child: CameraPreview(state.controller),
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RecorderController(
                              onRecordClicked: onRecordClicked,
                              onSwitchCameraClicked: onSwitchCameraClicked,
                              state: videoState,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
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
                VideoState.paused => Icons.play_arrow,
                VideoState.resumed => Icons.pause,
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
              backgroundColor: mainColorScheme.primary,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: onSwitchCameraClicked,
            child: const Icon(
              Icons.sync,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
