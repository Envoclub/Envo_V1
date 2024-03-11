import 'package:bloc/bloc.dart';
import 'package:envo_admin_dashboard/models/bar_chart.dart';
import 'package:envo_admin_dashboard/repositories/chart_repository.dart';
import 'package:equatable/equatable.dart';




part 'barchart_state.dart';

class BarchartCubit extends Cubit<BarchartState> {
  ChartRepository _repository;
  BarchartCubit(ChartRepository repository)
      : _repository = repository,
        super(BarChartLoading());

  getData() async {
    try {
      emit(BarChartLoading());
     List<BarChartApiData> data = await _repository.getBarChart();
      emit(BarChartLoaded(data));
    } catch (e) {
      emit(BarChartError(e.toString()));
    }
  }
}
