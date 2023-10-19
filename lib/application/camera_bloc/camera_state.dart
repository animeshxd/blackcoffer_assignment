part of 'camera_bloc.dart';

sealed class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

final class CameraInitial extends CameraState {}

final class CameraNotFound extends CameraState {}

final class CameraFound extends CameraState {
  final List<CameraDescription> cameras;

  const CameraFound({required this.cameras});

  @override
  List<Object> get props => [cameras.length];
}

final class CameraInitializationFailed extends CameraFound {
  final String reason;

  const CameraInitializationFailed({
    required super.cameras,
    required this.reason,
  });
}

final class CameraInitializationSuccess extends CameraFound {
  final CameraController controller;

  const CameraInitializationSuccess({
    required super.cameras,
    required this.controller,
  });
}

final class VideoRecorderPaused extends CameraInitializationSuccess {
  const VideoRecorderPaused({
    required super.cameras,
    required super.controller,
  });
}

final class VideoRecorderStarted extends CameraInitializationSuccess {
  const VideoRecorderStarted({
    required super.cameras,
    required super.controller,
  });
}

final class VideoRecorderResumed extends CameraInitializationSuccess {
  const VideoRecorderResumed({
    required super.cameras,
    required super.controller,
  });
}

final class VideoRecorderStopped extends CameraState {
  final XFile video;
  final XFile thumbnail;

  const VideoRecorderStopped({required this.video, required this.thumbnail});
}
