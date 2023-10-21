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

final class PostListUserSuccess extends PostState {}

final class PostListUserFailed extends PostState {}
