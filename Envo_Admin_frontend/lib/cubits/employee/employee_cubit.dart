import 'package:bloc/bloc.dart';
import 'package:envo_admin_dashboard/repositories/chart_repository.dart';
import 'package:envo_admin_dashboard/utils/helper_widgets.dart';
import 'package:equatable/equatable.dart';

import '../../models/employee_model.dart';
import '../../models/pie_chart.dart';
import '../../repositories/employee_repository.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeRepository _repository;
  EmployeeCubit(EmployeeRepository repository)
      : _repository = repository,
        super(EmployeeLoading());

  getData() async {
    try {
      emit(EmployeeLoading());
      List<Employee> data = await _repository.getEmployee();
      emit(EmployeeLoaded(data));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<dynamic?> addEmployee(
      {required String email,
      required String username,
      required String password,
      required int companyID}) async {
    try {
      emit(EmployeeLoading());
      bool data = await _repository.addEmployee(
          email: email,
          username: username,
          password: password,
          companyID: companyID);
      getData();
      if (data) {
        return data;
      }
    } catch (e) {
       return e.toString();
    }
  }

  Future<dynamic?> deleteEmployee(
      {required String pk, required String companyID}) async {
    try {
      emit(EmployeeLoading());
      bool data =
          await _repository.deleteEmployee(companyID: companyID, pk: pk);
      getData();
      if (data) {
        return data;
      }
    } catch (e) {
      return e.toString();
      // emit(EmployeeError(e.toString()));
    }
  }
}
