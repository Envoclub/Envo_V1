part of 'piechart_cubit.dart';

abstract class PiechartState extends Equatable {
  const PiechartState();

  @override
  List<Object> get props => [];
}

class PieChartLoading extends PiechartState {}

class PieChartLoaded extends PiechartState {
  List<PieChartApiData> data;
  PieChartLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class PieChartError extends PiechartState {
  String error;
  PieChartError(this.error);
  @override
  List<String> get props => [error];
}
