part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  UserModel user;
  AuthLoggedIn(this.user);
  @override
  List<Object> get props => [user];
}

class AuthLoggedOut extends AuthState {}

class AuthError extends AuthState {
  String error;
  DateTime time;
  AuthError(this.error) : time = DateTime.now();
  @override
  List<Object> get props => [error, time];
}

class AuthFlowError extends AuthState {
  String error;
  AuthFlowError(this.error);
  @override
  List<Object> get props => [error];
}

class AuthPasswordResetEmailSent extends AuthState {
  String message;
  AuthPasswordResetEmailSent(this.message);
  @override
  List<Object> get props => [message];
}
