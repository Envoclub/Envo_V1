part of 'tile_data_cubit.dart';

abstract class TileDataState extends Equatable {
  const TileDataState();

  @override
  List<Object> get props => [];
}

class TileDataLoading extends TileDataState {}

class TileDataLoaded extends TileDataState {
  TileData data;
  TileDataLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class TileDataError extends TileDataState {
  String error;
  TileDataError(this.error);
  @override
  List<String> get props=>[error];
}
