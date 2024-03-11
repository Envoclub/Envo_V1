import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/posts.dart';
import '../../repositories/post_repository.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostRepository _repository;

  PostsCubit(PostRepository repository)
      : _repository = repository,
        super(PostsLoading());

  getData() async {
    try {
      emit(PostsLoading());
      List<Post> data = await _repository.getAllPosts();
      emit(PostsLoaded(data));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  verifyPost(Post post) async {
    try {
      List<Post> tempPosts = [];
      if (state is PostsLoaded) {
        List<Post>? posts = (state as PostsLoaded).posts;
        int index = posts.indexWhere((element) => element.pk == post.pk);
        if (posts[index].active != true) {
          posts[index] = posts[index].copyWith(active: true);
        } else {
          posts[index] = posts[index].copyWith(active: false);
        }
        tempPosts = [...posts];
      }

      await _repository.verify(post);
      emit(PostsLoaded(tempPosts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }
}
