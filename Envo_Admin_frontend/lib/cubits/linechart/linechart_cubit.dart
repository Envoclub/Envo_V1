import 'package:bloc/bloc.dart';
import 'package:envo_admin_dashboard/models/co2_graph.dart';
import 'package:envo_admin_dashboard/repositories/chart_repository.dart';
import 'package:equatable/equatable.dart';

import '../../models/line_chart.dart';

part 'linechart_state.dart';

class LinechartCubit extends Cubit<LinechartState> {
  ChartRepository _repository;
  LinechartCubit(ChartRepository repository)
      : _repository = repository,
        super(LineChartLoading());

  getData(String id) async {
    try {
      emit(LineChartLoading());
      Co2GraphData data = await _repository.getCo2Chart(id);
      emit(LineChartLoaded(data.co2SavedLast7Days!));
    } catch (e) {
      emit(LineChartError(e.toString()));
    }
  }
}
