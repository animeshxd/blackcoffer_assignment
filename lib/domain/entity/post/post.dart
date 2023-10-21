import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

class Post {
  final Position location;
  final XFile video;
  final XFile thumbnail;

  final String? title;
  final String? category;
  final String? hLocation;

  Post({
    required this.location,
    required this.video,
    required this.thumbnail,
    this.title,
    this.category,
    this.hLocation,
  });

  Post copyWith({
    Position? location,
    XFile? video,
    XFile? thumbnail,
    String? title,
    String? category,
    String? hLocation,
  }) {
    return Post(
      location: location ?? this.location,
      video: video ?? this.video,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      category: category ?? this.category,
      hLocation: hLocation ?? this.hLocation,
    );
  }
}
