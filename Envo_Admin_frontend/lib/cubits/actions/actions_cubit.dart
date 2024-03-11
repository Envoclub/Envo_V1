import 'package:bloc/bloc.dart';
import 'package:envo_admin_dashboard/models/action_model.dart';
import 'package:equatable/equatable.dart';


import '../../repositories/post_repository.dart';

part 'actions_state.dart';

class ActionsCubit extends Cubit<ActionsState> {
  PostRepository _repository;

  ActionsCubit(PostRepository repository)
      : _repository = repository,
        super(ActionsLoading());

  getData() async {
    try {
      emit(ActionsLoading());
      List<PostActions> data = await _repository.getAllPostActions();
      emit(ActionsLoaded(data));
    } catch (e) {
      emit(ActionsError(e.toString()));
    }
  }
}
