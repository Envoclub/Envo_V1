part of 'employee_cubit.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  List<Employee> data;
  EmployeeLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class EmployeeError extends EmployeeState {
  String error;
  EmployeeError(this.error);
  @override
  List<String> get props => [error];
}
