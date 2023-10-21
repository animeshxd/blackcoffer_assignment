part of 'post_cubit.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostSubmitSuccessful extends PostState {
  final FPost post;
  final String id;
  const PostSubmitSuccessful({required this.id, required this.post});
}

final class PostSubmitFailed extends PostState {}

final class PostListAllSuccess extends PostState {}

final class PostListAllFailed extends PostState {}

final class ListPostSuccess extends PostState {
  final List<FPost> posts;

  const ListPostSuccess({this.posts = const []});
}

final class ListPostFailed extends PostState {}
