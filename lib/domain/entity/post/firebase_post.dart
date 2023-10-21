import 'package:cloud_firestore/cloud_firestore.dart';

class FPost {
  final GeoPoint location;
  final String hLocation;
  final String video;
  final String thumbnail;
  final String title;
  final String category;
  final String uid;
  final String username;
  final Timestamp createdAt;

  FPost({
    required this.location,
    required this.hLocation,
    required this.video,
    required this.thumbnail,
    required this.title,
    required this.category,
    required this.uid,
    required this.username,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'hLocation': hLocation,
      'video': video,
      'thumbnail': thumbnail,
      'title': title,
      'category': category,
      'uid': uid,
      'username': username,
      'createdAt': createdAt,
    };
  }

  factory FPost.fromMap(Map<String, dynamic> map) {
    final location = map['location'];
    return FPost(
        location: GeoPoint(location.latitude, location.longitude),
        hLocation: map['hLocation']!,
        video: map['video']!,
        thumbnail: map['thumbnail']!,
        title: map['title']!,
        category: map['category']!,
        uid: map['uid']!,
        username: map['username']!,
        createdAt: map['createdAt']);
  }
}
