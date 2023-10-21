import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final List<CameraDescription> cameras = [];
  CameraController? cameraController;
  int currentCamera = 0;

  CameraBloc() : super(CameraInitial()) {
    on<CheckAvailableCamera>((event, emit) async {
      final state = await checkAvailableCameras();
      if (state is CameraFound) {
        cameras.clear();
        cameras.addAll(state.cameras);
      }
      emit(state);
    });

    on<InitializeCamera>((event, emit) async {
      cameraController ??= CameraController(
        cameras[currentCamera],
        ResolutionPreset.medium,
      );
      emit(await initializeCamera(cameraController!, cameras));
    });
    on<SwitchCamera>((event, emit) {
      if (cameraController?.value.isInitialized == false) return;
      if (cameras.length <= 1) return;

      if (currentCamera == cameras.length - 1) {
        currentCamera = -1;
      }
      debugPrint('switched');
      cameraController?.setDescription(cameras[++currentCamera]);
    });
    on<DisposeCurrentController>((event, emit) async {
      if (cameraController?.value.isInitialized == false) return;
      await cameraController?.dispose();
    });
    on<PauseVideoRecorder>((event, emit) async {
      if (cameraController?.value.isRecordingPaused == true) return;

      await cameraController
          ?.pauseVideoRecording()
          .onError((error, stackTrace) => null);
      emit(VideoRecorderPaused(
        cameras: cameras,
        controller: cameraController!,
      ));
    });
    on<ResumeVideoRecorder>((event, emit) async {
      if (cameraController?.value.isRecordingPaused == false) return;


      await cameraController?.resumeVideoRecording()
      .onError((error, stackTrace) => null);
      emit(VideoRecorderResumed(
        cameras: cameras,
        controller: cameraController!,
      ));
    });
    on<StartVideoRecorder>((event, emit) async {
      if (cameraController?.value.isRecordingVideo == true) return;

      await cameraController
          ?.startVideoRecording()
          .onError((error, stackTrace) => null);
      emit(VideoRecorderStarted(
        cameras: cameras,
        controller: cameraController!,
      ));
    });
    on<StopVideoRecorder>((event, emit) async {
      if (cameraController?.value.isRecordingVideo == false) return;
      try {
        var video = await cameraController?.stopVideoRecording();
        var thumbnail = await cameraController?.takePicture();
        if (video == null || thumbnail == null) return;
        emit(VideoRecorderStopped(video: video, thumbnail: thumbnail));
      } on CameraException catch (_) {}
    });

    on<ToggleVideoRecorder>((event, emit) {
      if (cameraController?.value.isRecordingVideo == false) {
        return add(StartVideoRecorder());
      }
      if (cameraController?.value.isRecordingPaused == true) {
        return add(ResumeVideoRecorder());
      } else {
        return add(PauseVideoRecorder());
      }
    });
  }

  @override
  void onEvent(CameraEvent event) {
    super.onEvent(event);
    debugPrint(event.toString());
  }

  @override
  void onChange(Change<CameraState> change) {
    super.onChange(change);
    debugPrint(change.toString());
  }
}

Future<CameraState> initializeCamera(
  CameraController controller,
  List<CameraDescription> cameras,
) async {
  String reason = 'Unexpected Error Occurred';
  try {
    if (!controller.value.isInitialized) await controller.initialize();
    return CameraInitializationSuccess(
      cameras: cameras,
      controller: controller,
    );
  } on CameraException catch (e) {
    if (kDebugMode) {
      reason = e.description ?? e.code;
    } else {
      reason = 'The camera access permission is restricted';
    }
  }
  return CameraInitializationFailed(cameras: cameras, reason: reason);
}

Future<CameraState> checkAvailableCameras() async {
  var cameras = await availableCameras().onError((error, stackTrace) => []);
  if (cameras.isEmpty) {
    return CameraNotFound();
  } else {
    return CameraFound(cameras: cameras);
  }
}
