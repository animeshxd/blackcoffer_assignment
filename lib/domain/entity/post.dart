import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

class Post {
  final Position location;
  final XFile video;
  final XFile thumbnail;

  String? title;
  String? category;

  Post({
    required this.location,
    required this.video,
    required this.thumbnail,
    this.title,
    this.category,
  });
  

}
