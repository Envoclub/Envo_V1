part of 'actions_cubit.dart';

abstract class ActionsState extends Equatable {
  const ActionsState();

  @override
  List<Object> get props => [];
}

class ActionsLoading extends ActionsState {}
class ActionsLoaded extends ActionsState{
  final List<PostActions> actions;
  ActionsLoaded(this.actions);
}
class ActionsError extends ActionsState{
  final String error;
  ActionsError(this.error);
}

