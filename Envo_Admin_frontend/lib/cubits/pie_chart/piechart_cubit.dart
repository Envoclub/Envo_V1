import 'package:bloc/bloc.dart';
import 'package:envo_admin_dashboard/repositories/chart_repository.dart';
import 'package:equatable/equatable.dart';

import '../../models/pie_chart.dart';



part 'piechart_state.dart';

class PiechartCubit extends Cubit<PiechartState> {
  ChartRepository _repository;
  PiechartCubit(ChartRepository repository)
      : _repository = repository,
        super(PieChartLoading());

  getData() async {
    try {
      emit(PieChartLoading());
     List<PieChartApiData> data = await _repository.getPieChart();
      emit(PieChartLoaded(data));
    } catch (e) {
      emit(PieChartError(e.toString()));
    }
  }
}
