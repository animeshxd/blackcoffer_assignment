import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/post/firebase_post.dart';
import '../../domain/entity/post/post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required this.storage,
    required this.auth,
    required this.firestore,
  }) : super(PostInitial());

  final FirebaseStorage storage;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  /// Returns [PostLoading], [PostSubmitSuccessful], [PostSubmitFailed]
  void submitPost(Post post) async {
    emit(PostLoading());
    final posts = firestore.collection('posts');
    final uid = auth.currentUser!.uid;
    final doc = posts.doc();
    final ref = storage.ref(uid).child(doc.id);

    final extension = (post.video.mimeType ?? 'video/webm').split('/').last;

    final videoRef = ref.child('video.$extension');
    final thumbnailref = ref.child('thumbnail.jpeg');

    final videoMeta = SettableMetadata(contentType: post.video.mimeType);
    final thumbnailMeta = SettableMetadata(contentType: post.video.mimeType);

    if (kIsWeb) {
      videoRef
          .putData(await post.video.readAsBytes(), videoMeta)
          .catchError(() => emit(PostSubmitFailed()));
      thumbnailref
          .putData(await post.thumbnail.readAsBytes(), thumbnailMeta)
          .catchError(() => emit(PostSubmitFailed()));
    } else {
      await videoRef
          .putFile(File(post.video.path), videoMeta)
          .catchError(() => emit(PostSubmitFailed()));
      await thumbnailref
          .putFile(File(post.thumbnail.path), thumbnailMeta)
          .catchError(() => emit(PostSubmitFailed()));
    }

    final data = FPost(
      location: GeoPoint(post.location.latitude, post.location.longitude),
      hLocation: post.hLocation!,
      video: await videoRef.getDownloadURL(),
      thumbnail: await thumbnailref.getDownloadURL(),
      title: post.title!,
      category: post.category!,
      uid: uid,
    );

    try {
      await doc.set(data.toMap());
      emit(PostSubmitSuccessful(post: data, id: doc.id));
    } on Exception catch (e) {
      debugPrint(e.toString());
      emit(PostSubmitFailed());
    }
  }
}
