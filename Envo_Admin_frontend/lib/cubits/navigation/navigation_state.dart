part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  NavigationState(this.index);
  int index;
  @override
  List<Object> get props => [index];
}

class NavigationChanged extends NavigationState {
  NavigationChanged(int index) : super(index);
  @override
  List<Object> get props => [index];
}
