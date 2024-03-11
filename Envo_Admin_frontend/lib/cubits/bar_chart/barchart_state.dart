part of 'barchart_cubit.dart';

abstract class BarchartState extends Equatable {
  const BarchartState();

  @override
  List<Object> get props => [];
}

class BarChartLoading extends BarchartState {}

class BarChartLoaded extends BarchartState {
  List<BarChartApiData> data;
  BarChartLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class BarChartError extends BarchartState {
  String error;
  BarChartError(this.error);
  @override
  List<String> get props => [error];
}
