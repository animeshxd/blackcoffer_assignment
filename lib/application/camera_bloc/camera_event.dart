part of 'camera_bloc.dart';

sealed class CameraEvent  {
  const CameraEvent();

}

/// Checks Avalable Camera
///
/// Returns [CameraNotFound] if camera not available
/// Returns [CameraFound] for success
final class CheckAvailableCamera extends CameraEvent {}

/// Dispose Avalable Camera
final class DisposeCurrentController extends CameraEvent {
  const DisposeCurrentController();
}

/// Initilize Avalable Camera
///
/// Returns [CameraInitializationFailed] if camera not available
/// Returns [CameraInitializationSuccess] for success
final class InitializeCamera extends CameraEvent {
  const InitializeCamera();
}

/// Switch Avalable Camera
final class SwitchCamera extends CameraEvent {
  const SwitchCamera();
}

/// Start Video Recorder
///
/// Returns [VideoRecorderStarted]
final class StartVideoRecorder extends CameraEvent {}

/// Stop Video Recorder
///
/// Returns [VideoRecorderStarted]
final class StopVideoRecorder extends CameraEvent {}

/// Pause Video Recorder
///
/// Returns [VideoRecorderPaused]
final class PauseVideoRecorder extends CameraEvent {}

/// Resume Video Recorder
///
/// Returns [VideoRecorderResumed]
final class ResumeVideoRecorder extends CameraEvent {}

/// Returns [VideoRecorderPaused], [VideoRecorderResumed], [VideoRecorderStarted]
final class ToggleVideoRecorder extends CameraEvent {}
