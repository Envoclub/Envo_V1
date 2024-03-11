part of 'linechart_cubit.dart';

abstract class LinechartState extends Equatable {
  const LinechartState();

  @override
  List<Object> get props => [];
}

class LineChartLoading extends LinechartState {}

class LineChartLoaded extends LinechartState {
  List<Co2SavedLast7Day> data;
  LineChartLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class LineChartError extends LinechartState {
  String error;
  LineChartError(this.error);
  @override
  List<String> get props => [error];
}
