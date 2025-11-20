part of 'posts_cubit.dart';

sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

final class PostsInitial extends PostsState {
  final List<Post?> posts;

  PostsInitial({this.posts = const []});

  @override
  List<Object> get props => [posts];
}

final class PostsLoading extends PostsState {}

final class PostsLoaded extends PostsState {
  final List<Post?> posts;

  const PostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

final class PostsFailure extends PostsState {
  final String errorMessage;

  const PostsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class PostsCommentsLoaded extends PostsState {
  final List<String> comments;

  const PostsCommentsLoaded(this.comments);

  @override
  List<Object> get props => [comments];
}

final class PostsCommentsFailure extends PostsState {
  final String errorMessage;

  const PostsCommentsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
