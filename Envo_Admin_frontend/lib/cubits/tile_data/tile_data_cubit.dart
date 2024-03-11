import 'package:bloc/bloc.dart';
import 'package:envo_admin_dashboard/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

import '../../models/tile_data.dart';

part 'tile_data_state.dart';

class TileDataCubit extends Cubit<TileDataState> {
  AuthRepository _authRepository;
  TileDataCubit(AuthRepository authRepository)
      : _authRepository = authRepository,
        super(TileDataLoading());
  getData() async {
    try {
      emit(TileDataLoading());
      TileData data = await _authRepository.getTileDetails();
      emit(TileDataLoaded(data));
    } catch (e) {
      emit(TileDataError(e.toString()));
    }
  }
}
