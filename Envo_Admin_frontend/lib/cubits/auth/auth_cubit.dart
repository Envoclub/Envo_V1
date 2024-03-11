import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:envo_admin_dashboard/models/user_model.dart';
import 'package:envo_admin_dashboard/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository _authRepository;
  AuthCubit(AuthRepository authRepository)
      : _authRepository = authRepository,
        super(AuthLoading());
  FlutterSecureStorage storage = FlutterSecureStorage();
  init() async {
    try {
      emit(AuthLoading());
      String? token = await storage.read(key: "accessToken");
    debugPrint("current access $token refresh");
      if (token != null) {
        //getUser and emit AuthLoggedIn
        UserModel? userModel = await _authRepository.getUserDetails();
        emit(AuthLoggedIn(userModel!));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthLoggedOut());
    }
  }

  login(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.login(email, password);
      await init();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  logout() async {
    try {
      await _authRepository.logout();
      await init();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
