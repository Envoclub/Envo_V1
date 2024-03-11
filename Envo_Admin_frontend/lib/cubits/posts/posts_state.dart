part of 'posts_cubit.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;
  DateTime time = DateTime.now();
  PostsLoaded(this.posts);
  @override
  List<Object> get props => [posts, time];
}

class PostsError extends PostsState {
  final String error;
  PostsError(this.error);
}
